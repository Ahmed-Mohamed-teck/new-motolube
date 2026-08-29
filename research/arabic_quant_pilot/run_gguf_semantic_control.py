#!/usr/bin/env python3
"""Semantic multiple-choice control using full option likelihood.

Unlike next-token digit scoring, this script scores the complete text of every
answer option with length-normalized conditional log-likelihood. This avoids
making the research decision depend on a particular answer-label token.
"""

from __future__ import annotations

import argparse
import gc
import json
import math
import os
import random
import time
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd
from huggingface_hub import hf_hub_download
from llama_cpp import Llama
from scipy.special import logsumexp
from scipy.stats import binomtest

FILES = {
    "f16": "Qwen3_0.6B.F16.gguf",
    "q4km": "Qwen3_0.6B.Q4_K_M.gguf",
}


def set_seed(seed: int) -> None:
    random.seed(seed)
    np.random.seed(seed)


def get_options(row: pd.Series) -> list[str]:
    return [
        str(row[f"Option {i}"]).strip()
        for i in range(1, int(row["n_options"]) + 1)
    ]


def has_duplicate_options(row: pd.Series) -> bool:
    options = get_options(row)
    return len(set(options)) != len(options)


def build_user_prompt(row: pd.Series, order: list[int]) -> str:
    context = "" if pd.isna(row.get("Context")) else str(row["Context"]).strip()
    question = str(row["Question"]).strip()
    stem = f"{context}\n\n{question}" if context else question
    options = get_options(row)
    displayed = [options[i] for i in order]
    choices = "\n".join(f"- {text}" for text in displayed)
    return (
        "اختر الإجابة الصحيحة للسؤال التالي. اكتب نص الإجابة فقط دون رقم أو شرح.\n\n"
        f"السؤال:\n{stem}\n\n"
        f"الإجابات المتاحة:\n{choices}\n\n"
        "الإجابة الصحيحة:"
    )


def wrap_qwen_chat(prompt: str) -> str:
    return (
        "<|im_start|>user\n"
        + prompt
        + "<|im_end|>\n<|im_start|>assistant\n<think>\n\n</think>\n\n"
    )


def build_conditions(source: pd.DataFrame, seed: int) -> pd.DataFrame:
    rng = np.random.default_rng(seed)
    rows: list[dict[str, Any]] = []
    for _, row in source.iterrows():
        n = int(row["n_options"])
        options = get_options(row)
        original_order = list(range(n))
        permutation = rng.permutation(n).tolist()
        if permutation == original_order:
            permutation = permutation[1:] + permutation[:1]

        for condition, order in (
            ("original", original_order),
            ("permuted", permutation),
        ):
            new_gold = int(order.index(int(row["gold"])))
            rows.append(
                {
                    "item_id": row["item_id"],
                    "condition": condition,
                    "n_options": n,
                    "gold": new_gold,
                    "order": json.dumps(order),
                    "candidate_texts": json.dumps(
                        [options[i] for i in order], ensure_ascii=False
                    ),
                    "model_prompt": wrap_qwen_chat(build_user_prompt(row, order)),
                }
            )
    return pd.DataFrame(rows)


def candidate_score(
    llm: Llama,
    prompt_tokens: list[int],
    candidate_text: str,
    n_ctx: int,
) -> tuple[float, float, int, bool]:
    # Prefixing a space gives the option a natural continuation boundary.
    candidate_tokens = llm.tokenize(
        (" " + candidate_text).encode("utf-8"),
        add_bos=False,
        special=False,
    )
    if not candidate_tokens:
        raise RuntimeError(f"Empty candidate tokenization for {candidate_text!r}")
    truncated = False
    available = n_ctx - len(candidate_tokens) - 1
    prompt = prompt_tokens
    if len(prompt) > available:
        truncated = True
        prompt = prompt[-available:]
    all_tokens = prompt + candidate_tokens

    llm.reset()
    llm.eval(all_tokens)
    start = len(prompt) - 1
    token_logps: list[float] = []
    for j, target in enumerate(candidate_tokens):
        logits = np.asarray(llm.scores[start + j], dtype=np.float64)
        token_logps.append(float(logits[target] - logsumexp(logits)))
    total = float(np.sum(token_logps))
    mean = float(np.mean(token_logps))
    return mean, total, len(candidate_tokens), truncated


