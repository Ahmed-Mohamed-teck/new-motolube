import 'package:flutter/material.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';

class PromotionsSlider extends StatefulWidget {
  const PromotionsSlider({super.key});

  @override
  State<PromotionsSlider> createState() => _PromotionsSliderState();
}

class _PromotionsSliderState extends State<PromotionsSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(appLang.bestOffers,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
            const Spacer(),
            Text(appLang.more,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
          ],
        )
      ],
    );
  }
}
