#!/usr/bin/env python3
"""Realistic Arabic quantization validation: F16 GGUF vs Q4_K_M GGUF.

Runs the same Qwen2.5-0.5B-Instruct checkpoint through llama.cpp using two
GGUF encodings. The test is paired question-by-question on ArabicMMLU.
"""
from __future__ import annotations

import argparse
import json
import math
import os
import random
import re
import signal
import subprocess
import time
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd
import requests
from scipy.stats import binomtest
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import average_precision_score, roc_auc_score
from sklearn.model_selection import StratifiedKFold, cross_val_predict
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

DATA_URL = "https://raw.githubusercontent.com/mbzuai-nlp/ArabicMMLU/main/data/ArabicMMLU.csv"
KEY_TO_INDEX = {"A": 0, "B": 1, "C": 2, "D": 3, "E": 4}
SYSTEM_MESSAGE = "أنت مساعد دقيق. أجب برقم الخيار الصحيح فقط دون شرح أو كلمات إضافية."


def seed_everything(seed: int) -> None:
    random.seed(seed)
    np.random.seed(seed)


def option_count(row: pd.Series) -> int:
    count = 0
    for i in range(1, 6):
        value = row.get(f"Option {i}")
        if pd.isna(value) or not str(value).strip():
            break
        count += 1
    return count


def sample_data(csv_path: Path, n: int, seed: int, max_chars: int) -> pd.DataFrame:
    if not csv_path.exists():
        r = requests.get(DATA_URL, timeout=120)
        r.raise_for_status()
        csv_path.parent.mkdir(parents=True, exist_ok=True)
        csv_path.write_bytes(r.content)
    df = pd.read_csv(csv_path)
    if "is_few_shot" in df.columns:
        df = df[df["is_few_shot"].fillna(0).astype(int) == 0]
    df = df[df["Answer Key"].isin(KEY_TO_INDEX) & df["Question"].notna()].copy()
    df["n_options"] = df.apply(option_count, axis=1)
    df = df[df["n_options"] >= 2].copy()
    df["gold"] = df["Answer Key"].map(KEY_TO_INDEX).astype(int)
    df["source_row"] = df.index.astype(int)
    for col in ("Subject", "Level", "Country"):
        if col not in df.columns:
            df[col] = "Unknown"
        df[col] = df[col].fillna("Unknown").astype(str)

    n = min(n, len(df))
    rng = np.random.default_rng(seed)
    df["_r"] = rng.random(len(df))
    proportions = df["Subject"].value_counts(normalize=True)
    raw_alloc = proportions * n
    alloc = raw_alloc.apply(math.floor).astype(int)
    alloc[alloc == 0] = 1
    while int(alloc.sum()) > n:
        candidates = alloc[alloc > 1]
        if candidates.empty:
            break
        alloc[candidates.idxmax()] -= 1
    for subject in (raw_alloc - np.floor(raw_alloc)).sort_values(ascending=False).index:
        if int(alloc.sum()) >= n:
            break
        capacity = int((df["Subject"] == subject).sum())
        if int(alloc.get(subject, 0)) < capacity:
            alloc[subject] = int(alloc.get(subject, 0)) + 1

    parts = []
    for subject, k in alloc.items():
        parts.append(df[df["Subject"] == subject].sort_values("_r").head(int(k)))
    out = pd.concat(parts, ignore_index=True)
    if len(out) < n:
        chosen = set(out["source_row"])
        out = pd.concat(
            [out, df[~df["source_row"].isin(chosen)].sort_values("_r").head(n - len(out))],
            ignore_index=True,
        )
    out = out.sample(frac=1, random_state=seed).reset_index(drop=True)
    out["item_id"] = out["source_row"].map(lambda x: f"ammlu_{x}")

    def prompt(row: pd.Series) -> str:
        question = str(row["Question"]).strip()
        context = "" if pd.isna(row.get("Context")) else str(row.get("Context", "")).strip()
        context_budget = max(0, max_chars - len(question) - 250)
        if len(context) > context_budget:
            context = context[:context_budget]
        stem = f"{context}\n\n{question}" if context else question
        options = "\n".join(
            f"{i}) {str(row[f'Option {i}']).strip()}"
            for i in range(1, int(row["n_options"]) + 1)
        )
        return (
            "اختر الإجابة الصحيحة من الخيارات التالية. أخرج رقمًا واحدًا فقط.\n\n"
            f"السؤال:\n{stem}\n\nالخيارات:\n{options}"
        )

    out["user_prompt"] = out.apply(prompt, axis=1)
    return out.drop(columns=["_r"], errors="ignore")


