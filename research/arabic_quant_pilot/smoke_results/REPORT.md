# Arabic Quantization-Induced Answer-Flip Pilot

- Model: `Qwen/Qwen3-0.6B`
- ArabicMMLU sample: **240** zero-shot items (seed 20260829)
- Reference: FP32; comparisons: W8A16 and W4A16 fake-quantized weights, group size 128
- Scoring: deterministic next-token likelihood over valid option digits

## Primary results

| Metric | FP32 | W8A16 | W4A16 |
|---|---:|---:|---:|
| Accuracy | 38.75% | 38.33% | 31.25% |
| Correct → wrong flips | — | 4 | 55 |
| Wrong → correct recoveries | — | 3 | 37 |
| Any prediction change | — | 13 | 134 |

### W4 paired inference

- Accuracy delta: **-7.50%**; paired bootstrap 95% CI [-15.00%, 0.01%].
- Conditional correct→wrong flip rate among FP32-correct items: **59.14%**; Wilson 95% CI [48.98%, 68.57%].
- Exact McNemar p-value: **0.0757602**.

## Risk prediction

Positive examples: 55 (22.92%). Selected out-of-fold model: **logistic**.

| Model | AUROC | AUPRC | Recall@10% | Lift@10% |
|---|---:|---:|---:|---:|
| logistic | 0.533 | 0.311 | 0.164 | 1.64× |
| random_forest | 0.506 | 0.285 | 0.145 | 1.45× |

## Selective FP32 fallback using out-of-fold risk

|   route_budget |   routed_items |   hybrid_accuracy |   absolute_gain_vs_w4 |   flips_recovered |   flip_recall |   harmful_reversions |
|---------------:|---------------:|------------------:|----------------------:|------------------:|--------------:|---------------------:|
|           0    |              0 |          0.3125   |             0         |                 0 |     0         |                    0 |
|           0.05 |             12 |          0.325    |             0.0125    |                 5 |     0.0909091 |                    2 |
|           0.1  |             24 |          0.341667 |             0.0291667 |                 9 |     0.163636  |                    2 |
|           0.15 |             36 |          0.358333 |             0.0458333 |                13 |     0.236364  |                    2 |
|           0.2  |             48 |          0.354167 |             0.0416667 |                15 |     0.272727  |                    5 |
|           0.3  |             72 |          0.354167 |             0.0416667 |                21 |     0.381818  |                   11 |

## Interpretation guardrails

1. This is a decision pilot on multiple-choice factuality, not yet a full free-form hallucination benchmark.
2. Fake quantization isolates quality loss but does not measure packed INT4 latency or memory.
3. One model and one benchmark cannot establish cross-model generality; a thesis should add at least two larger Arabic-capable models and generative evaluation.
4. Statistical significance does not by itself imply practical importance; transition counts, confidence intervals, and mitigation gains must be considered together.

## Sample W4 correct→wrong transitions

