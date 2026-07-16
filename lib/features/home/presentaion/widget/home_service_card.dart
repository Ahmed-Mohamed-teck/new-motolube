import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeServiceCard extends StatelessWidget {
  final String title;
  final String? iconPath;
  final String? photoUrl;
  final bool isLoading;
  final VoidCallback? onTap;

  const HomeServiceCard({
    super.key,
    required this.title,
    this.iconPath,
    this.photoUrl,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(20);

    final card = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow:
            isLoading
                ? null
                : [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
      ),
      child: Material(
        color: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.32),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImage(context),
                const SizedBox(height: 10),
                Expanded(child: _buildTitle(context)),
              ],
            ),
          ),
        ),
      ),
    );

    if (isLoading) {
      return ExcludeSemantics(child: card);
    }

    return Semantics(
      button: onTap != null,
      label: title,
      excludeSemantics: true,
      child: card,
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.09),
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: _buildImageContent(context),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    if (photoUrl != null && photoUrl!.trim().isNotEmpty) {
      return Image.network(
        photoUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        excludeFromSemantics: true,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return _defaultIcon(context);
        },
        errorBuilder: (_, __, ___) => _defaultIcon(context),
      );
    }

    if (iconPath != null && iconPath!.isNotEmpty) {
      return SvgPicture.asset(iconPath!, fit: BoxFit.contain);
    }

    return _defaultIcon(context);
  }

  Widget _buildTitle(BuildContext context) {
    if (isLoading) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 12,
          width: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _defaultIcon(BuildContext context) {
    return Icon(
      Icons.home_repair_service_rounded,
      size: 34,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
