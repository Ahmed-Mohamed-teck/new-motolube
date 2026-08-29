#!/usr/bin/env python3
"""Probability-corrected wrapper for run_gguf_validation.py.

The original paired run used greedy sampling, which made post-sampling option
probabilities collapse to 1/0. This wrapper preserves the paired F16/Q4 test but
uses a neutral sampling chain and takes argmax over the grammar-valid option
probabilities. The generated token is ignored for classification.
"""
from __future__ import annotations

import math
import time
from typing import Any

import numpy as np
import pandas as pd
import requests

import run_gguf_validation as base


def _candidate_distribution(result: dict[str, Any], n_options: int) -> tuple[np.ndarray, bool]:
    probs = np.zeros(n_options, dtype=float)
    entries = result.get("completion_probabilities") or result.get("probs") or []
    top_entries: list[dict[str, Any]] = []
    if entries:
        first = entries[0]
        top_entries = first.get("top_probs") or first.get("top_logprobs") or []
    for entry in top_entries:
        token = str(entry.get("token", "")).strip()
        if token not in {str(i) for i in range(1, n_options + 1)}:
            continue
        idx = int(token) - 1
        if "prob" in entry:
            value = float(entry["prob"])
        elif "logprob" in entry:
            value = math.exp(float(entry["logprob"]))
        else:
            continue
        probs[idx] += value
    complete = int(np.count_nonzero(probs > 0)) == n_options
    total = float(probs.sum())
    if total > 0:
        probs /= total
    return probs, complete


def evaluate_server_probability_corrected(
    base_url: str,
    data: pd.DataFrame,
    chat_prompts: dict[str, str],
    variant: str,
    batch_size: int,
    seed: int,
) -> tuple[pd.DataFrame, dict[str, Any]]:
    session = requests.Session()
    rows: list[dict[str, Any]] = []
    started = time.perf_counter()
    invalid = 0
    complete_vectors = 0

    for n_options in sorted(data["n_options"].unique()):
        subset = data[data["n_options"] == n_options].reset_index(drop=True)
        for start in range(0, len(subset), batch_size):
            batch = subset.iloc[start : start + batch_size]
            payload = {
                "prompt": [chat_prompts[x] for x in batch["item_id"]],
                "n_predict": 1,
                "n_cmpl": 1,
                # Temperature 1 preserves relative logits. The generated token is
                # ignored; prediction is our argmax over valid-option probabilities.
                "temperature": 1.0,
                "top_k": 0,
                "top_p": 1.0,
                "min_p": 0.0,
                "repeat_penalty": 1.0,
                "grammar": base.grammar_for(int(n_options)),
                "n_probs": 16,
                "min_keep": int(n_options),
                "post_sampling_probs": True,
                "cache_prompt": False,
                "seed": seed,
                "stream": False,
                "return_tokens": True,
            }
            response: Any = None
            for attempt in range(3):
                try:
                    r = session.post(f"{base_url}/completion", json=payload, timeout=300)
                    r.raise_for_status()
                    response = r.json()
                    break
                except Exception:
                    if attempt == 2:
                        raise
                    time.sleep(2 * (attempt + 1))
            results = response if isinstance(response, list) else [response]
            if len(results) != len(batch):
                raise RuntimeError(f"expected {len(batch)} results, got {len(results)}")

            for (_, item), result in zip(batch.iterrows(), results):
                prob, complete = _candidate_distribution(result, int(n_options))
                if prob.sum() <= 0:
                    content = str(result.get("content", "")).strip()
                    if content and content[0] in {str(i) for i in range(1, int(n_options) + 1)}:
                        pred = int(content[0]) - 1
                        prob[pred] = 1.0
                    else:
                        pred = 0
                        prob[pred] = 1.0
                        invalid += 1
                else:
                    pred = int(np.argmax(prob))
                complete_vectors += int(complete)
                order = np.argsort(-prob)
                top1 = float(prob[order[0]])
                top2 = float(prob[order[1]]) if len(order) > 1 else 0.0
                nz = prob[prob > 0]
                entropy = float(-(nz * np.log(nz)).sum() / math.log(int(n_options)))
                timings = result.get("timings", {}) or {}
                rows.append(
                    {
                        "item_id": item["item_id"],
                        f"{variant}_pred": pred,
                        f"{variant}_valid": bool(prob.sum() > 0),
                        f"{variant}_content": str(result.get("content", "")),
                        f"{variant}_confidence": top1,
                        f"{variant}_margin": top1 - top2,
                        f"{variant}_entropy": entropy,
                        f"{variant}_prob_complete": complete,
                        f"{variant}_tokens_evaluated": int(result.get("tokens_evaluated", 0) or 0),
                        f"{variant}_prompt_ms": float(timings.get("prompt_ms", 0.0) or 0.0),
                        **{f"{variant}_p{i+1}": float(prob[i]) if i < len(prob) else 0.0 for i in range(5)},
                    }
                )
            done = len(rows)
            if done % 100 < batch_size:
                print(f"[{variant}-prob] {done}/{len(data)}", flush=True)

    return pd.DataFrame(rows), {
        "elapsed_seconds": time.perf_counter() - started,
        "invalid_outputs": invalid,
        "complete_probability_vectors": complete_vectors,
    }


base.evaluate_server = evaluate_server_probability_corrected

if __name__ == "__main__":
    base.main()