def evaluate_model(
    model_path: str,
    data: pd.DataFrame,
    variant: str,
    n_ctx: int,
    n_threads: int,
) -> tuple[pd.DataFrame, dict[str, Any]]:
    started = time.perf_counter()
    llm = Llama(
        model_path=model_path,
        n_ctx=n_ctx,
        n_batch=n_ctx,
        n_threads=n_threads,
        n_threads_batch=n_threads,
        n_gpu_layers=0,
        logits_all=True,
        use_mmap=True,
        verbose=False,
        seed=0,
    )
    rows: list[dict[str, Any]] = []
    candidate_evaluations = 0
    truncated_candidates = 0

    for i, row in data.iterrows():
        prompt_tokens = llm.tokenize(
            str(row["model_prompt"]).encode("utf-8"),
            add_bos=False,
            special=True,
        )
        candidates = json.loads(row["candidate_texts"])
        mean_scores: list[float] = []
        total_scores: list[float] = []
        token_counts: list[int] = []
        for candidate in candidates:
            mean, total, token_count, truncated = candidate_score(
                llm, prompt_tokens, candidate, n_ctx
            )
            mean_scores.append(mean)
            total_scores.append(total)
            token_counts.append(token_count)
            candidate_evaluations += 1
            truncated_candidates += int(truncated)

        order = np.argsort(-np.asarray(mean_scores))
        pred = int(order[0])
        runner_up = int(order[1])
        # Softmax over length-normalized option scores is used only as a relative
        # confidence feature; the selected answer is the argmax of mean log-likelihood.
        centered = np.asarray(mean_scores) - np.max(mean_scores)
        probs = np.exp(centered) / np.exp(centered).sum()
        entropy = float(
            -(probs * np.log(np.clip(probs, 1e-15, None))).sum()
            / math.log(len(candidates))
        )
        result: dict[str, Any] = {
            "item_id": row["item_id"],
            "condition": row["condition"],
            f"{variant}_pred": pred,
            f"{variant}_confidence": float(probs[pred]),
            f"{variant}_margin": float(probs[pred] - probs[runner_up]),
            f"{variant}_entropy": entropy,
            f"{variant}_best_mean_logp": float(mean_scores[pred]),
            f"{variant}_candidate_mean_logps": json.dumps(mean_scores),
            f"{variant}_candidate_total_logps": json.dumps(total_scores),
            f"{variant}_candidate_token_counts": json.dumps(token_counts),
            f"{variant}_prompt_tokens": len(prompt_tokens),
        }
        rows.append(result)
        if (i + 1) % 20 == 0:
            print(
                f"[{variant}] {i + 1}/{len(data)} conditions, "
                f"candidate_evals={candidate_evaluations}, "
                f"elapsed={time.perf_counter()-started:.1f}s",
                flush=True,
            )

    metadata = {
        "variant": variant,
        "model_file": Path(model_path).name,
        "elapsed_seconds": time.perf_counter() - started,
        "candidate_evaluations": candidate_evaluations,
        "truncated_candidate_evaluations": truncated_candidates,
    }
    del llm
    gc.collect()
    return pd.DataFrame(rows), metadata


def wilson(successes: int, total: int, z: float = 1.959963984540054) -> list[float]:
    if total == 0:
        return [float("nan"), float("nan")]
    p = successes / total
    denominator = 1 + z * z / total
    center = (p + z * z / (2 * total)) / denominator
    half = z * math.sqrt((p * (1 - p) + z * z / (4 * total)) / total) / denominator
    return [center - half, center + half]