| item_id     | Subject                   | Question                                                                                                                                                                                  |   gold_human |   ref_human |   w4_human |   ref_confidence |   w4_confidence |   w4_margin |   w4_entropy |
|:------------|:--------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------:|------------:|-----------:|-----------------:|----------------:|------------:|-------------:|
| ammlu_10676 | Biology                   | يتم بناء الريبوسومات علي مرحلتين اولا بناء البروتين في السيتوبلازم ثانيا دخول البروتين الي النواه ويرتبط بrRNAحيث يخرج في صوره وحدتين                                                     |            1 |           1 |          2 |         0.572696 |        0.995651 |    0.991303 |    0.0403761 |
| ammlu_6155  | Social Science            | يظهر في خريطة فلسطين ثلاث جهات أصلية                                                                                                                                                      |            1 |           1 |          2 |         0.631872 |        0.987434 |    0.974868 |    0.0973612 |
| ammlu_3798  | General Knowledge         | العلم الذي سماه العرب(علم الحجر) هو علم ….؟                                                                                                                                               |            1 |           1 |          4 |         0.819633 |        0.977034 |    0.958907 |    0.0894182 |
| ammlu_705   | Driving Test              | في الدوّار، إذا لم يكن هناك أي عامل يتحكم بحركة المرور ولا إشارة مرور، من له حق الأولوية؟                                                                                                 |            1 |           1 |          4 |         0.684949 |        0.971658 |    0.955254 |    0.111292  |
| ammlu_9788  | Biology                   | العالم الذي حدد التركيب الأساسي للنيوكليوتيدات                                                                                                                                            |            1 |           1 |          4 |         0.587528 |        0.969126 |    0.947665 |    0.117171  |
| ammlu_515   | Islamic Studies           | بماذا لقب اسماعيل عليه السلام؟                                                                                                                                                            |            1 |           1 |          4 |         0.632384 |        0.966565 |    0.945602 |    0.126522  |
| ammlu_3686  | General Knowledge         | من أول من أخترع بارود البنادق؟                                                                                                                                                            |            1 |           1 |          4 |         0.536468 |        0.961574 |    0.940933 |    0.142758  |
| ammlu_7147  | Philosophy                | كمن يظل مغمض عينيه ال يحاول أن يفتحهما " .12 يقول "ديكارت" :" إن المرء الذي يحيا دون تفلسف لهو حقً يدل قول ديكارت علي أن الفلسفة.                                                         |            3 |           3 |          4 |         0.513686 |        0.954322 |    0.930285 |    0.165661  |
| ammlu_9970  | Biology                   | تحدث عملية النسخ في تصنيع البروتين حيث يتكون معقد بدء النسخ وذلك في خطوة يطلق عليها                                                                                                       |            1 |           1 |          4 |         0.979145 |        0.952106 |    0.922787 |    0.170713  |
| ammlu_7803  | Computer Science          | واحدة مما يلي لا تعد مثالا على الاعتداءات الالكترونية على البريد الالكتروني :                                                                                                             |            1 |           1 |          4 |         0.737058 |        0.943791 |    0.917177 |    0.195989  |
| ammlu_12513 | Arabic Language (Grammar) | أي من التكملات التالية هي الصحيحة بدلاً من [فراغ]                                                                                                                                         |            3 |           3 |          4 |         0.978019 |        0.934453 |    0.897046 |    0.219113  |
|             |                           | جاء الطلابُ، وقابلَــ[فراغ].الأستاذُ.                                                                                                                                                     |              |             |            |                  |                 |             |              |
| ammlu_2757  | History                   | من مؤلفات الملك عبدالله الاول :                                                                                                                                                           |            1 |           1 |          4 |         0.649982 |        0.930339 |    0.897197 |    0.231051  |
| ammlu_13241 | Islamic Studies           | سمي الصحابة الذين كلفهم الرسول بكتابة القرآن الكريم: ...                                                                                                                                  |            1 |           1 |          4 |         0.518385 |        0.927204 |    0.892848 |    0.239739  |
| ammlu_12832 | Islamic Studies           | أحافظ على الهدوء في بيتي ولا أزعج جيراني هذا التصرف من آداب                                                                                                                               |            1 |           1 |          4 |         0.771712 |        0.919083 |    0.877509 |    0.259933  |
| ammlu_6673  | Arabic Language           | قال الشاعر:                                                                                                                                                                               |            1 |           1 |          4 |         0.740107 |        0.91216  |    0.871831 |    0.277513  |
|             |                           |                                                                                                                                                                                           |              |             |            |                  |                 |             |              |
|             |                           | رفقًا بجفنٍ كلما أبكَيتِهِ * سال العَقيقُ به وقام الماءُ                                                                                                                                  |              |             |            |                  |                 |             |              |
|             |                           |                                                                                                                                                                                           |              |             |            |                  |                 |             |              |
|             |                           | ميز -مما يلي- سبب نصب كلمة «رفقا».                                                                                                                                                        |              |             |            |                  |                 |             |              |
| ammlu_1814  | Driving Test              | على السائق الذي يقود مركبته في الاتجاه المنحدر من الطريق الالتزام باقصى يمينه او ايقاف مركبته تماما وذلك لتمكين المركبة الصاعدة من المرور اذا كان عرض الطريق لا يسمح بمرور المركبتين معا. |            1 |           1 |          2 |         0.947157 |        0.902819 |    0.805637 |    0.459997  |
| ammlu_8234  | Geography                 | تسود المنخفضات الجوية ضمن منطقة هبوب الرياح:                                                                                                                                              |            1 |           1 |          4 |         0.79406  |        0.896875 |    0.835488 |    0.305078  |
| ammlu_9161  | Geography                 | يسهم ارتفاع درجة حرارة الأرض في زيادة المتوسط السنوي لتساقط الأمطار في العروض الوسطى، مما يؤدي                                                                                            |            1 |           1 |          4 |         0.797958 |        0.892525 |    0.830946 |    0.318244  |
|             |                           | إلى زيادة تدفق المياه في الأودية واألنهار وحدوث الفيضانات في مناطق عديدة، خاصة في:                                                                                                        |              |             |            |                  |                 |             |              |
| ammlu_2876  | History                   | اتحاد عربي من اهدافه تنمية البلدين وتطويرهما بالمشاريع الاقتصادية المشتركة بطريقة تكاملية تسهم في دفع المسيرة التنموية في كلا البلدين هو :                                                |            1 |           1 |          4 |         0.553312 |        0.886709 |    0.831066 |    0.335743  |
| ammlu_1137  | Driving Test              | يحق لك كدراج أن تتجاوز المركبة التي أمامك:                                                                                                                                                |            1 |           1 |          3 |         0.671208 |        0.886314 |    0.810403 |    0.388156  |
