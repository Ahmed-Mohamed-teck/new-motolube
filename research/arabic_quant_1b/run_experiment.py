#!/usr/bin/env python3
"""Reproducible Arabic quantization-induced answer-flip experiment.

Evaluates one fixed stratified ArabicMMLU sample with the same IBM Granite
checkpoint represented as F16, Q8_0 and Q4_K_M GGUF files. Each item is
answered deterministically under a grammar that permits only its valid answer
labels. Results are paired question-by-question.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import signal
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

import numpy as np
import pandas as pd
import requests
from scipy.stats import binomtest
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import average_precision_score, roc_auc_score
from sklearn.model_selection import GroupKFold
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

SEED = 20260829
LABELS = ["A", "B", "C", "D", "E"]
OPTION_COLS = [f"Option {i}" for i in range(1, 6)]
MODEL_SPECS = {
    "f16": "granite-3.0-1b-a400m-instruct-f16.gguf",
    "q8": "granite-3.0-1b-a400m-instruct-Q8_0.gguf",
    "q4": "granite-3.0-1b-a400m-instruct-Q4_K_M.gguf",
}


@dataclass(frozen=True)
class Paths:
    root: Path
    models: Path
    data: Path
    results: Path
    logs: Path
    server: Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parent)
    parser.add_argument("--sample-size", type=int, default=500)
    parser.add_argument("--ctx-size", type=int, default=2048)
    parser.add_argument("--threads", type=int, default=max(1, min(2, os.cpu_count() or 1)))
    parser.add_argument("--max-prompt-chars", type=int, default=4500)
    parser.add_argument("--bootstrap", type=int, default=10000)
    return parser.parse_args()


def sha256_file(path: Path, chunk_size: int = 16 * 1024 * 1024) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        while chunk := f.read(chunk_size):
            h.update(chunk)
    return h.hexdigest()


def setup_paths(args: argparse.Namespace) -> Paths:
    root = args.root.resolve()
    paths = Paths(
        root=root,
        models=root / "models",
        data=root / "data",
        results=root / "results",
        logs=root / "logs",
        server=root / "llama.cpp" / "build" / "bin" / "llama-server",
    )
    for p in (paths.models, paths.data, paths.results, paths.logs):
        p.mkdir(parents=True, exist_ok=True)
    if not paths.server.exists():
        raise FileNotFoundError(f"llama-server was not found at {paths.server}")
    for filename in MODEL_SPECS.values():
        if not (paths.models / filename).exists():
            raise FileNotFoundError(f"Missing model: {paths.models / filename}")
    if not (paths.data / "ArabicMMLU.csv").exists():
        raise FileNotFoundError("Missing data/ArabicMMLU.csv")
    return paths


def normalize_text(value: Any) -> str:
    if pd.isna(value):
        return ""
    return re.sub(r"\s+", " ", str(value)).strip()


def valid_options(row: pd.Series) -> list[str]:
    values: list[str] = []
    for col in OPTION_COLS:
        value = normalize_text(row.get(col, ""))
        if not value:
            break
        values.append(value)
    return values


def build_user_question(row: pd.Series) -> str:
    context = normalize_text(row.get("Context", ""))
    question = normalize_text(row.get("Question", ""))
    options = valid_options(row)
    option_lines = "\n".join(f"{LABELS[i]}) {option}" for i, option in enumerate(options))
    context_block = f"السياق: {context}\n" if context else ""
    return (
        "اختر الإجابة الصحيحة للسؤال التالي. لا تشرح ولا تضف أي كلمات. "
        "أجب بحرف إنجليزي واحد فقط من الحروف المعروضة.\n\n"
        f"{context_block}السؤال: {question}\n\n{option_lines}\n\nالإجابة:"
    )


def build_prompt(row: pd.Series) -> str:
    system = (
        "أنت مساعد دقيق في أسئلة الاختيار من متعدد باللغة العربية. "
        "التزم بحرف الإجابة فقط دون شرح."
    )
    user = build_user_question(row)
    return (
        "<|start_of_role|>system<|end_of_role|>"
        f"{system}<|end_of_text|>\n"
        "<|start_of_role|>user<|end_of_role|>"
        f"{user}<|end_of_text|>\n"
        "<|start_of_role|>assistant<|end_of_role|>"
    )


def prepare_sample(paths: Paths, sample_size: int, max_prompt_chars: int) -> pd.DataFrame:
    sample_path = paths.results / "fixed_sample.csv"
    if sample_path.exists():
        return pd.read_csv(sample_path)

    df = pd.read_csv(paths.data / "ArabicMMLU.csv")
    required = {"Question", "Answer Key", "Subject", "is_few_shot", *OPTION_COLS[:4]}
    missing = required - set(df.columns)
    if missing:
        raise ValueError(f"ArabicMMLU is missing required columns: {sorted(missing)}")

    df = df[df["is_few_shot"].astype(str).isin(["0", "0.0", "False", "false"])].copy()
    df["Answer Key"] = df["Answer Key"].astype(str).str.strip().str.upper()
    df["n_options"] = df.apply(lambda r: len(valid_options(r)), axis=1)
    df = df[df["n_options"].between(2, 5)]
    df = df[df.apply(lambda r: r["Answer Key"] in LABELS[: int(r["n_options"])], axis=1)]
    df["prompt"] = df.apply(build_prompt, axis=1)
    df["prompt_chars"] = df["prompt"].str.len()
    df = df[df["prompt_chars"] <= max_prompt_chars].copy()
    df["Subject"] = df["Subject"].fillna("Unknown").astype(str)
    df["Level"] = df.get("Level", pd.Series(index=df.index, dtype=object)).fillna("Unknown").astype(str)
    df["Country"] = df.get("Country", pd.Series(index=df.index, dtype=object)).fillna("Unknown").astype(str)
    df["source_row"] = df.index.astype(int)

    if len(df) < sample_size:
        raise ValueError(f"Only {len(df)} eligible rows remain; requested {sample_size}")

    rng = np.random.default_rng(SEED)
    subjects = sorted(df["Subject"].unique())
    base = sample_size // len(subjects)
    remainder = sample_size % len(subjects)
    chosen: list[int] = []
    leftovers: list[int] = []

    for i, subject in enumerate(subjects):
        group = df[df["Subject"] == subject]
        target = base + (1 if i < remainder else 0)
        take = min(target, len(group))
        picked = rng.choice(group.index.to_numpy(), size=take, replace=False).tolist()
        chosen.extend(picked)
        leftovers.extend([int(x) for x in group.index if x not in set(picked)])

    if len(chosen) < sample_size:
        remaining = sample_size - len(chosen)
        chosen.extend(rng.choice(np.array(leftovers), size=remaining, replace=False).tolist())

    sample = df.loc[chosen].sample(frac=1.0, random_state=SEED).reset_index(drop=True)
    sample.insert(0, "question_id", [f"AMMLU-{i:04d}" for i in range(len(sample))])

    keep = [
        "question_id", "source_row", "Subject", "Level", "Country", "Context", "Question",
        *OPTION_COLS, "Answer Key", "n_options", "prompt_chars", "prompt",
    ]
    sample[keep].to_csv(sample_path, index=False)
    return sample[keep]


def wait_for_server(port: int, process: subprocess.Popen[str], timeout_s: int = 300) -> None:
    deadline = time.time() + timeout_s
    url = f"http://127.0.0.1:{port}/health"
    last_error = ""
    while time.time() < deadline:
        if process.poll() is not None:
            raise RuntimeError(f"llama-server exited early with code {process.returncode}")
        try:
            response = requests.get(url, timeout=3)
            if response.status_code == 200:
                return
            last_error = f"HTTP {response.status_code}: {response.text[:200]}"
        except requests.RequestException as exc:
            last_error = repr(exc)
        time.sleep(2)
    raise TimeoutError(f"Server did not become ready: {last_error}")


def start_server(paths: Paths, model_path: Path, port: int, args: argparse.Namespace, label: str) -> tuple[subprocess.Popen[str], Any]:
    log_handle = (paths.logs / f"server_{label}.log").open("w", encoding="utf-8")
    command = [
        str(paths.server),
        "-m", str(model_path),
        "-c", str(args.ctx_size),
        "-t", str(args.threads),
        "-b", "512",
        "-ub", "512",
        "-np", "1",
        "--host", "127.0.0.1",
        "--port", str(port),
    ]
    print("Starting:", " ".join(command), flush=True)
    process = subprocess.Popen(
        command,
        stdout=log_handle,
        stderr=subprocess.STDOUT,
        text=True,
        start_new_session=True,
    )
    wait_for_server(port, process)
    return process, log_handle


def stop_server(process: subprocess.Popen[str], log_handle: Any) -> None:
    try:
        os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=30)
    except Exception:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except Exception:
            pass
    finally:
        log_handle.close()


def extract_probabilities(payload: dict[str, Any], valid_labels: list[str]) -> dict[str, float]:
    found: dict[str, float] = {}
    blocks = payload.get("completion_probabilities") or []
    if not blocks:
        return found
    first = blocks[0] or {}
    candidates = first.get("probs") or first.get("top_logprobs") or []
    if isinstance(candidates, dict):
        candidates = [{"tok_str": token, "logprob": lp} for token, lp in candidates.items()]
    for item in candidates:
        token = str(item.get("tok_str", item.get("token", ""))).strip()
        match = re.fullmatch(r"[A-E]", token)
        if not match or match.group(0) not in valid_labels:
            continue
        if item.get("prob") is not None:
            prob = float(item["prob"])
        elif item.get("logprob") is not None:
            prob = float(math.exp(float(item["logprob"])))
        else:
            continue
        found[match.group(0)] = prob
    return found


def summarize_probs(probabilities: dict[str, float], valid_labels: list[str], prediction: str) -> dict[str, float]:
    if not probabilities:
        return {"selected_prob": np.nan, "top_prob": np.nan, "margin": np.nan, "entropy": np.nan, "prob_mass": np.nan}
    raw = np.array([max(0.0, probabilities.get(label, 0.0)) for label in valid_labels], dtype=float)
    mass = float(raw.sum())
    if mass <= 0:
        return {"selected_prob": np.nan, "top_prob": np.nan, "margin": np.nan, "entropy": np.nan, "prob_mass": 0.0}
    normalized = raw / mass
    ordered = np.sort(normalized)[::-1]
    entropy = float(-(normalized[normalized > 0] * np.log(normalized[normalized > 0])).sum())
    selected = float(normalized[valid_labels.index(prediction)]) if prediction in valid_labels else np.nan
    return {
        "selected_prob": selected,
        "top_prob": float(ordered[0]),
        "margin": float(ordered[0] - ordered[1]) if len(ordered) > 1 else float(ordered[0]),
        "entropy": entropy,
        "prob_mass": mass,
    }


def query_item(port: int, row: pd.Series) -> dict[str, Any]:
    valid_labels = LABELS[: int(row["n_options"])]
    grammar = "root ::= (" + " | ".join(json.dumps(x) for x in valid_labels) + ")"
    request_payload = {
        "prompt": row["prompt"],
        "n_predict": 1,
        "temperature": 0.0,
        "seed": SEED,
        "grammar": grammar,
        "n_probs": 16,
        "cache_prompt": True,
    }
    started = time.perf_counter()
    last_error = ""
    for attempt in range(4):
        try:
            response = requests.post(
                f"http://127.0.0.1:{port}/completion",
                json=request_payload,
                timeout=180,
            )
            response.raise_for_status()
            payload = response.json()
            content = str(payload.get("content", "")).strip()
            match = re.search(r"[A-E]", content)
            prediction = match.group(0) if match and match.group(0) in valid_labels else "INVALID"
            probs = extract_probabilities(payload, valid_labels)
            stats = summarize_probs(probs, valid_labels, prediction)
            timings = payload.get("timings") or {}
            return {
                "prediction": prediction,
                "raw_output": content,
                "elapsed_s": time.perf_counter() - started,
                "prompt_ms": timings.get("prompt_ms", np.nan),
                "prompt_n": timings.get("prompt_n", np.nan),
                "predicted_ms": timings.get("predicted_ms", np.nan),
                "predicted_n": timings.get("predicted_n", np.nan),
                **stats,
                **{f"prob_{label}": probs.get(label, np.nan) for label in LABELS},
                "error": "",
            }
        except Exception as exc:
            last_error = repr(exc)
            time.sleep(2 ** attempt)
    return {
        "prediction": "ERROR",
        "raw_output": "",
        "elapsed_s": time.perf_counter() - started,
        "prompt_ms": np.nan,
        "prompt_n": np.nan,
        "predicted_ms": np.nan,
        "predicted_n": np.nan,
        "selected_prob": np.nan,
        "top_prob": np.nan,
        "margin": np.nan,
        "entropy": np.nan,
        "prob_mass": np.nan,
        **{f"prob_{label}": np.nan for label in LABELS},
        "error": last_error,
    }


def evaluate_model(paths: Paths, sample: pd.DataFrame, precision: str, args: argparse.Namespace, port: int) -> pd.DataFrame:
    output_path = paths.results / f"predictions_{precision}.csv"
    existing = pd.read_csv(output_path) if output_path.exists() else pd.DataFrame()
    completed = set(existing.get("question_id", pd.Series(dtype=str)).astype(str))
    records = existing.to_dict("records") if not existing.empty else []

    model_path = paths.models / MODEL_SPECS[precision]
    process, log_handle = start_server(paths, model_path, port, args, precision)
    try:
        for idx, row in sample.iterrows():
            if str(row["question_id"]) in completed:
                continue
            result = query_item(port, row)
            record = {
                "question_id": row["question_id"],
                "precision": precision,
                "gold": row["Answer Key"],
                "subject": row["Subject"],
                "level": row["Level"],
                "country": row["Country"],
                "n_options": int(row["n_options"]),
                "prompt_chars": int(row["prompt_chars"]),
                **result,
            }
            record["correct"] = int(record["prediction"] == record["gold"])
            records.append(record)
            if len(records) % 10 == 0 or len(records) == len(sample):
                pd.DataFrame(records).to_csv(output_path, index=False)
                print(
                    f"[{precision}] {len(records)}/{len(sample)} | "
                    f"accuracy={pd.DataFrame(records)['correct'].mean():.4f}",
                    flush=True,
                )
    finally:
        stop_server(process, log_handle)
    result_df = pd.DataFrame(records)
    result_df.to_csv(output_path, index=False)
    return result_df


def wilson_interval(successes: int, total: int, z: float = 1.959963984540054) -> tuple[float, float]:
    if total == 0:
        return (float("nan"), float("nan"))
    p = successes / total
    denom = 1 + z * z / total
    center = (p + z * z / (2 * total)) / denom
    half = z * math.sqrt((p * (1 - p) + z * z / (4 * total)) / total) / denom
    return max(0.0, center - half), min(1.0, center + half)


def bootstrap_accuracy_difference(a: np.ndarray, b: np.ndarray, iterations: int) -> tuple[float, float, float]:
    rng = np.random.default_rng(SEED)
    n = len(a)
    diffs = np.empty(iterations, dtype=float)
    for i in range(iterations):
        indices = rng.integers(0, n, size=n)
        diffs[i] = b[indices].mean() - a[indices].mean()
    return float((b - a).mean()), float(np.quantile(diffs, 0.025)), float(np.quantile(diffs, 0.975))


def paired_stats(base: pd.DataFrame, other: pd.DataFrame, other_name: str, bootstrap: int) -> dict[str, Any]:
    joined = base[["question_id", "correct", "prediction"]].merge(
        other[["question_id", "correct", "prediction"]], on="question_id", suffixes=("_f16", f"_{other_name}")
    )
    f = joined["correct_f16"].to_numpy(dtype=int)
    q = joined[f"correct_{other_name}"].to_numpy(dtype=int)
    correct_to_wrong = int(((f == 1) & (q == 0)).sum())
    wrong_to_correct = int(((f == 0) & (q == 1)).sum())
    discordant = correct_to_wrong + wrong_to_correct
    p_value = float(binomtest(correct_to_wrong, discordant, p=0.5).pvalue) if discordant else 1.0
    f16_correct = int(f.sum())
    flip_rate = correct_to_wrong / f16_correct if f16_correct else float("nan")
    ci_low, ci_high = wilson_interval(correct_to_wrong, f16_correct)
    diff, diff_low, diff_high = bootstrap_accuracy_difference(f, q, bootstrap)
    agreement = float((joined["prediction_f16"] == joined[f"prediction_{other_name}"]).mean())
    return {
        "comparison": f"f16_vs_{other_name}",
        "n": len(joined),
        "f16_accuracy": float(f.mean()),
        f"{other_name}_accuracy": float(q.mean()),
        "accuracy_difference_other_minus_f16": diff,
        "accuracy_difference_ci95": [diff_low, diff_high],
        "correct_to_wrong": correct_to_wrong,
        "wrong_to_correct": wrong_to_correct,
        "discordant_total": discordant,
        "mcnemar_exact_p": p_value,
        "conditional_correct_to_wrong_rate": flip_rate,
        "conditional_flip_ci95": [ci_low, ci_high],
        "answer_agreement": agreement,
    }


def build_merged(sample: pd.DataFrame, predictions: dict[str, pd.DataFrame]) -> pd.DataFrame:
    columns = [
        "question_id", "prediction", "correct", "selected_prob", "top_prob", "margin",
        "entropy", "prob_mass", "elapsed_s", "prompt_ms", "prompt_n", "raw_output", "error",
    ]
    merged = sample.copy()
    for precision, df in predictions.items():
        part = df[columns].copy()
        part = part.rename(columns={c: f"{precision}_{c}" for c in columns if c != "question_id"})
        merged = merged.merge(part, on="question_id", how="left")
    merged["q8_flip"] = ((merged["f16_correct"] == 1) & (merged["q8_correct"] == 0)).astype(int)
    merged["q4_flip"] = ((merged["f16_correct"] == 1) & (merged["q4_correct"] == 0)).astype(int)
    merged["q4_recovery"] = ((merged["f16_correct"] == 0) & (merged["q4_correct"] == 1)).astype(int)
    return merged


def predictor_and_routing(merged: pd.DataFrame, results_dir: Path) -> dict[str, Any]:
    target = merged["q4_flip"].astype(int).to_numpy()
    positives = int(target.sum())
    base_rate = float(target.mean())
    result: dict[str, Any] = {"positive_cases": positives, "base_rate": base_rate, "status": "skipped"}

    numeric_features = ["q4_selected_prob", "q4_top_prob", "q4_margin", "q4_entropy", "q4_prob_mass", "prompt_chars", "n_options"]
    categorical_features = ["Level"]
    available = [c for c in numeric_features + categorical_features if c in merged.columns]
    X = merged[available].copy()
    groups = merged["Subject"].astype(str).to_numpy()
    unique_groups = np.unique(groups)

    if positives < 15 or positives >= len(target) - 5 or len(unique_groups) < 3:
        merged["q4_oof_risk"] = 1.0 - merged["q4_margin"].fillna(0.0)
        result["reason"] = "Insufficient positive cases/groups for stable grouped cross-validation; margin risk used."
    else:
        numeric = [c for c in numeric_features if c in available]
        categorical = [c for c in categorical_features if c in available]
        preprocessor = ColumnTransformer(
            transformers=[
                (
                    "num",
                    Pipeline([("imputer", SimpleImputer(strategy="median")), ("scale", StandardScaler())]),
                    numeric,
                ),
                (
                    "cat",
                    Pipeline([("imputer", SimpleImputer(strategy="most_frequent")), ("onehot", OneHotEncoder(handle_unknown="ignore"))]),
                    categorical,
                ),
            ]
        )
        model = Pipeline(
            [
                ("preprocess", preprocessor),
                ("model", LogisticRegression(max_iter=2000, class_weight="balanced", random_state=SEED)),
            ]
        )
        n_splits = min(5, len(unique_groups))
        splitter = GroupKFold(n_splits=n_splits)
        oof = np.full(len(merged), np.nan, dtype=float)
        fold_rows: list[dict[str, Any]] = []
        for fold, (train_idx, test_idx) in enumerate(splitter.split(X, target, groups), start=1):
            if len(np.unique(target[train_idx])) < 2:
                continue
            model.fit(X.iloc[train_idx], target[train_idx])
            oof[test_idx] = model.predict_proba(X.iloc[test_idx])[:, 1]
            fold_rows.append({"fold": fold, "train_n": len(train_idx), "test_n": len(test_idx), "test_positives": int(target[test_idx].sum())})
        valid = np.isfinite(oof)
        if valid.sum() > 0 and len(np.unique(target[valid])) == 2:
            auroc = float(roc_auc_score(target[valid], oof[valid]))
            auprc = float(average_precision_score(target[valid], oof[valid]))
            merged["q4_oof_risk"] = oof
            result.update({"status": "completed", "auroc": auroc, "auprc": auprc, "folds": fold_rows, "evaluated_n": int(valid.sum())})
        else:
            merged["q4_oof_risk"] = 1.0 - merged["q4_margin"].fillna(0.0)
            result["reason"] = "Grouped folds did not yield valid out-of-fold predictions; margin risk used."

    if merged["q4_oof_risk"].isna().any():
        fallback = 1.0 - merged["q4_margin"].fillna(0.0)
        merged["q4_oof_risk"] = merged["q4_oof_risk"].fillna(fallback)

    merged.to_csv(results_dir / "paired_question_results.csv", index=False)

    budgets = [0.0, 0.05, 0.10, 0.20, 0.30]
    order = np.argsort(-merged["q4_oof_risk"].to_numpy())
    q4_correct = merged["q4_correct"].to_numpy(dtype=int)
    f16_correct = merged["f16_correct"].to_numpy(dtype=int)
    flips = merged["q4_flip"].to_numpy(dtype=int)
    rng = np.random.default_rng(SEED)
    routing_rows: list[dict[str, Any]] = []
    for budget in budgets:
        k = int(round(len(merged) * budget))
        routed = np.zeros(len(merged), dtype=bool)
        if k:
            routed[order[:k]] = True
        final_correct = np.where(routed, f16_correct, q4_correct)
        recovered = int((routed & (flips == 1)).sum())
        total_flips = int(flips.sum())
        random_accuracies: list[float] = []
        random_recalls: list[float] = []
        for _ in range(1000):
            random_routed = np.zeros(len(merged), dtype=bool)
            if k:
                random_routed[rng.choice(len(merged), size=k, replace=False)] = True
            random_final = np.where(random_routed, f16_correct, q4_correct)
            random_accuracies.append(float(random_final.mean()))
            random_recalls.append(float((random_routed & (flips == 1)).sum() / total_flips) if total_flips else 0.0)
        routing_rows.append(
            {
                "budget": budget,
                "routed_n": k,
                "risk_routed_accuracy": float(final_correct.mean()),
                "q4_flip_recall": recovered / total_flips if total_flips else 0.0,
                "random_accuracy_mean": float(np.mean(random_accuracies)),
                "random_flip_recall_mean": float(np.mean(random_recalls)),
            }
        )
    pd.DataFrame(routing_rows).to_csv(results_dir / "routing_curve.csv", index=False)
    result["routing"] = routing_rows
    return result


def render_report(summary: dict[str, Any], merged: pd.DataFrame, paths: Paths) -> None:
    f16 = summary["precision_metrics"]["f16"]
    q8 = summary["precision_metrics"]["q8"]
    q4 = summary["precision_metrics"]["q4"]
    c8 = summary["comparisons"]["f16_vs_q8"]
    c4 = summary["comparisons"]["f16_vs_q4"]
    predictor = summary["predictor"]

    def pct(x: float) -> str:
        return f"{100*x:.2f}%"

    lines = [
        "# تقرير تجربة التكميم العربية على نموذج قريب من مليار معامل",
        "",
        "## التصميم",
        "",
        f"- النموذج: IBM Granite 3.0 1B-A400M-Instruct (1B MoE؛ نحو 1.3B إجماليًا و400M نشطة لكل token).",
        f"- العينة: {summary['sample_size']} سؤال ثابت وموزع طبقيًا من ArabicMMLU.",
        "- النسخ: F16 وQ8_0 وQ4_K_M لنفس الـcheckpoint.",
        "- الاستدلال: حتمي، وGrammar تسمح فقط بحروف الاختيارات الصحيحة شكليًا.",
        "- وحدة التحليل: نفس السؤال قبل التكميم وبعده.",
        "",
        "## النتائج الأساسية",
        "",
        "| النسخة | الدقة | الإجابات الصحيحة | غير الصالحة/الأخطاء | متوسط زمن السؤال |",
        "|---|---:|---:|---:|---:|",
        f"| F16 | {pct(f16['accuracy'])} | {f16['correct_n']} | {f16['invalid_or_error_n']} | {f16['mean_elapsed_s']:.3f} ث |",
        f"| Q8_0 | {pct(q8['accuracy'])} | {q8['correct_n']} | {q8['invalid_or_error_n']} | {q8['mean_elapsed_s']:.3f} ث |",
        f"| Q4_K_M | {pct(q4['accuracy'])} | {q4['correct_n']} | {q4['invalid_or_error_n']} | {q4['mean_elapsed_s']:.3f} ث |",
        "",
        "## التحولات الزوجية",
        "",
        "| المقارنة | صحيح→خطأ | خطأ→صحيح | معدل إسقاط إجابات F16 الصحيحة | McNemar p | اتفاق الإجابة |",
        "|---|---:|---:|---:|---:|---:|",
        f"| F16 مقابل Q8 | {c8['correct_to_wrong']} | {c8['wrong_to_correct']} | {pct(c8['conditional_correct_to_wrong_rate'])} | {c8['mcnemar_exact_p']:.4g} | {pct(c8['answer_agreement'])} |",
        f"| F16 مقابل Q4 | {c4['correct_to_wrong']} | {c4['wrong_to_correct']} | {pct(c4['conditional_correct_to_wrong_rate'])} | {c4['mcnemar_exact_p']:.4g} | {pct(c4['answer_agreement'])} |",
        "",
        f"فرق دقة Q4 ناقص F16 = {100*c4['accuracy_difference_other_minus_f16']:.2f} نقطة مئوية، "
        f"وفاصل الثقة bootstrap 95% من {100*c4['accuracy_difference_ci95'][0]:.2f} إلى {100*c4['accuracy_difference_ci95'][1]:.2f} نقطة.",
        "",
        "## التنبؤ والإصلاح الانتقائي",
        "",
    ]
    if predictor.get("status") == "completed":
        lines.extend(
            [
                f"- Grouped out-of-fold AUROC: **{predictor['auroc']:.3f}**.",
                f"- Grouped out-of-fold AUPRC: **{predictor['auprc']:.3f}** مقابل معدل أساسي {predictor['base_rate']:.3f}.",
            ]
        )
    else:
        lines.append(f"- لم يكن عدد الحالات كافيًا لتقدير predictor مستقر؛ استُخدم هامش الثقة كإشارة خطر. السبب: {predictor.get('reason', '')}")
    lines.extend(
        [
            "",
            "| نسبة الإحالة إلى F16 | الدقة النهائية | استرجاع حالات صحيح→خطأ | دقة الإحالة العشوائية |",
            "|---:|---:|---:|---:|",
        ]
    )
    for row in predictor["routing"]:
        lines.append(
            f"| {pct(row['budget'])} | {pct(row['risk_routed_accuracy'])} | "
            f"{pct(row['q4_flip_recall'])} | {pct(row['random_accuracy_mean'])} |"
        )

    subject_stats = (
        merged.groupby("Subject", dropna=False)
        .agg(n=("question_id", "size"), f16_accuracy=("f16_correct", "mean"), q4_accuracy=("q4_correct", "mean"), q4_flips=("q4_flip", "sum"))
        .sort_values(["q4_flips", "n"], ascending=False)
        .head(10)
        .reset_index()
    )
    lines.extend(["", "## أكثر المجالات ظهورًا للتحولات", "", "| المجال | n | F16 | Q4 | صحيح→خطأ |", "|---|---:|---:|---:|---:|"])
    for _, row in subject_stats.iterrows():
        lines.append(f"| {row['Subject']} | {int(row['n'])} | {pct(row['f16_accuracy'])} | {pct(row['q4_accuracy'])} | {int(row['q4_flips'])} |")

    lines.extend(
        [
            "",
            "## حدود الاستدلال",
            "",
            "هذه تجربة حقيقية على checkpoint مدرّب مسبقًا، لكنها ما زالت Pilot: نموذج MoE صغير، عينة واحدة ثابتة، ومهمة اختيار من متعدد. "
            "النتيجة القوية المطلوبة للانتقال للرسالة هي وجود عدد غير تافه ومتكرر من تحولات F16-correct إلى Q4-wrong مع إشارة خطر قابلة للتعميم. "
            "أما غياب فرق المتوسط وحده فلا ينفي الظاهرة، لأن التحولات المتعاكسة قد تلغي بعضها.",
            "",
            "## قابلية إعادة الإنتاج",
            "",
            "توجد ملفات الأسئلة، تنبؤات كل نسخة، السجلات، أحجام وSHA-256 للنماذج، التحليل الإحصائي، ونتائج التوجيه داخل الحزمة.",
        ]
    )
    (paths.results / "REPORT_AR.md").write_text("\n".join(lines), encoding="utf-8")


def analyze(paths: Paths, sample: pd.DataFrame, predictions: dict[str, pd.DataFrame], args: argparse.Namespace) -> dict[str, Any]:
    precision_metrics: dict[str, Any] = {}
    for precision, df in predictions.items():
        invalid = (~df["prediction"].isin(LABELS)).sum()
        precision_metrics[precision] = {
            "n": int(len(df)),
            "accuracy": float(df["correct"].mean()),
            "correct_n": int(df["correct"].sum()),
            "invalid_or_error_n": int(invalid),
            "mean_elapsed_s": float(df["elapsed_s"].mean()),
            "median_elapsed_s": float(df["elapsed_s"].median()),
        }

    comparisons = {
        "f16_vs_q8": paired_stats(predictions["f16"], predictions["q8"], "q8", args.bootstrap),
        "f16_vs_q4": paired_stats(predictions["f16"], predictions["q4"], "q4", args.bootstrap),
    }
    merged = build_merged(sample, predictions)
    predictor = predictor_and_routing(merged, paths.results)

    model_files: dict[str, Any] = {}
    for precision, filename in MODEL_SPECS.items():
        path = paths.models / filename
        model_files[precision] = {"filename": filename, "bytes": path.stat().st_size, "sha256": sha256_file(path)}

    summary = {
        "experiment_seed": SEED,
        "sample_size": int(len(sample)),
        "precision_metrics": precision_metrics,
        "comparisons": comparisons,
        "predictor": predictor,
        "model_files": model_files,
        "settings": {
            "ctx_size": args.ctx_size,
            "threads": args.threads,
            "max_prompt_chars": args.max_prompt_chars,
            "bootstrap_iterations": args.bootstrap,
            "deterministic_temperature": 0.0,
            "grammar_constrained_labels": True,
        },
    }
    (paths.results / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    render_report(summary, merged, paths)

    examples = merged[merged["q4_flip"] == 1].copy()
    examples = examples.sort_values(["q4_oof_risk", "Subject"], ascending=[False, True]).head(50)
    examples.to_csv(paths.results / "representative_q4_flips.csv", index=False)
    return summary


def main() -> int:
    args = parse_args()
    np.random.seed(SEED)
    paths = setup_paths(args)
    sample = prepare_sample(paths, args.sample_size, args.max_prompt_chars)
    print(f"Prepared fixed sample: {len(sample)} questions across {sample['Subject'].nunique()} subjects", flush=True)

    predictions: dict[str, pd.DataFrame] = {}
    for offset, precision in enumerate(("f16", "q8", "q4")):
        predictions[precision] = evaluate_model(paths, sample, precision, args, port=8081 + offset)

    summary = analyze(paths, sample, predictions, args)
    print(json.dumps(summary, ensure_ascii=False, indent=2), flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
