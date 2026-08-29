# Full-Option Semantic Likelihood Control

Every answer is scored using the length-normalized conditional log-likelihood of its full Arabic text. No digit or letter answer token is used for selection.

| Condition | F16 accuracy | Q4_K_M accuracy | Δ | Correct→Wrong | Wrong→Correct | Any prediction change | McNemar p |
|---|---:|---:|---:|---:|---:|---:|---:|
| Original | 42.00% | 41.00% | -1.00% | 6 | 5 | 22 | 1 |
| Permuted | 38.00% | 34.00% | -4.00% | 8 | 4 | 20 | 0.387695 |

## Semantic consistency under option reordering

- F16: **63.00%** (63/100).
- Q4_K_M: **68.00%** (68/100).

Original F16 prediction distribution: `{'1': 37, '2': 26, '3': 17, '4': 20}`.
Original Q4_K_M prediction distribution: `{'1': 42, '2': 25, '3': 19, '4': 14}`.

This control should carry more weight than next-token digit scoring when deciding whether the phenomenon is semantic or merely token/position bias.
