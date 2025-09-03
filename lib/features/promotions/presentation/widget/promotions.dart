// import 'package:flutter/material.dart';
//
// class Promotions extends StatelessWidget {
//   const Promotions({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       width: double.infinity,
//       child:Image.network('https://d8iqbmvu05s9c.cloudfront.net/ajprhqgqg1otf7d5sm7u3brf27gv'),
//     );
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newmotorlube/core/widget/image_loader.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Promotions extends StatefulWidget {
  const Promotions({
    super.key,
    required this.imageUrls,
    this.height = 200,
    this.autoPlay = true,
    this.viewportFraction = 1,
    this.borderRadius = 0,
    this.enableInfiniteScroll = true,
  });

  final List<String> imageUrls;
  final double height;
  final bool autoPlay;
  final double viewportFraction;
  final double borderRadius;
  final bool enableInfiniteScroll;

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  final _controller = CarouselSliderController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: CarouselSlider.builder(
            carouselController: _controller,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, i, _) {
              final url = widget.imageUrls[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: ImageLoader(url: url, placeholder: const SizedBox(),),
              );
            },
            options: CarouselOptions(
              height: widget.height,
              autoPlay: widget.autoPlay,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 450),
              viewportFraction: widget.viewportFraction,
              enableInfiniteScroll: widget.enableInfiniteScroll,
              onPageChanged: (i, _) => setState(() => _index = i),
              padEnds: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imageUrls.length, (i) {
            final active = i == _index;
            return GestureDetector(
              onTap: () => _controller.animateToPage(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: active ? 18 : 8,
                decoration: BoxDecoration(
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

