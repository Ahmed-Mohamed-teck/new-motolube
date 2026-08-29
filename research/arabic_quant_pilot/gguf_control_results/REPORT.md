# GGUF Q4_K_M and Label-Permutation Control

This confirmation uses llama.cpp for both F16 and Q4_K_M and evaluates the exact same ArabicMMLU items under original and deterministically permuted answer positions.

| Condition | F16 accuracy | Q4_K_M accuracy | Δ accuracy | Correct→Wrong | Wrong→Correct | Any change | McNemar p |
|---|---:|---:|---:|---:|---:|---:|---:|
| Original | 40.000% | 36.250% | -3.750% | 31 | 22 | 85 | 0.271679 |
| Permuted | 32.917% | 32.917% | +0.000% | 26 | 26 | 91 | 1 |

## Position/semantic control

- F16 semantic consistency after answer-position permutation: **40.833%**.
- Q4_K_M semantic consistency after answer-position permutation: **34.583%**.
- Original Q4_K_M label distribution: `{0: 46, 1: 34, 2: 34, 3: 124, 4: 2}`.
- Permuted Q4_K_M label distribution: `{0: 33, 1: 36, 2: 35, 3: 134, 4: 2}`.

A persistent concentration on the same numeric label after semantic options are permuted indicates label-position bias. A drop in Q4 semantic consistency relative to F16 indicates quantization-induced semantic instability beyond normal permutation sensitivity.
