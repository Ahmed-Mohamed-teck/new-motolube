#!/usr/bin/env python3
"""Decision pilot for quantization-induced Arabic answer failures.

This script intentionally evaluates quality only. Quantized weights are immediately
 dequantized back to floating point before CPU inference, so runtime memory/speed
claims are outside the scope of this pilot.
"""

from __future__ import annotations

import argparse
import gc
import json
import math
import os
import random
import time
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd
import requests
import torch
from scipy.stats import binomtest
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import average_precision_score, roc_auc_score
from sklearn.model_selection import StratifiedKFold, cross_val_predict
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from transformers import AutoModelForCausalLM, AutoTokenizer

DATA_URL = (
    "https://raw.githubusercontent.com/mbzuai-nlp/ArabicMMLU/"
    "main/data/ArabicMMLU.csv"
)
ANSWER_KEYS = {"A": 0, "B": 1, "C": 2, "D": 3, "E": 4}


@dataclass(frozen=True)
class Config:
    model_id: str
    sample_size: int
    seed: int
    batch_size: int
    max_length: int
    group_size: int
    output_dir: str


def set_reproducible(seed: int) -> None:
    os.environ["TOKENIZERS_PARALLELISM"] = "false"
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.set_num_threads(max(1, os.cpu_count() or 1))
    try:
        torch.use_deterministic_algorithms(True, warn_only=True)
    except Exception:
        pass


def download_dataset(cache_path: Path) -> pd.DataFrame:
    cache_path.parent.mkdir(parents=True, exist_ok=True)
    if not cache_path.exists():
        response = requests.get(DATA_URL, timeout=120)
        response.raise_for_status()
        cache_path.write_bytes(response.content)
    return pd.read_csv(cache_path)


def number_of_options(row: pd.Series) -> int:
    count = 0
    for i in range(1, 6):
        value = row.get(f"Option {i}")
        if pd.isna(value) or not str(value).strip():
            break
        count += 1
    return count


def make_prompt(row: pd.Series) -> str:
    context = "" if pd.isna(row.get("Context")) else str(row["Context"]).strip()
    question = str(row["Question"]).strip()
    stem = f"{context}\n\n{question}" if context else question
    n_options = int(row["n_options"])
    options = "\n".join(
        f"{i}) {str(row[f'Option {i}']).strip()}" for i in range(1, n_options + 1)
    )
    return (
        "أجب عن السؤال التالي باختيار رقم واحد فقط من الخيارات، ولا تكتب أي شرح.\n\n"
        f"السؤال:\n{stem}\n\n"
        f"الخيارات:\n{options}\n\n"
        "الإجابة الصحيحة هي الخيار رقم:"
    )


def prepare_sample(raw: pd.DataFrame, sample_size: int, seed: int) -> pd.DataFrame:
    data = raw.copy()
    if "is_few_shot" in data.columns:
        data = data[data["is_few_shot"].fillna(0).astype(int) == 0]
    data = data[data["Answer Key"].isin(ANSWER_KEYS)]
    data = data[data["Question"].notna()].copy()
    data["n_options"] = data.apply(number_of_options, axis=1)
    data = data[data["n_options"] >= 2].copy()
    data["gold"] = data["Answer Key"].map(ANSWER_KEYS).astype(int)
    data["source_row"] = data.index.astype(int)
    data["Subject"] = data["Subject"].fillna("Unknown").astype(str)

    if sample_size > len(data):
        sample_size = len(data)

    rng = np.random.default_rng(seed)
    data = data.assign(_rand=rng.random(len(data)))
    proportions = data["Subject"].value_counts(normalize=True)
    allocations = (proportions * sample_size).apply(math.floor).astype(int)
    allocations[allocations == 0] = 1
    while allocations.sum() > sample_size:
        largest = allocations.idxmax()
        if allocations[largest] > 1:
            allocations[largest] -= 1
        else:
            break
    remainder = sample_size - int(allocations.sum())
    fractional = proportions * sample_size - (proportions * sample_size).apply(math.floor)
    for subject in fractional.sort_values(ascending=False).index:
        if remainder <= 0:
            break
        capacity = int((data["Subject"] == subject).sum())
        if allocations.get(subject, 0) < capacity:
            allocations[subject] = allocations.get(subject, 0) + 1
            remainder -= 1

    pieces: list[pd.DataFrame] = []
    for subject, n in allocations.items():
        group = data[data["Subject"] == subject].sort_values("_rand")
        pieces.append(group.head(min(int(n), len(group))))
    sample = pd.concat(pieces, ignore_index=True)

    if len(sample) < sample_size:
        selected = set(sample["source_row"].tolist())
        extra = data[~data["source_row"].isin(selected)].sort_values("_rand")
        sample = pd.concat([sample, extra.head(sample_size - len(sample))], ignore_index=True)

    sample = sample.sample(frac=1.0, random_state=seed).reset_index(drop=True)
    sample["item_id"] = [f"ammlu_{x}" for x in sample["source_row"]]
    sample["prompt"] = sample.apply(make_prompt, axis=1)
    return sample.drop(columns=["_rand"], errors="ignore")