class LlamaServer:
    def __init__(self, binary: str, model: Path, port: int, threads: int, log_path: Path):
        self.binary = binary
        self.model = model
        self.port = port
        self.threads = threads
        self.log_path = log_path
        self.process: subprocess.Popen[str] | None = None
        self.log_file: Any = None

    @property
    def base_url(self) -> str:
        return f"http://127.0.0.1:{self.port}"

    def start(self) -> None:
        exe = Path(self.binary).name
        cmd = [self.binary]
        if exe == "llama":
            cmd.append("serve")
        cmd += [
            "-m", str(self.model),
            "--host", "127.0.0.1",
            "--port", str(self.port),
            "-c", "8192",
            "-t", str(self.threads),
            "-np", "4",
            "--no-warmup",
        ]
        self.log_path.parent.mkdir(parents=True, exist_ok=True)
        self.log_file = self.log_path.open("w", encoding="utf-8")
        self.process = subprocess.Popen(
            cmd,
            stdout=self.log_file,
            stderr=subprocess.STDOUT,
            text=True,
            start_new_session=True,
        )
        deadline = time.time() + 240
        last_error = ""
        while time.time() < deadline:
            if self.process.poll() is not None:
                raise RuntimeError(f"llama server exited early ({self.process.returncode}); see {self.log_path}")
            try:
                r = requests.get(f"{self.base_url}/health", timeout=5)
                if r.status_code == 200:
                    return
                last_error = f"HTTP {r.status_code}: {r.text[:200]}"
            except Exception as exc:
                last_error = str(exc)
            time.sleep(2)
        raise TimeoutError(f"server did not become healthy: {last_error}")

    def stop(self) -> None:
        if self.process and self.process.poll() is None:
            try:
                os.killpg(self.process.pid, signal.SIGTERM)
                self.process.wait(timeout=30)
            except Exception:
                try:
                    os.killpg(self.process.pid, signal.SIGKILL)
                except Exception:
                    pass
        if self.log_file:
            self.log_file.close()

    def __enter__(self) -> "LlamaServer":
        self.start()
        return self

    def __exit__(self, exc_type: Any, exc: Any, tb: Any) -> None:
        self.stop()


def apply_template(base_url: str, user_prompt: str, session: requests.Session) -> str:
    payload = {
        "messages": [
            {"role": "system", "content": SYSTEM_MESSAGE},
            {"role": "user", "content": user_prompt},
        ]
    }
    r = session.post(f"{base_url}/apply-template", json=payload, timeout=60)
    r.raise_for_status()
    prompt = r.json().get("prompt")
    if not isinstance(prompt, str) or not prompt:
        prompt = (
            f"<|im_start|>system\n{SYSTEM_MESSAGE}<|im_end|>\n"
            f"<|im_start|>user\n{user_prompt}<|im_end|>\n"
            "<|im_start|>assistant\n"
        )
    return prompt


def grammar_for(n_options: int) -> str:
    return "root ::= " + " | ".join(f'"{i}"' for i in range(1, n_options + 1))


def parse_probabilities(result: dict[str, Any], n_options: int, pred: int) -> tuple[np.ndarray, bool]:
    probs = np.zeros(n_options, dtype=float)
    entries = result.get("probs") or result.get("completion_probabilities") or []
    top_entries: list[dict[str, Any]] = []
    if entries:
        first = entries[0]
        top_entries = first.get("top_probs") or first.get("top_logprobs") or []
    for entry in top_entries:
        token = str(entry.get("token", "")).strip()
        m = re.fullmatch(r"[1-5]", token)
        if not m:
            continue
        index = int(token) - 1
        if index >= n_options:
            continue
        if "prob" in entry:
            value = float(entry["prob"])
        elif "logprob" in entry:
            value = math.exp(float(entry["logprob"]))
        else:
            continue
        probs[index] += value
    complete = int(np.count_nonzero(probs > 0)) == n_options
    if probs.sum() <= 0:
        probs[pred] = 1.0
    else:
        probs /= probs.sum()
    return probs, complete


