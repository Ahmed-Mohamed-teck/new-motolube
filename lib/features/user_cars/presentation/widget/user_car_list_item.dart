import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/widget/image_loader.dart';

/// Simple car data model (use your own if you already have one).
class CarInfo {
  final String imageUrl;   // Network or local asset (see `imageBuilder`)
  final String model;      // e.g., "Toyota Camry 2022"
  final String plate;      // e.g., "ABC-1234" or Arabic plates
  final String chassis;    // e.g., "JTNBE46KX63012345"
  const CarInfo({
    required this.imageUrl,
    required this.model,
    required this.plate,
    required this.chassis,
  });
}

/// Car Card widget
class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    required this.car,
    this.onTap,
    this.onLongPress,
    this.imageBuilder,
    this.heroTag,
    this.showDivider = false,
    this.maskChassis = true,
  });

  final CarInfo car;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget Function(BuildContext context, String imageUrl)? imageBuilder;
  final Object? heroTag;
  final bool showDivider;
  final bool maskChassis;

  static const _imageSize = 84.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScale = MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.3);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      label: 'Car card for ${car.model}, plate ${car.plate}',
      button: onTap != null || onLongPress != null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              surfaceTintColor: theme.colorScheme.surfaceTint,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildImage(context),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoColumn(
                        model: car.model,
                        plate: car.plate,
                        chassis: maskChassis ? _maskChassis(car.chassis) : car.chassis,
                        textScale: textScale,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(isRTL ? 270 : 0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showDivider) const SizedBox(height: 4),
            if (showDivider)
              Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outlineVariant.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1, // square thumb
        child: ImageLoader(
          url: car.imageUrl,
          placeholder: _PlaceholderTile(icon: Icons.directions_car_filled),
        ),
      ),
    );

    if (heroTag != null) {
      return SizedBox(
        width: _imageSize,
        height: _imageSize,
        child: Hero(tag: heroTag!, child: child),
      );
    }
    return SizedBox(width: _imageSize, height: _imageSize, child: child);
  }

  static String _maskChassis(String value) {
    if (value.isEmpty) return '';
    // Keep first 4 and last 3 visible for privacy; adapt as needed.
    final v = value.replaceAll(' ', '');
    if (v.length <= 7) return v;
    return '${v.substring(0, 4)}•' * 4 + v.substring(v.length - 3);
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.model,
    required this.plate,
    required this.chassis,
    required this.textScale,
  });

  final String model;
  final String plate;
  final String chassis;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Model (primary)
        Text(
          model,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(textScale),
        ),
        const SizedBox(height: 8),

        // Plate chip
        _InfoChip(
          icon: Icons.confirmation_number_outlined,
          label: plate,
          semanticsLabel: 'License plate $plate',
        ),
        const SizedBox(height: 6),

        // Chassis line
        Row(
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                chassis,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.semanticsLabel,
  });

  final IconData icon;
  final String label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticsLabel ?? label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _PlaceholderTile extends StatelessWidget {
  const _PlaceholderTile({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 28),
    );
  }
}

/// Very small shimmer-ish placeholder without extra packages.
class _ShimmerSkeleton extends StatefulWidget {
  @override
  State<_ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<_ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surfaceContainerLow;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, Color.lerp(base, highlight, _c.value)!, base],
              stops: const [0.2, 0.5, 0.8],
            ),
          ),
        );
      },
    );
  }
}
