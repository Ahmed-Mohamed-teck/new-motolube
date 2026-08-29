# Realistic GGUF Arabic Quantization Validation

## Setup

- Model pair: `Qwen2.5-0.5B-Instruct-f16.gguf` vs `Qwen2.5-0.5B-Instruct-Q4_K_M.gguf`
- Dataset: ArabicMMLU, paired sample n=800, seed=20260829
- Runtime: llama.cpp, deterministic constrained one-digit completion
- Quantization: production-style Q4_K_M, not hand-written fake quantization
- Determinism control: 50/50 exact repeated answers

## Primary paired result

| Metric | F16 | Q4_K_M |
|---|---:|---:|
| Accuracy | 31.62% | 29.50% |
| Correct answers | 253 | 236 |

- Correct→wrong: **33**
- Wrong→correct: **16**
- Net correctness loss: **17**
- Any prediction change: **83 (10.38%)**
- Accuracy delta: **-2.12 percentage points**, paired bootstrap 95% CI **[-3.88, -0.38] percentage points**
- Exact McNemar p-value: **0.0212941**
- Correct→wrong rate among F16-correct questions: **13.04%**, Wilson 95% CI **[9.44%, 17.75%]**

## Preliminary risk prediction

The first pass used greedy post-sampling probabilities, which collapsed the probability vectors. Therefore, the transition counts above are valid, but uncertainty-based predictor claims are not accepted from this run. A separate probability-corrected run was launched.

Metadata-only preliminary model:

| Predictor | AUROC | AUPRC | Recall@10% | Lift@10% |
|---|---:|---:|---:|---:|
| logistic | 0.630 | 0.062 | 0.091 | 0.91× |
| random forest | 0.673 | 0.078 | 0.242 | 2.42× |

These numbers must not be treated as evidence that confidence predicts the failure until the corrected probability run is complete.

## Preliminary selective F16 fallback

| Budget | Routed | Hybrid accuracy | Gain vs Q4 | Flips recovered | Harmful reversions |
|---:|---:|---:|---:|---:|---:|
| 0% | 0 | 29.50% | 0.00 pp | 0 | 0 |
| 5% | 40 | 30.00% | +0.50 pp | 4 | 0 |
| 10% | 80 | 30.38% | +0.88 pp | 8 | 1 |
| 15% | 120 | 30.25% | +0.75 pp | 8 | 2 |
| 20% | 160 | 29.63% | +0.13 pp | 9 | 8 |

## Scope

This validates multiple-choice factuality transitions for one small Arabic-capable model and one Q4 format. It does not yet establish free-form Arabic hallucination rates, cross-model generality, or packed-runtime savings. The model's low baseline accuracy also means larger models are required before forming a final thesis claim.
