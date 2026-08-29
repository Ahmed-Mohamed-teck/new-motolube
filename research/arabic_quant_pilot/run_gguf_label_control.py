#!/usr/bin/env python3
"""Confirmatory GGUF control for Arabic quantization-induced decision instability.

Compares F16 and production-style llama.cpp Q4_K_M weights in the same llama.cpp
runtime on the exact smoke-test questions. It also permutes answer positions to
separate semantic degradation from answer-label bias.
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
from scipy.stats import binomtest


FILES = {
    "f16": "Qwen3_0.6B.F16.gguf",
    "q4km": "Qwen3_0.6B.Q4_K_M.gguf",
}


def set_seed(seed: int) -> None:
    random.seed(seed)
    np.random.seed(seed)


def user_prompt(row: pd.Series, order: list[int] | None = None) -> tuple[str, int, list[int]]:
    n = int(row["n_options"])
    if order is None:
        order = list(range(n))
    context = "" if pd.isna(row.get("Context")) else str(row["Context"]).strip()
    question = str(row["Question"]).strip()
    stem = f"{context}\n\n{question}" if context else question
    options = [str(row[f"Option {i + 1}"]).strip() for i in range(n)]
    displayed = [options[old_idx] for old_idx in order]
    lines = "\n".join(f"{i + 1}) {value}" for i, value in enumerate(displayed))
    prompt = (
        "أجب عن السؤال التالي باختيار رقم واحد فقط من الخيارات، ولا تكتب أي شرح.\n\n"
        f"السؤال:\n{stem}\n\n"
        f"الخيارات:\n{lines}\n\n"
        "الإجابة الصحيحة هي الخيار رقم:"
    )
    old_gold = int(row["gold"])
    new_gold = int(order.index(old_gold))
    return prompt, new_gold, order


def wrap_qwen_chat(prompt: str) -> str:
    return (
        "<|im_start|>user\n"
        + prompt
        + "<|im_end|>\n<|im_start|>assistant\n<think>\n\n</think>\n\n"
    )


def build_conditions(data: pd.DataFrame, seed: int) -> pd.DataFrame:
    rng = np.random.default_rng(seed)
    rows: list[dict[str, Any]] = []
    for _, row in data.iterrows():
        n = int(row["n_options"])
        original_order = list(range(n))
        original_prompt, original_gold, _ = user_prompt(row, original_order)
        rows.append(
            {
                "item_id": row["item_id"],
                "condition": "original",
                "n_options": n,
                "gold": original_gold,
                "order": json.dumps(original_order),
                "model_prompt": wrap_qwen_chat(original_prompt),
            }
        )

        perm = rng.permutation(n).tolist()
        if perm == original_order:
            perm = perm[1:] + perm[:1]
        perm_prompt, perm_gold, _ = user_prompt(row, perm)
        rows.append(
            {
                "item_id": row["item_id"],
                "condition": "permuted",
                "n_options": n,
                "gold": perm_gold,
                "order": json.dumps(perm),
                "model_prompt": wrap_qwen_chat(perm_prompt),
            }
        )
    return pd.DataFrame(rows)


def stable_softmax(values: np.ndarray) -> np.ndarray:
    values = values.astype(np.float64)
    values = values - np.max(values)
    exp = np.exp(values)
    return exp / exp.sum()


def evaluate_gguf(
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

    label_token_ids: list[int] = []
    for digit in range(1, 6):
        ids = llm.tokenize(str(digit).encode("utf-8"), add_bos=False, special=False)
        if len(ids) != 1:
            raise RuntimeError(f"Digit {digit} tokenized to {ids}, expected one token")
        label_token_ids.append(int(ids[0]))

    rows: list[dict[str, Any]] = []
    truncated = 0
    for i, row in data.iterrows():
        tokens = llm.tokenize(
            str(row["model_prompt"]).encode("utf-8"),
            add_bos=False,
            special=True,
        )
        if len(tokens) >= n_ctx:
            truncated += 1
            tokens = tokens[-(n_ctx - 1) :]
        llm.reset()
        llm.eval(tokens)
        logits = np.asarray(llm.scores[len(tokens) - 1], dtype=np.float64)
        n_options = int(row["n_options"])
        selected_logits = logits[label_token_ids[:n_options]]
        probs = stable_softmax(selected_logits)
        ranking = np.argsort(-probs)
        pred = int(ranking[0])
        top2 = int(ranking[1])
        entropy = float(
            -(probs * np.log(np.clip(probs, 1e-15, None))).sum()
            / math.log(n_options)
        )
        output: dict[str, Any] = {
            "item_id": row["item_id"],
            "condition": row["condition"],
            f"{variant}_pred": pred,
            f"{variant}_confidence": float(probs[pred]),
            f"{variant}_margin": float(probs[pred] - probs[top2]),
            f"{variant}_entropy": entropy,
            f"{variant}_token_length": len(tokens),
        }
        for option in range(5):
            output[f"{variant}_p{option + 1}"] = (
                float(probs[option]) if option < n_options else 0.0
            )
        rows.append(output)
        if (i + 1) % 50 == 0:
            print(
                f"[{variant}] {i + 1}/{len(data)}, elapsed={time.perf_counter()-started:.1f}s",
                flush=True,
            )

    metadata = {
        "variant": variant,
        "model_path": Path(model_path).name,
        "label_token_ids": label_token_ids,
        "elapsed_seconds": time.perf_counter() - started,
        "truncated_prompts": truncated,
    }
    del llm
    gc.collect()
    return pd.DataFrame(rows), metadata


def wilson(success: int, total: int, z: float = 1.959963984540054) -> list[float]:
    if total == 0:
        return [float("nan"), float("nan")]
    p = success / total
    denom = 1 + z * z / total
    center = (p + z * z / (2 * total)) / denom
    half = z * math.sqrt((p * (1 - p) + z * z / (4 * total)) / total) / denom
    return [center - half, center + half]


def paired_summary(df: pd.DataFrame, condition: str) -> dict[str, Any]:
    part = df[df["condition"] == condition].copy()
    gold = part["gold"].to_numpy()
    f16_correct = part["f16_pred"].to_numpy() == gold
    q4_correct = part["q4km_pred"].to_numpy() == gold
    c2w = int(np.sum(f16_correct & ~q4_correct))
    w2c = int(np.sum(~f16_correct & q4_correct))
    changed = int(np.sum(part["f16_pred"].to_numpy() != part["q4km_pred"].to_numpy()))
    discordant = c2w + w2c
    p = float(binomtest(min(c2w, w2c), discordant, 0.5).pvalue) if discordant else 1.0
    return {
        "n": len(part),
        "f16_accuracy": float(f16_correct.mean()),
        "q4km_accuracy": float(q4_correct.mean()),
        "accuracy_delta": float(q4_correct.mean() - f16_correct.mean()),
        "correct_to_wrong": c2w,
        "wrong_to_correct": w2c,
        "net_loss": c2w - w2c,
        "prediction_changes": changed,
        "prediction_change_rate": changed / len(part),
        "prediction_change_wilson_95ci": wilson(changed, len(part)),
        "conditional_flip_rate": c2w / max(int(f16_correct.sum()), 1),
        "conditional_flip_wilson_95ci": wilson(c2w, int(f16_correct.sum())),
        "mcnemar_exact_p": p,
        "f16_prediction_distribution": part["f16_pred"].value_counts().sort_index().to_dict(),
        "q4km_prediction_distribution": part["q4km_pred"].value_counts().sort_index().to_dict(),
    }


def semantic_consistency(df: pd.DataFrame, variant: str) -> dict[str, Any]:
    original = df[df["condition"] == "original"].set_index("item_id")
    permuted = df[df["condition"] == "permuted"].set_index("item_id")
    mapped: list[int] = []
    original_pred: list[int] = []
    for item_id, row in permuted.iterrows():
        order = json.loads(row["order"])
        mapped.append(int(order[int(row[f"{variant}_pred"])]))
        original_pred.append(int(original.loc[item_id, f"{variant}_pred"]))
    mapped_arr = np.asarray(mapped)
    original_arr = np.asarray(original_pred)
    consistent = int(np.sum(mapped_arr == original_arr))
    return {
        "consistent_items": consistent,
        "total_items": len(mapped_arr),
        "semantic_consistency_rate": consistent / len(mapped_arr),
        "wilson_95ci": wilson(consistent, len(mapped_arr)),
    }


def make_report(summary: dict[str, Any]) -> str:
    o = summary["original"]
    p = summary["permuted"]
    f16s = summary["semantic_consistency"]["f16"]
    q4s = summary["semantic_consistency"]["q4km"]
    return "\n".join(
        [
            "# GGUF Q4_K_M and Label-Permutation Control",
            "",
            "This confirmation uses llama.cpp for both F16 and Q4_K_M and evaluates the exact same ArabicMMLU items under original and deterministically permuted answer positions.",
            "",
            "| Condition | F16 accuracy | Q4_K_M accuracy | Δ accuracy | Correct→Wrong | Wrong→Correct | Any change | McNemar p |",
            "|---|---:|---:|---:|---:|---:|---:|---:|",
            f"| Original | {o['f16_accuracy']:.3%} | {o['q4km_accuracy']:.3%} | {o['accuracy_delta']:+.3%} | {o['correct_to_wrong']} | {o['wrong_to_correct']} | {o['prediction_changes']} | {o['mcnemar_exact_p']:.6g} |",
            f"| Permuted | {p['f16_accuracy']:.3%} | {p['q4km_accuracy']:.3%} | {p['accuracy_delta']:+.3%} | {p['correct_to_wrong']} | {p['wrong_to_correct']} | {p['prediction_changes']} | {p['mcnemar_exact_p']:.6g} |",
            "",
            "## Position/semantic control",
            "",
            f"- F16 semantic consistency after answer-position permutation: **{f16s['semantic_consistency_rate']:.3%}**.",
            f"- Q4_K_M semantic consistency after answer-position permutation: **{q4s['semantic_consistency_rate']:.3%}**.",
            f"- Original Q4_K_M label distribution: `{o['q4km_prediction_distribution']}`.",
            f"- Permuted Q4_K_M label distribution: `{p['q4km_prediction_distribution']}`.",
            "",
            "A persistent concentration on the same numeric label after semantic options are permuted indicates label-position bias. A drop in Q4 semantic consistency relative to F16 indicates quantization-induced semantic instability beyond normal permutation sensitivity.",
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
        "--output-dir", default="research/arabic_quant_pilot/gguf_control_results"
    )
    parser.add_argument("--repo-id", default="prithivMLmods/Qwen3-0.6B-GGUF")
    parser.add_argument("--seed", type=int, default=20260830)
    parser.add_argument("--n-ctx", type=int, default=512)
    parser.add_argument("--n-threads", type=int, default=max(1, os.cpu_count() or 1))
    args = parser.parse_args()
    set_seed(args.seed)
    out = Path(args.output_dir)
    out.mkdir(parents=True, exist_ok=True)

    source = pd.read_csv(args.input_csv)
    base_columns = [
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
    source = source[base_columns].copy()
    conditions = build_conditions(source, args.seed)
    data = conditions.merge(
        source.drop(columns=["gold", "n_options"]),
        on="item_id",
        how="left",
        validate="many_to_one",
    )

    metadata: dict[str, Any] = {
        "repo_id": args.repo_id,
        "seed": args.seed,
        "source_items": len(source),
        "condition_rows": len(data),
        "n_ctx": args.n_ctx,
        "n_threads": args.n_threads,
        "github_run_id": os.environ.get("GITHUB_RUN_ID"),
        "files": FILES,
    }
    merged = data.copy()
    for variant, filename in FILES.items():
        print(f"Downloading {filename}", flush=True)
        model_path = hf_hub_download(repo_id=args.repo_id, filename=filename)
        result, variant_meta = evaluate_gguf(
            model_path,
            data,
            variant=variant,
            n_ctx=args.n_ctx,
            n_threads=args.n_threads,
        )
        metadata[variant] = variant_meta
        merged = merged.merge(
            result, on=["item_id", "condition"], how="left", validate="one_to_one"
        )
        del result
        gc.collect()

    summary = {
        "run": metadata,
        "original": paired_summary(merged, "original"),
        "permuted": paired_summary(merged, "permuted"),
        "semantic_consistency": {
            "f16": semantic_consistency(merged, "f16"),
            "q4km": semantic_consistency(merged, "q4km"),
        },
    }
    merged["f16_correct"] = merged["f16_pred"] == merged["gold"]
    merged["q4km_correct"] = merged["q4km_pred"] == merged["gold"]
    merged["q4km_correct_to_wrong"] = merged["f16_correct"] & ~merged["q4km_correct"]
    merged["q4km_wrong_to_correct"] = ~merged["f16_correct"] & merged["q4km_correct"]

    merged.to_csv(out / "per_condition_results.csv", index=False)
    merged[merged["q4km_correct_to_wrong"]].to_csv(
        out / "q4km_correct_to_wrong_examples.csv", index=False
    )
    (out / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (out / "REPORT.md").write_text(make_report(summary), encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2), flush=True)


if __name__ == "__main__":
    main()
