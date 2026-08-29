# Realistic GGUF Arabic Quantization Validation

## Setup

- Model pair: `Qwen2.5-0.5B-Instruct-f16.gguf` vs `Qwen2.5-0.5B-Instruct-Q4_K_M.gguf`
- Dataset: ArabicMMLU, paired sample n=240, seed=20260829
- Runtime: llama.cpp, deterministic constrained one-digit completion
- Quantization: production-style Q4_K_M, not hand-written fake quantization

## Primary paired result

| Metric | F16 | Q4_K_M |
|---|---:|---:|
| Accuracy | 31.25% | 29.17% |
| Correct answers | 75 | 70 |

- Correct→wrong: **9**
- Wrong→correct: **4**
- Net correctness loss: **5**
- Any prediction change: **19 (7.92%)**
- Accuracy delta: **-2.08%**, bootstrap 95% CI [-5.00%, 0.83%]
- Exact McNemar p: **0.266846**

## Risk prediction

Selected model: **random_forest**; positives=9.

| Predictor | AUROC | AUPRC | Recall@10% | Lift@10% |
|---|---:|---:|---:|---:|
| logistic | 0.541 | 0.063 | 0.222 | 2.22× |
| random_forest | 0.599 | 0.074 | 0.222 | 2.22× |

## Selective F16 fallback

|   budget |   routed |   hybrid_accuracy |   gain_vs_q4 |   flips_recovered |   flip_recall |   harmful_reversions |
|---------:|---------:|------------------:|-------------:|------------------:|--------------:|---------------------:|
|     0    |        0 |          0.291667 |   0          |                 0 |      0        |                    0 |
|     0.05 |       12 |          0.291667 |   0          |                 1 |      0.111111 |                    1 |
|     0.1  |       24 |          0.295833 |   0.00416667 |                 2 |      0.222222 |                    1 |
|     0.15 |       36 |          0.3      |   0.00833333 |                 3 |      0.333333 |                    1 |
|     0.2  |       48 |          0.304167 |   0.0125     |                 4 |      0.444444 |                    1 |
|     0.3  |       72 |          0.308333 |   0.0166667  |                 5 |      0.555556 |                    1 |

## Scope

This validates multiple-choice factuality transitions. It does not yet establish free-form Arabic hallucination rates, cross-model generality, or runtime savings.