def paired_summary(data: pd.DataFrame, condition: str) -> dict[str, Any]:
    part = data[data["condition"] == condition]
    gold = part["gold"].to_numpy()
    ref = part["f16_pred"].to_numpy()
    q4 = part["q4km_pred"].to_numpy()
    ref_correct = ref == gold
    q4_correct = q4 == gold
    c2w = int(np.sum(ref_correct & ~q4_correct))
    w2c = int(np.sum(~ref_correct & q4_correct))
    changes = int(np.sum(ref != q4))
    discordant = c2w + w2c
    mcnemar = (
        float(binomtest(min(c2w, w2c), discordant, 0.5).pvalue)
        if discordant
        else 1.0
    )
    return {
        "n": len(part),
        "f16_accuracy": float(ref_correct.mean()),
        "q4km_accuracy": float(q4_correct.mean()),
        "accuracy_delta": float(q4_correct.mean() - ref_correct.mean()),
        "correct_to_wrong": c2w,
        "wrong_to_correct": w2c,
        "net_loss": c2w - w2c,
        "prediction_changes": changes,
        "prediction_change_rate": changes / len(part),
        "prediction_change_wilson_95ci": wilson(changes, len(part)),
        "conditional_flip_rate": c2w / max(int(ref_correct.sum()), 1),
        "conditional_flip_wilson_95ci": wilson(c2w, int(ref_correct.sum())),
        "mcnemar_exact_p": mcnemar,
        "f16_prediction_distribution": {
            str(int(k) + 1): int(v)
            for k, v in part["f16_pred"].value_counts().sort_index().items()
        },
        "q4km_prediction_distribution": {
            str(int(k) + 1): int(v)
            for k, v in part["q4km_pred"].value_counts().sort_index().items()
        },
    }


def semantic_consistency(data: pd.DataFrame, variant: str) -> dict[str, Any]:
    original = data[data["condition"] == "original"].set_index("item_id")
    permuted = data[data["condition"] == "permuted"].set_index("item_id")
    consistent = 0
    for item_id, row in permuted.iterrows():
        permutation = json.loads(row["order"])
        mapped_semantic = int(permutation[int(row[f"{variant}_pred"])] )
        original_semantic = int(original.loc[item_id, f"{variant}_pred"])
        consistent += int(mapped_semantic == original_semantic)
    total = len(permuted)
    return {
        "consistent": consistent,
        "total": total,
        "rate": consistent / total,
        "wilson_95ci": wilson(consistent, total),
    }


