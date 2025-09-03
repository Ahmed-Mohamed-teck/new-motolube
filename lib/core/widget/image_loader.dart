import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader({
    super.key,
    required this.url,
    required this.placeholder,
    this.fit = BoxFit.cover,
    this.cacheKey,
  });

  final String url;
  final Widget placeholder;
  final BoxFit fit;

  /// Optionally override the cache key (useful if the same URL can point to different content).
  final String? cacheKey;

  bool get _isAsset => url.trim().toLowerCase().startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      // Assets: no loading state needed
      return Image.asset(url, fit: fit);
    }

    // Network image: cached on disk + memory, with skeleton while loading
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: cacheKey ?? url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 250),
      imageBuilder: (context, provider) => Image(image: provider, fit: fit),
      placeholder: (context, _) => const _SkeletonTile(),
      errorWidget: (context, _, __) => placeholder,
    );
  }
}

/// A simple rectangular skeleton that fills the available space.
/// Uses Skeletonizer + Skeleton.leaf so the whole rect gets the shimmer effect.
class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceVariant;
    return Skeletonizer.zone(
      child: Skeleton.leaf(
        child: Container(color: color),
      ),
    );
  }
}
