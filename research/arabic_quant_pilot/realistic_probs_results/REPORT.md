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

Selected model: **logistic**; positives=9.

| Predictor | AUROC | AUPRC | Recall@10% | Lift@10% |
|---|---:|---:|---:|---:|
| logistic | 0.865 | 0.199 | 0.333 | 3.33× |
| random_forest | 0.847 | 0.176 | 0.333 | 3.33× |

## Selective F16 fallback

|   budget |   routed |   hybrid_accuracy |   gain_vs_q4 |   flips_recovered |   flip_recall |   harmful_reversions |
|---------:|---------:|------------------:|-------------:|------------------:|--------------:|---------------------:|
|     0    |        0 |          0.291667 |   0          |                 0 |      0        |                    0 |
|     0.05 |       12 |          0.304167 |   0.0125     |                 3 |      0.333333 |                    0 |
|     0.1  |       24 |          0.3      |   0.00833333 |                 3 |      0.333333 |                    1 |
|     0.15 |       36 |          0.304167 |   0.0125     |                 4 |      0.444444 |                    1 |
|     0.2  |       48 |          0.3125   |   0.0208333  |                 6 |      0.666667 |                    1 |
|     0.3  |       72 |          0.316667 |   0.025      |                 8 |      0.888889 |                    2 |

## Scope

This validates multiple-choice factuality transitions. It does not yet establish free-form Arabic hallucination rates, cross-model generality, or runtime savings.