def evaluate_server(
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
    failures = 0
    probability_complete = 0

    for n_options in sorted(data["n_options"].unique()):
        subset = data[data["n_options"] == n_options].reset_index(drop=True)
        for start in range(0, len(subset), batch_size):
            batch = subset.iloc[start : start + batch_size]
            prompts = [chat_prompts[x] for x in batch["item_id"]]
            payload = {
                "prompt": prompts,
                "n_predict": 1,
                "n_cmpl": 1,
                "temperature": -1.0,
                "top_k": 0,
                "top_p": 1.0,
                "min_p": 0.0,
                "repeat_penalty": 1.0,
                "grammar": grammar_for(int(n_options)),
                "n_probs": 10,
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
                raise RuntimeError(f"expected {len(batch)} results, received {len(results)}")

            for (_, item), result in zip(batch.iterrows(), results):
                content = str(result.get("content", ""))
                match = re.search(r"[1-5]", content)
                if not match or int(match.group()) > int(n_options):
                    failures += 1
                    pred = 0
                    valid = False
                else:
                    pred = int(match.group()) - 1
                    valid = True
                prob, complete = parse_probabilities(result, int(n_options), pred)
                probability_complete += int(complete)
                order = np.argsort(-prob)
                top1 = float(prob[order[0]])
                top2 = float(prob[order[1]]) if len(order) > 1 else 0.0
                entropy = float(-(prob[prob > 0] * np.log(prob[prob > 0])).sum() / math.log(n_options))
                timings = result.get("timings", {}) or {}
                rows.append(
                    {
                        "item_id": item["item_id"],
                        f"{variant}_pred": pred,
                        f"{variant}_valid": valid,
                        f"{variant}_content": content,
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
                print(f"[{variant}] {done}/{len(data)}", flush=True)

    meta = {
        "elapsed_seconds": time.perf_counter() - started,
        "invalid_outputs": failures,
        "complete_probability_vectors": probability_complete,
    }
    return pd.DataFrame(rows), meta


def wilson(k: int, n: int, z: float = 1.959963984540054) -> list[float]:
    if n == 0:
        return [0.0, 0.0]
    p = k / n
    d = 1 + z * z / n
    c = (p + z * z / (2 * n)) / d
    h = z * math.sqrt((p * (1 - p) + z * z / (4 * n)) / n) / d
    return [c - h, c + h]


def bootstrap_delta(ref: np.ndarray, q4: np.ndarray, seed: int, b: int = 10000) -> list[float]:
    rng = np.random.default_rng(seed)
    paired = q4.astype(float) - ref.astype(float)
    values = np.empty(b)
    for i in range(b):
        values[i] = paired[rng.integers(0, len(paired), len(paired))].mean()
    return [float(np.quantile(values, 0.025)), float(np.quantile(values, 0.975))]


def paired_summary(df: pd.DataFrame, seed: int) -> dict[str, Any]:
    gold = df["gold"].to_numpy()
    ref = df["f16_pred"].to_numpy()
    q4 = df["q4_pred"].to_numpy()
    rc = ref == gold
    qc = q4 == gold
    c2w = int(np.sum(rc & ~qc))
    w2c = int(np.sum(~rc & qc))
    discordant = c2w + w2c
    changes = int(np.sum(ref != q4))
    return {
        "n": len(df),
        "f16_accuracy": float(rc.mean()),
        "q4_accuracy": float(qc.mean()),
        "accuracy_delta_q4_minus_f16": float(qc.mean() - rc.mean()),
        "accuracy_delta_bootstrap_95ci": bootstrap_delta(rc, qc, seed),
        "correct_to_wrong": c2w,
        "wrong_to_correct": w2c,
        "net_correctness_loss": c2w - w2c,
        "correct_to_wrong_rate_among_f16_correct": float(c2w / max(int(rc.sum()), 1)),
        "correct_to_wrong_wilson_95ci": wilson(c2w, int(rc.sum())),
        "prediction_changes": changes,
        "prediction_change_rate": float(changes / len(df)),
        "prediction_change_wilson_95ci": wilson(changes, len(df)),
        "mcnemar_exact_p": float(binomtest(min(c2w, w2c), discordant, 0.5).pvalue) if discordant else 1.0,
        "f16_correct": int(rc.sum()),
        "q4_correct": int(qc.sum()),
    }


def predictor_and_routing(df: pd.DataFrame, seed: int) -> tuple[dict[str, Any], pd.DataFrame, pd.DataFrame]:
    y = ((df["f16_pred"] == df["gold"]) & (df["q4_pred"] != df["gold"])).astype(int).to_numpy()
    features = pd.DataFrame({
        "confidence": df["q4_confidence"],
        "margin": df["q4_margin"],
        "entropy": df["q4_entropy"],
        "tokens": df["q4_tokens_evaluated"],
        "n_options": df["n_options"],
        "subject": df["Subject"].astype(str),
        "level": df["Level"].astype(str),
        "country": df["Country"].astype(str),
        "pred": df["q4_pred"].astype(str),
    })
    positives = int(y.sum())
    negatives = int(len(y) - positives)
    scores_df = pd.DataFrame({"item_id": df["item_id"], "flip": y})
    if positives < 5 or negatives < 5:
        metrics = {"status": "insufficient_examples", "positives": positives, "negatives": negatives}
        risk = 1 - df["q4_confidence"].to_numpy()
        selected = "uncertainty"
    else:
        numeric = ["confidence", "margin", "entropy", "tokens", "n_options"]
        categorical = ["subject", "level", "country", "pred"]
        prep = ColumnTransformer([
            ("num", Pipeline([("impute", SimpleImputer(strategy="median")), ("scale", StandardScaler())]), numeric),
            ("cat", OneHotEncoder(handle_unknown="ignore", min_frequency=2), categorical),
        ])
        models = {
            "logistic": LogisticRegression(max_iter=3000, class_weight="balanced", random_state=seed),
            "random_forest": RandomForestClassifier(
                n_estimators=400, min_samples_leaf=4, class_weight="balanced_subsample",
                random_state=seed, n_jobs=-1,
            ),
        }
        folds = min(5, positives, negatives)
        cv = StratifiedKFold(folds, shuffle=True, random_state=seed)
        model_metrics: dict[str, Any] = {}
        for name, estimator in models.items():
            pipe = Pipeline([("prep", prep), ("model", estimator)])
            scores = cross_val_predict(pipe, features, y, cv=cv, method="predict_proba", n_jobs=1)[:, 1]
            scores_df[f"{name}_risk"] = scores
            m: dict[str, Any] = {
                "auroc": float(roc_auc_score(y, scores)),
                "auprc": float(average_precision_score(y, scores)),
            }
            for budget in (0.05, 0.10, 0.15, 0.20):
                k = max(1, round(len(y) * budget))
                idx = np.argsort(-scores)[:k]
                precision = float(y[idx].mean())
                m[f"recall_at_{int(budget*100)}pct"] = float(y[idx].sum() / positives)
                m[f"precision_at_{int(budget*100)}pct"] = precision
                m[f"lift_at_{int(budget*100)}pct"] = float(precision / (positives / len(y)))
            model_metrics[name] = m
        selected = max(model_metrics, key=lambda x: model_metrics[x]["auprc"])
        risk = scores_df[f"{selected}_risk"].to_numpy()
        metrics = {
            "status": "ok", "positives": positives, "negatives": negatives,
            "prevalence": positives / len(y), "folds": folds,
            "models": model_metrics, "selected_model": selected,
        }

    f16 = df["f16_pred"].to_numpy()
    q4 = df["q4_pred"].to_numpy()
    gold = df["gold"].to_numpy()
    flip = (f16 == gold) & (q4 != gold)
    harmful = (f16 != gold) & (q4 == gold)
    q4_acc = float(np.mean(q4 == gold))
    routes = []
    for budget in (0.0, 0.05, 0.10, 0.15, 0.20, 0.30):
        k = round(len(df) * budget)
        routed = np.zeros(len(df), dtype=bool)
        if k:
            routed[np.argsort(-risk)[:k]] = True
        hybrid = q4.copy()
        hybrid[routed] = f16[routed]
        routes.append({
            "budget": budget,
            "routed": int(routed.sum()),
            "hybrid_accuracy": float(np.mean(hybrid == gold)),
            "gain_vs_q4": float(np.mean(hybrid == gold) - q4_acc),
            "flips_recovered": int(np.sum(routed & flip)),
            "flip_recall": float(np.sum(routed & flip) / max(int(flip.sum()), 1)),
            "harmful_reversions": int(np.sum(routed & harmful)),
        })
    return metrics, scores_df, pd.DataFrame(routes)


def report(summary: dict[str, Any], routing: pd.DataFrame) -> str:
    p = summary["paired"]
    pred = summary["predictor"]
    pct = lambda x: f"{100*x:.2f}%"
    lines = [
        "# Realistic GGUF Arabic Quantization Validation",
        "",
        "## Setup",
        "",
        f"- Model pair: `{summary['run']['f16_file']}` vs `{summary['run']['q4_file']}`",
        f"- Dataset: ArabicMMLU, paired sample n={p['n']}, seed={summary['run']['seed']}",
        "- Runtime: llama.cpp, deterministic constrained one-digit completion",
        "- Quantization: production-style Q4_K_M, not hand-written fake quantization",
        "",
        "## Primary paired result",
        "",
        "| Metric | F16 | Q4_K_M |",
        "|---|---:|---:|",
        f"| Accuracy | {pct(p['f16_accuracy'])} | {pct(p['q4_accuracy'])} |",
        f"| Correct answers | {p['f16_correct']} | {p['q4_correct']} |",
        "",
        f"- Correct→wrong: **{p['correct_to_wrong']}**",
        f"- Wrong→correct: **{p['wrong_to_correct']}**",
        f"- Net correctness loss: **{p['net_correctness_loss']}**",
        f"- Any prediction change: **{p['prediction_changes']} ({pct(p['prediction_change_rate'])})**",
        f"- Accuracy delta: **{pct(p['accuracy_delta_q4_minus_f16'])}**, bootstrap 95% CI "
        f"[{pct(p['accuracy_delta_bootstrap_95ci'][0])}, {pct(p['accuracy_delta_bootstrap_95ci'][1])}]",
        f"- Exact McNemar p: **{p['mcnemar_exact_p']:.6g}**",
        "",
        "## Risk prediction",
        "",
    ]
    if pred.get("status") == "ok":
        lines.append(f"Selected model: **{pred['selected_model']}**; positives={pred['positives']}.")
        lines += ["", "| Predictor | AUROC | AUPRC | Recall@10% | Lift@10% |", "|---|---:|---:|---:|---:|"]
        for name, m in pred["models"].items():
            lines.append(f"| {name} | {m['auroc']:.3f} | {m['auprc']:.3f} | {m['recall_at_10pct']:.3f} | {m['lift_at_10pct']:.2f}× |")
    else:
        lines.append(f"Predictor not fitted: {pred.get('positives', 0)} positive transitions.")
    lines += ["", "## Selective F16 fallback", "", routing.to_markdown(index=False), "",
              "## Scope", "",
              "This validates multiple-choice factuality transitions. It does not yet establish free-form Arabic hallucination rates, cross-model generality, or runtime savings."]
    return "\n".join(lines) + "\n"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--server-bin", required=True)
    ap.add_argument("--f16-model", type=Path, required=True)
    ap.add_argument("--q4-model", type=Path, required=True)
    ap.add_argument("--sample-size", type=int, default=800)
    ap.add_argument("--seed", type=int, default=20260829)
    ap.add_argument("--batch-size", type=int, default=4)
    ap.add_argument("--threads", type=int, default=4)
    ap.add_argument("--max-chars", type=int, default=1800)
    ap.add_argument("--output-dir", type=Path, required=True)
    args = ap.parse_args()
    seed_everything(args.seed)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    cache = args.output_dir.parent / "cache" / "ArabicMMLU.csv"
    data = sample_data(cache, args.sample_size, args.seed, args.max_chars)
    base_cols = [
        "item_id", "source_row", "Subject", "Level", "Country", "Question", "Context",
        "Option 1", "Option 2", "Option 3", "Option 4", "Option 5",
        "n_options", "gold", "user_prompt",
    ]
    combined = data[base_cols].copy()
    metadata: dict[str, Any] = {}

    chat_prompts: dict[str, str] = {}
    with LlamaServer(args.server_bin, args.f16_model, 8081, args.threads, args.output_dir / "f16_server.log") as server:
        session = requests.Session()
        for i, row in data.iterrows():
            chat_prompts[row["item_id"]] = apply_template(server.base_url, row["user_prompt"], session)
            if (i + 1) % 200 == 0:
                print(f"templated {i+1}/{len(data)}", flush=True)
        f16, metadata["f16"] = evaluate_server(
            server.base_url, data, chat_prompts, "f16", args.batch_size, args.seed
        )
        control_n = min(50, len(data))
        control, _ = evaluate_server(
            server.base_url, data.head(control_n), chat_prompts, "control", args.batch_size, args.seed
        )
        deterministic_matches = int(np.sum(
            f16.set_index("item_id").loc[control["item_id"], "f16_pred"].to_numpy()
            == control["control_pred"].to_numpy()
        ))
    combined = combined.merge(f16, on="item_id", validate="one_to_one")

    with LlamaServer(args.server_bin, args.q4_model, 8082, args.threads, args.output_dir / "q4_server.log") as server:
        q4, metadata["q4"] = evaluate_server(
            server.base_url, data, chat_prompts, "q4", args.batch_size, args.seed
        )
    combined = combined.merge(q4, on="item_id", validate="one_to_one")
    combined["f16_correct"] = combined["f16_pred"] == combined["gold"]
    combined["q4_correct"] = combined["q4_pred"] == combined["gold"]
    combined["correct_to_wrong"] = combined["f16_correct"] & ~combined["q4_correct"]
    combined["wrong_to_correct"] = ~combined["f16_correct"] & combined["q4_correct"]
    combined["prediction_changed"] = combined["f16_pred"] != combined["q4_pred"]

    paired = paired_summary(combined, args.seed)
    predictor, scores, routing = predictor_and_routing(combined, args.seed)
    summary = {
        "run": {
            "model_repo": "bartowski/Qwen2.5-0.5B-Instruct-GGUF",
            "f16_file": args.f16_model.name,
            "q4_file": args.q4_model.name,
            "sample_size": len(data),
            "seed": args.seed,
            "batch_size": args.batch_size,
            "threads": args.threads,
            "max_chars": args.max_chars,
            "github_run_id": os.environ.get("GITHUB_RUN_ID"),
            "determinism_control_items": min(50, len(data)),
            "determinism_exact_matches": deterministic_matches,
            "determinism_passed": deterministic_matches == min(50, len(data)),
            "runtime": metadata,
        },
        "paired": paired,
        "predictor": predictor,
        "routing": routing.to_dict(orient="records"),
    }
    combined.to_csv(args.output_dir / "per_question_results.csv", index=False)
    combined[combined["correct_to_wrong"]].to_csv(args.output_dir / "correct_to_wrong_examples.csv", index=False)
    routing.to_csv(args.output_dir / "routing_curve.csv", index=False)
    scores.to_csv(args.output_dir / "predictor_oof_scores.csv", index=False)
    (args.output_dir / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    (args.output_dir / "REPORT.md").write_text(report(summary, routing), encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2), flush=True)


if __name__ == "__main__":
    main()