def render_report(summary: dict[str, Any]) -> str:
    o = summary["original"]
    p = summary["permuted"]
    f = summary["semantic_consistency"]["f16"]
    q = summary["semantic_consistency"]["q4km"]
    return "\n".join(
        [
            "# Full-Option Semantic Likelihood Control",
            "",
            "Every answer is scored using the length-normalized conditional log-likelihood of its full Arabic text. No digit or letter answer token is used for selection.",
            "",
            "| Condition | F16 accuracy | Q4_K_M accuracy | Δ | Correct→Wrong | Wrong→Correct | Any prediction change | McNemar p |",
            "|---|---:|---:|---:|---:|---:|---:|---:|",
            f"| Original | {o['f16_accuracy']:.2%} | {o['q4km_accuracy']:.2%} | {o['accuracy_delta']:+.2%} | {o['correct_to_wrong']} | {o['wrong_to_correct']} | {o['prediction_changes']} | {o['mcnemar_exact_p']:.6g} |",
            f"| Permuted | {p['f16_accuracy']:.2%} | {p['q4km_accuracy']:.2%} | {p['accuracy_delta']:+.2%} | {p['correct_to_wrong']} | {p['wrong_to_correct']} | {p['prediction_changes']} | {p['mcnemar_exact_p']:.6g} |",
            "",
            "## Semantic consistency under option reordering",
            "",
            f"- F16: **{f['rate']:.2%}** ({f['consistent']}/{f['total']}).",
            f"- Q4_K_M: **{q['rate']:.2%}** ({q['consistent']}/{q['total']}).",
            "",
            f"Original F16 prediction distribution: `{o['f16_prediction_distribution']}`.",
            f"Original Q4_K_M prediction distribution: `{o['q4km_prediction_distribution']}`.",
            "",
            "This control should carry more weight than next-token digit scoring when deciding whether the phenomenon is semantic or merely token/position bias.",
            "",
        ]
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input-csv",
        default="research/arabic_quant_pilot/smoke_results/per_question_results.csv",
    )
    parser.add_argument(
        "--output-dir",
        default="research/arabic_quant_pilot/gguf_semantic_results",
    )
    parser.add_argument("--repo-id", default="prithivMLmods/Qwen3-0.6B-GGUF")
    parser.add_argument("--sample-size", type=int, default=100)
    parser.add_argument("--seed", type=int, default=20260831)
    parser.add_argument("--n-ctx", type=int, default=512)
    parser.add_argument("--n-threads", type=int, default=max(1, os.cpu_count() or 1))
    args = parser.parse_args()
    set_seed(args.seed)
    output = Path(args.output_dir)
    output.mkdir(parents=True, exist_ok=True)

    raw = pd.read_csv(args.input_csv)
    raw = raw[~raw.apply(has_duplicate_options, axis=1)].copy()
    sample_n = min(args.sample_size, len(raw))
    source = raw.sample(n=sample_n, random_state=args.seed).reset_index(drop=True)
    columns = [
        "item_id",
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
    ]
    source = source[columns]
    conditions = build_conditions(source, args.seed)
    merged = conditions.merge(
        source.drop(columns=["gold", "n_options"]),
        on="item_id",
        how="left",
        validate="many_to_one",
    )

    run_meta: dict[str, Any] = {
        "repo_id": args.repo_id,
        "model_files": FILES,
        "sample_size": sample_n,
        "condition_rows": len(merged),
        "seed": args.seed,
        "n_ctx": args.n_ctx,
        "n_threads": args.n_threads,
        "github_run_id": os.environ.get("GITHUB_RUN_ID"),
        "scoring": "full option text, mean conditional token log-probability",
        "duplicate_option_items_excluded_from_source": int(
            raw.shape[0] < pd.read_csv(args.input_csv).shape[0]
        ),
    }

    for variant, filename in FILES.items():
        print(f"Downloading {filename}", flush=True)
        model_path = hf_hub_download(repo_id=args.repo_id, filename=filename)
        results, metadata = evaluate_model(
            model_path,
            merged,
            variant=variant,
            n_ctx=args.n_ctx,
            n_threads=args.n_threads,
        )
        run_meta[variant] = metadata
        merged = merged.merge(
            results,
            on=["item_id", "condition"],
            how="left",
            validate="one_to_one",
        )
        del results
        gc.collect()

    merged["f16_correct"] = merged["f16_pred"] == merged["gold"]
    merged["q4km_correct"] = merged["q4km_pred"] == merged["gold"]
    merged["q4km_correct_to_wrong"] = merged["f16_correct"] & ~merged["q4km_correct"]
    merged["q4km_wrong_to_correct"] = ~merged["f16_correct"] & merged["q4km_correct"]

    summary = {
        "run": run_meta,
        "original": paired_summary(merged, "original"),
        "permuted": paired_summary(merged, "permuted"),
        "semantic_consistency": {
            "f16": semantic_consistency(merged, "f16"),
            "q4km": semantic_consistency(merged, "q4km"),
        },
    }
    merged.to_csv(output / "per_condition_results.csv", index=False)
    merged[merged["q4km_correct_to_wrong"]].to_csv(
        output / "q4km_correct_to_wrong_examples.csv", index=False
    )
    (output / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (output / "REPORT.md").write_text(render_report(summary), encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2), flush=True)


if __name__ == "__main__":
    main()
