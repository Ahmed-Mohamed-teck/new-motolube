# Arabic quantization-induced answer-flip pilot

This isolated research branch contains a reproducible decision pilot for a proposed master's topic.

## Research question

Does post-training low-bit weight quantization turn Arabic multiple-choice answers that are correct in the unchanged checkpoint into wrong answers, and are those failures predictable from signals available in the quantized model?

## Fixed design

- Model: `Qwen/Qwen3-0.6B`
- Data: deterministic, subject-stratified sample of 1,200 zero-shot questions from ArabicMMLU
- Reference: FP32 checkpoint
- Comparisons: group-wise symmetric round-to-nearest W8A16 and W4A16; group size 128
- Inference: deterministic next-token scoring of the valid answer digits
- Statistics: paired transition counts, Wilson confidence intervals, paired bootstrap interval, and exact McNemar test
- Exploratory mitigation: out-of-fold logistic/random-forest risk prediction and selective FP32 fallback at fixed routing budgets

The W8/W4 experiments dequantize the quantized weights back to floating point for CPU execution. The experiment therefore measures **quality effects only**; it does not claim packed-runtime memory or latency gains.

The workflow commits its result files back to this branch under `research/arabic_quant_pilot/results/` and also uploads them as a GitHub Actions artifact.