def candidate_token_ids(tokenizer: Any) -> list[int]:
    ids: list[int] = []
    for i in range(1, 6):
        encoded = tokenizer.encode(str(i), add_special_tokens=False)
        if len(encoded) != 1:
            raise RuntimeError(
                f"Candidate '{i}' is not a single token for this tokenizer: {encoded}"
            )
        ids.append(int(encoded[0]))
    return ids


def load_model(model_id: str) -> Any:
    model = AutoModelForCausalLM.from_pretrained(
        model_id,
        torch_dtype=torch.float32,
        low_cpu_mem_usage=True,
        trust_remote_code=False,
        attn_implementation="eager",
    )
    model.eval()
    return model


def evaluate(
    model: Any,
    tokenizer: Any,
    data: pd.DataFrame,
    batch_size: int,
    max_length: int,
    label_token_ids: list[int],
    variant: str,
) -> pd.DataFrame:
    rows: list[dict[str, Any]] = []
    prompt_column = "model_prompt" if "model_prompt" in data.columns else "prompt"
    prompts = data[prompt_column].tolist()
    n_total = len(prompts)
    started = time.perf_counter()

    with torch.inference_mode():
        for start in range(0, n_total, batch_size):
            batch_prompts = prompts[start : start + batch_size]
            encoded = tokenizer(
                batch_prompts,
                return_tensors="pt",
                padding=True,
                truncation=True,
                max_length=max_length,
                add_special_tokens=True,
            )
            base_outputs = model.model(
                input_ids=encoded["input_ids"],
                attention_mask=encoded["attention_mask"],
                use_cache=False,
                return_dict=True,
            )
            last_hidden = base_outputs.last_hidden_state[:, -1, :]
            logits = model.lm_head(last_hidden).float()
            option_logits = logits[:, label_token_ids]

            batch_n_options = data.iloc[start : start + len(batch_prompts)][
                "n_options"
            ].to_numpy(dtype=int)
            for j, n_options in enumerate(batch_n_options):
                if n_options < 5:
                    option_logits[j, n_options:] = -torch.inf

            probs = torch.softmax(option_logits, dim=-1)
            top2_probs, top2_idx = torch.topk(probs, k=2, dim=-1)
            pred = torch.argmax(probs, dim=-1)
            entropy = -(probs.clamp_min(1e-12) * probs.clamp_min(1e-12).log()).sum(dim=-1)
            normalizer = torch.log(torch.tensor(batch_n_options, dtype=torch.float32))
            normalized_entropy = entropy / normalizer
            token_lengths = encoded["attention_mask"].sum(dim=1)

            for j in range(len(batch_prompts)):
                rows.append(
                    {
                        "item_id": data.iloc[start + j]["item_id"],
                        f"{variant}_pred": int(pred[j].item()),
                        f"{variant}_confidence": float(top2_probs[j, 0].item()),
                        f"{variant}_margin": float(
                            (top2_probs[j, 0] - top2_probs[j, 1]).item()
                        ),
                        f"{variant}_entropy": float(normalized_entropy[j].item()),
                        f"{variant}_top2": int(top2_idx[j, 1].item()),
                        f"{variant}_token_length": int(token_lengths[j].item()),
                        **{
                            f"{variant}_p{k + 1}": float(probs[j, k].item())
                            for k in range(5)
                        },
                    }
                )

            if (start // batch_size) % 20 == 0:
                elapsed = time.perf_counter() - started
                print(
                    f"[{variant}] {min(start + batch_size, n_total)}/{n_total} "
                    f"items, elapsed={elapsed:.1f}s",
                    flush=True,
                )

    result = pd.DataFrame(rows)
    result.attrs["elapsed_seconds"] = time.perf_counter() - started
    return result


def quantize_dequantize_model(
    model: Any, bits: int, group_size: int
) -> tuple[pd.DataFrame, dict[str, float]]:
    qmax = (1 << (bits - 1)) - 1
    if qmax <= 0:
        raise ValueError("bits must be >= 2")

    stats: list[dict[str, Any]] = []
    total_sq_error = 0.0
    total_sq_weight = 0.0
    total_numel = 0

    with torch.no_grad():
        for name, module in model.named_modules():
            if not isinstance(module, torch.nn.Linear):
                continue
            if name == "lm_head" or name.endswith(".lm_head"):
                continue
            weight = module.weight.data
            original_shape = weight.shape
            if weight.ndim != 2:
                continue

            rows, cols = original_shape
            pad = (-cols) % group_size
            work = torch.nn.functional.pad(weight, (0, pad)) if pad else weight
            grouped = work.reshape(rows, -1, group_size)
            max_abs = grouped.abs().amax(dim=-1, keepdim=True)
            scale = torch.where(max_abs > 0, max_abs / qmax, torch.ones_like(max_abs))
            quant = torch.clamp(torch.round(grouped / scale), -qmax, qmax)
            dequant = (quant * scale).reshape(rows, -1)[:, :cols]

            diff = dequant - weight
            sq_error = float(torch.sum(diff * diff).item())
            sq_weight = float(torch.sum(weight * weight).item())
            numel = int(weight.numel())
            stats.append(
                {
                    "layer": name,
                    "bits": bits,
                    "group_size": group_size,
                    "numel": numel,
                    "mse": sq_error / max(numel, 1),
                    "nmse": sq_error / max(sq_weight, 1e-30),
                    "max_abs_error": float(diff.abs().max().item()),
                    "mean_scale": float(scale.mean().item()),
                }
            )
            weight.copy_(dequant)
            total_sq_error += sq_error
            total_sq_weight += sq_weight
            total_numel += numel
            del work, grouped, max_abs, scale, quant, dequant, diff

    overall = {
        "bits": bits,
        "group_size": group_size,
        "quantized_linear_parameters": total_numel,
        "weighted_mse": total_sq_error / max(total_numel, 1),
        "weighted_nmse": total_sq_error / max(total_sq_weight, 1e-30),
    }
    return pd.DataFrame(stats), overall


def wilson_interval(successes: int, total: int, z: float = 1.959963984540054) -> list[float]:
    if total == 0:
        return [float("nan"), float("nan")]
    p = successes / total
    denom = 1 + z * z / total
    center = (p + z * z / (2 * total)) / denom
    half = z * math.sqrt((p * (1 - p) + z * z / (4 * total)) / total) / denom
    return [center - half, center + half]


def bootstrap_accuracy_delta(
    ref_correct: np.ndarray,
    q_correct: np.ndarray,
    seed: int,
    n_boot: int = 5000,
) -> list[float]:
    rng = np.random.default_rng(seed)
    n = len(ref_correct)
    paired = q_correct.astype(float) - ref_correct.astype(float)
    deltas = np.empty(n_boot, dtype=float)
    for i in range(n_boot):
        idx = rng.integers(0, n, size=n)
        deltas[i] = paired[idx].mean()
    return [float(np.quantile(deltas, 0.025)), float(np.quantile(deltas, 0.975))]


def paired_metrics(df: pd.DataFrame, variant: str, seed: int) -> dict[str, Any]:
    gold = df["gold"].to_numpy()
    ref_correct = df["ref_pred"].to_numpy() == gold
    q_correct = df[f"{variant}_pred"].to_numpy() == gold
    correct_to_wrong = int(np.sum(ref_correct & ~q_correct))
    wrong_to_correct = int(np.sum(~ref_correct & q_correct))
    discordant = correct_to_wrong + wrong_to_correct
    p_value = (
        float(binomtest(min(correct_to_wrong, wrong_to_correct), discordant, 0.5).pvalue)
        if discordant
        else 1.0
    )
    pred_changed = int(
        np.sum(df["ref_pred"].to_numpy() != df[f"{variant}_pred"].to_numpy())
    )
    baseline_correct_total = int(ref_correct.sum())
    return {
        "accuracy": float(q_correct.mean()),
        "accuracy_delta_vs_reference": float(q_correct.mean() - ref_correct.mean()),
        "accuracy_delta_bootstrap_95ci": bootstrap_accuracy_delta(
            ref_correct, q_correct, seed
        ),
        "correct_to_wrong_flips": correct_to_wrong,
        "wrong_to_correct_recoveries": wrong_to_correct,
        "net_correctness_loss": correct_to_wrong - wrong_to_correct,
        "conditional_flip_rate_among_reference_correct": (
            correct_to_wrong / baseline_correct_total if baseline_correct_total else float("nan")
        ),
        "conditional_flip_rate_wilson_95ci": wilson_interval(
            correct_to_wrong, baseline_correct_total
        ),
        "prediction_changes": pred_changed,
        "prediction_change_rate": pred_changed / len(df),
        "prediction_change_wilson_95ci": wilson_interval(pred_changed, len(df)),
        "mcnemar_exact_two_sided_p": p_value,
        "discordant_correctness_pairs": discordant,
    }


def build_predictor_features(df: pd.DataFrame) -> tuple[pd.DataFrame, np.ndarray]:
    features = pd.DataFrame(
        {
            "confidence": df["w4_confidence"],
            "margin": df["w4_margin"],
            "entropy": df["w4_entropy"],
            "token_length": df["w4_token_length"],
            "n_options": df["n_options"],
            "predicted_option": df["w4_pred"].astype(str),
            "subject": df["Subject"].astype(str),
            "level": df["Level"].fillna("Unknown").astype(str),
            "country": df["Country"].fillna("Unknown").astype(str),
        }
    )
    y = (
        (df["ref_pred"] == df["gold"]) & (df["w4_pred"] != df["gold"])
    ).astype(int).to_numpy()
    return features, y


def evaluate_risk_predictors(
    df: pd.DataFrame, seed: int
) -> tuple[dict[str, Any], pd.DataFrame]:
    X, y = build_predictor_features(df)
    positives = int(y.sum())
    negatives = int((1 - y).sum())
    if positives < 5 or negatives < 5:
        return {
            "status": "insufficient_positive_or_negative_examples",
            "positives": positives,
            "negatives": negatives,
        }, pd.DataFrame()

    n_splits = min(5, positives, negatives)
    cv = StratifiedKFold(n_splits=n_splits, shuffle=True, random_state=seed)
    numeric = ["confidence", "margin", "entropy", "token_length", "n_options"]
    categorical = ["predicted_option", "subject", "level", "country"]
    preprocess = ColumnTransformer(
        [
            (
                "num",
                Pipeline(
                    [
                        ("impute", SimpleImputer(strategy="median")),
                        ("scale", StandardScaler()),
                    ]
                ),
                numeric,
            ),
            (
                "cat",
                OneHotEncoder(handle_unknown="ignore", min_frequency=2),
                categorical,
            ),
        ]
    )

    models: dict[str, Any] = {
        "logistic": LogisticRegression(
            max_iter=3000, class_weight="balanced", random_state=seed
        ),
        "random_forest": RandomForestClassifier(
            n_estimators=400,
            min_samples_leaf=4,
            class_weight="balanced_subsample",
            random_state=seed,
            n_jobs=-1,
        ),
    }

    output = pd.DataFrame({"item_id": df["item_id"], "flip_label": y})
    metrics: dict[str, Any] = {
        "status": "ok",
        "positives": positives,
        "negatives": negatives,
        "prevalence": positives / len(y),
        "folds": n_splits,
        "models": {},
    }

    for name, estimator in models.items():
        pipe = Pipeline([("preprocess", preprocess), ("model", estimator)])
        scores = cross_val_predict(
            pipe,
            X,
            y,
            cv=cv,
            method="predict_proba",
            n_jobs=1,
        )[:, 1]
        output[f"{name}_risk"] = scores
        model_metrics: dict[str, Any] = {
            "auroc": float(roc_auc_score(y, scores)),
            "auprc": float(average_precision_score(y, scores)),
        }
        for budget in (0.05, 0.10, 0.15, 0.20):
            k = max(1, int(round(len(y) * budget)))
            idx = np.argsort(-scores)[:k]
            recall = float(y[idx].sum() / positives)
            precision = float(y[idx].mean())
            model_metrics[f"recall_at_{int(budget*100)}pct"] = recall
            model_metrics[f"precision_at_{int(budget*100)}pct"] = precision
            model_metrics[f"lift_at_{int(budget*100)}pct"] = (
                precision / (positives / len(y))
            )
        metrics["models"][name] = model_metrics

    best_name = max(
        metrics["models"], key=lambda n: metrics["models"][n]["auprc"]
    )
    metrics["selected_model"] = best_name
    return metrics, output


def routing_curve(
    df: pd.DataFrame, predictor_output: pd.DataFrame, selected_model: str | None
) -> pd.DataFrame:
    base_pred = df["ref_pred"].to_numpy()
    q_pred = df["w4_pred"].to_numpy()
    gold = df["gold"].to_numpy()
    flip = ((base_pred == gold) & (q_pred != gold)).astype(int)
    harmful_recovery = ((base_pred != gold) & (q_pred == gold)).astype(int)
    n = len(df)

    if selected_model and not predictor_output.empty:
        risk = predictor_output[f"{selected_model}_risk"].to_numpy()
    else:
        risk = df["w4_entropy"].to_numpy()

    rows: list[dict[str, Any]] = []
    q4_acc = float(np.mean(q_pred == gold))
    for budget in (0.0, 0.05, 0.10, 0.15, 0.20, 0.30):
        k = int(round(n * budget))
        routed = np.zeros(n, dtype=bool)
        if k > 0:
            routed[np.argsort(-risk)[:k]] = True
        hybrid = q_pred.copy()
        hybrid[routed] = base_pred[routed]
        rows.append(
            {
                "route_budget": budget,
                "routed_items": int(routed.sum()),
                "hybrid_accuracy": float(np.mean(hybrid == gold)),
                "absolute_gain_vs_w4": float(np.mean(hybrid == gold) - q4_acc),
                "flips_recovered": int(np.sum(routed & (flip == 1))),
                "flip_recall": float(
                    np.sum(routed & (flip == 1)) / max(flip.sum(), 1)
                ),
                "harmful_reversions": int(
                    np.sum(routed & (harmful_recovery == 1))
                ),
            }
        )
    return pd.DataFrame(rows)


def fmt_pct(value: float) -> str:
    return f"{100 * value:.2f}%"


def make_report(
    cfg: Config,
    summary: dict[str, Any],
    routing: pd.DataFrame,
    flip_examples: pd.DataFrame,
) -> str:
    ref = summary["reference"]
    w8 = summary["w8"]
    w4 = summary["w4"]
    predictor = summary["predictor"]
    lines = [
        "# Arabic Quantization-Induced Answer-Flip Pilot",
        "",
        f"- Model: `{cfg.model_id}`",
        f"- ArabicMMLU sample: **{cfg.sample_size}** zero-shot items (seed {cfg.seed})",
        f"- Reference: FP32; comparisons: W8A16 and W4A16 fake-quantized weights, group size {cfg.group_size}",
        "- Scoring: deterministic next-token likelihood over valid option digits",
        "",
        "## Primary results",
        "",
        "| Metric | FP32 | W8A16 | W4A16 |",
        "|---|---:|---:|---:|",
        f"| Accuracy | {fmt_pct(ref['accuracy'])} | {fmt_pct(w8['accuracy'])} | {fmt_pct(w4['accuracy'])} |",
        f"| Correct → wrong flips | — | {w8['correct_to_wrong_flips']} | {w4['correct_to_wrong_flips']} |",
        f"| Wrong → correct recoveries | — | {w8['wrong_to_correct_recoveries']} | {w4['wrong_to_correct_recoveries']} |",
        f"| Any prediction change | — | {w8['prediction_changes']} | {w4['prediction_changes']} |",
        "",
        "### W4 paired inference",
        "",
        f"- Accuracy delta: **{fmt_pct(w4['accuracy_delta_vs_reference'])}**; paired bootstrap 95% CI "
        f"[{fmt_pct(w4['accuracy_delta_bootstrap_95ci'][0])}, {fmt_pct(w4['accuracy_delta_bootstrap_95ci'][1])}].",
        f"- Conditional correct→wrong flip rate among FP32-correct items: **{fmt_pct(w4['conditional_flip_rate_among_reference_correct'])}**; "
        f"Wilson 95% CI [{fmt_pct(w4['conditional_flip_rate_wilson_95ci'][0])}, {fmt_pct(w4['conditional_flip_rate_wilson_95ci'][1])}].",
        f"- Exact McNemar p-value: **{w4['mcnemar_exact_two_sided_p']:.6g}**.",
        "",
        "## Risk prediction",
        "",
    ]
    if predictor.get("status") == "ok":
        lines.append(
            f"Positive examples: {predictor['positives']} ({fmt_pct(predictor['prevalence'])}). "
            f"Selected out-of-fold model: **{predictor['selected_model']}**."
        )
        lines.extend(
            [
                "",
                "| Model | AUROC | AUPRC | Recall@10% | Lift@10% |",
                "|---|---:|---:|---:|---:|",
            ]
        )
        for name, values in predictor["models"].items():
            lines.append(
                f"| {name} | {values['auroc']:.3f} | {values['auprc']:.3f} | "
                f"{values['recall_at_10pct']:.3f} | {values['lift_at_10pct']:.2f}× |"
            )
    else:
        lines.append(
            "A supervised risk predictor was not fitted because the sample contained too few "
            "positive or negative transitions."
        )

    lines.extend(
        [
            "",
            "## Selective FP32 fallback using out-of-fold risk",
            "",
            routing.to_markdown(index=False),
            "",
            "## Interpretation guardrails",
            "",
            "1. This is a decision pilot on multiple-choice factuality, not yet a full free-form hallucination benchmark.",
            "2. Fake quantization isolates quality loss but does not measure packed INT4 latency or memory.",
            "3. One model and one benchmark cannot establish cross-model generality; a thesis should add at least two larger Arabic-capable models and generative evaluation.",
            "4. Statistical significance does not by itself imply practical importance; transition counts, confidence intervals, and mitigation gains must be considered together.",
            "",
            "## Sample W4 correct→wrong transitions",
            "",
        ]
    )
    if flip_examples.empty:
        lines.append("No W4 correct→wrong transitions were observed in this sample.")
    else:
        display_cols = [
            "item_id",
            "Subject",
            "Question",
            "gold_human",
            "ref_human",
            "w4_human",
            "ref_confidence",
            "w4_confidence",
            "w4_margin",
            "w4_entropy",
        ]
        lines.append(flip_examples[display_cols].head(20).to_markdown(index=False))
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-id", default="Qwen/Qwen3-0.6B")
    parser.add_argument("--sample-size", type=int, default=1200)
    parser.add_argument("--seed", type=int, default=20260829)
    parser.add_argument("--batch-size", type=int, default=8)
    parser.add_argument("--max-length", type=int, default=384)
    parser.add_argument("--group-size", type=int, default=128)
    parser.add_argument(
        "--output-dir", default="research/arabic_quant_pilot/results"
    )
    args = parser.parse_args()
    cfg = Config(
        model_id=args.model_id,
        sample_size=args.sample_size,
        seed=args.seed,
        batch_size=args.batch_size,
        max_length=args.max_length,
        group_size=args.group_size,
        output_dir=args.output_dir,
    )
    set_reproducible(cfg.seed)
    out_dir = Path(cfg.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    cache_path = out_dir.parent / "cache" / "ArabicMMLU.csv"

    raw = download_dataset(cache_path)
    data = prepare_sample(raw, cfg.sample_size, cfg.seed)
    cfg = Config(**{**asdict(cfg), "sample_size": len(data)})

    tokenizer = AutoTokenizer.from_pretrained(cfg.model_id, use_fast=True)
    tokenizer.padding_side = "left"
    if tokenizer.pad_token_id is None:
        tokenizer.pad_token = tokenizer.eos_token
    label_ids = candidate_token_ids(tokenizer)
    if getattr(tokenizer, "chat_template", None):
        formatted: list[str] = []
        for prompt in data["prompt"].tolist():
            messages = [{"role": "user", "content": prompt}]
            try:
                text = tokenizer.apply_chat_template(
                    messages,
                    tokenize=False,
                    add_generation_prompt=True,
                    enable_thinking=False,
                )
            except TypeError:
                text = tokenizer.apply_chat_template(
                    messages, tokenize=False, add_generation_prompt=True
                )
            formatted.append(text)
        data["model_prompt"] = formatted
    else:
        data["model_prompt"] = data["prompt"]

    all_results = data[
        [
            "item_id",
            "source_row",
            "Subject",
            "Level",
            "Country",
            "Question",
            "Context",
            "Option 1",
            "Option 2",
            "Option 3",
            "Option 4",
            "Option 5",
            "n_options",
            "gold",
            "prompt",
            "model_prompt",
        ]
    ].copy()
    timing: dict[str, float] = {}
    quantization: dict[str, Any] = {}

    model = load_model(cfg.model_id)
    ref = evaluate(
        model,
        tokenizer,
        data,
        cfg.batch_size,
        cfg.max_length,
        label_ids,
        "ref",
    )
    timing["reference_seconds"] = float(ref.attrs["elapsed_seconds"])
    all_results = all_results.merge(ref, on="item_id", how="left", validate="one_to_one")

    control_n = min(100, len(data))
    control = evaluate(
        model,
        tokenizer,
        data.head(control_n),
        cfg.batch_size,
        cfg.max_length,
        label_ids,
        "control",
    )
    control_matches = int(
        np.sum(
            ref.head(control_n)["ref_pred"].to_numpy()
            == control["control_pred"].to_numpy()
        )
    )
    del model, control
    gc.collect()

    for bits, variant in ((8, "w8"), (4, "w4")):
        model = load_model(cfg.model_id)
        layer_stats, overall_q = quantize_dequantize_model(
            model, bits=bits, group_size=cfg.group_size
        )
        layer_stats.to_csv(out_dir / f"{variant}_layer_quantization.csv", index=False)
        quantization[variant] = overall_q
        result = evaluate(
            model,
            tokenizer,
            data,
            cfg.batch_size,
            cfg.max_length,
            label_ids,
            variant,
        )
        timing[f"{variant}_seconds"] = float(result.attrs["elapsed_seconds"])
        all_results = all_results.merge(
            result, on="item_id", how="left", validate="one_to_one"
        )
        del model, result, layer_stats
        gc.collect()

    all_results["ref_correct"] = all_results["ref_pred"] == all_results["gold"]
    all_results["w8_correct"] = all_results["w8_pred"] == all_results["gold"]
    all_results["w4_correct"] = all_results["w4_pred"] == all_results["gold"]
    all_results["w8_correct_to_wrong"] = (
        all_results["ref_correct"] & ~all_results["w8_correct"]
    )
    all_results["w4_correct_to_wrong"] = (
        all_results["ref_correct"] & ~all_results["w4_correct"]
    )
    all_results["w8_wrong_to_correct"] = (
        ~all_results["ref_correct"] & all_results["w8_correct"]
    )
    all_results["w4_wrong_to_correct"] = (
        ~all_results["ref_correct"] & all_results["w4_correct"]
    )

    predictor_metrics, predictor_output = evaluate_risk_predictors(
        all_results, cfg.seed
    )
    selected = (
        predictor_metrics.get("selected_model")
        if predictor_metrics.get("status") == "ok"
        else None
    )
    routing = routing_curve(all_results, predictor_output, selected)

    reference_accuracy = float(all_results["ref_correct"].mean())
    summary: dict[str, Any] = {
        "run": {
            **asdict(cfg),
            "dataset_url": DATA_URL,
            "github_run_id": os.environ.get("GITHUB_RUN_ID"),
            "torch_version": torch.__version__,
            "transformers_model": cfg.model_id,
            "label_token_ids": label_ids,
            "determinism_control_items": control_n,
            "determinism_control_exact_matches": control_matches,
            "determinism_control_passed": control_matches == control_n,
            "timing_seconds": timing,
        },
        "reference": {
            "accuracy": reference_accuracy,
            "correct_items": int(all_results["ref_correct"].sum()),
            "total_items": len(all_results),
        },
        "w8": paired_metrics(all_results, "w8", cfg.seed + 8),
        "w4": paired_metrics(all_results, "w4", cfg.seed + 4),
        "quantization_error": quantization,
        "predictor": predictor_metrics,
        "routing": routing.to_dict(orient="records"),
    }

    flip_examples = all_results[all_results["w4_correct_to_wrong"]].copy()
    flip_examples["gold_human"] = flip_examples["gold"] + 1
    flip_examples["ref_human"] = flip_examples["ref_pred"] + 1
    flip_examples["w4_human"] = flip_examples["w4_pred"] + 1
    flip_examples = flip_examples.sort_values(
        ["w4_confidence", "w4_margin"], ascending=[False, True]
    )

    all_results.to_csv(out_dir / "per_question_results.csv", index=False)
    flip_examples.to_csv(out_dir / "w4_correct_to_wrong_examples.csv", index=False)
    routing.to_csv(out_dir / "routing_curve.csv", index=False)
    if not predictor_output.empty:
        predictor_output.to_csv(out_dir / "predictor_oof_scores.csv", index=False)
    with (out_dir / "summary.json").open("w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=2, allow_nan=False)
    (out_dir / "REPORT.md").write_text(
        make_report(cfg, summary, routing, flip_examples), encoding="utf-8"
    )
    (out_dir / "config.json").write_text(
        json.dumps(asdict(cfg), ensure_ascii=False, indent=2), encoding="utf-8"
    )

    print(json.dumps(summary, ensure_ascii=False, indent=2, allow_nan=False))


if __name__ == "__main__":
    main()
