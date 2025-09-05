import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newmotorlube/core/utils/extensions/extensions.dart';
import '../../../../core/widget/image_loader.dart';

class HomeCarOutlinedCard extends StatelessWidget {
  const HomeCarOutlinedCard({
    super.key,
    required this.imageUrl,
    required this.model,
    required this.plate,
    required this.chassis,
    this.maskChassis = true,

    this.heroTag,
    this.onBook,

  });

  // Data
  final String imageUrl;
  final String model;
  final String plate;
  final String chassis;
  final bool maskChassis;

  // Layout
  final Object? heroTag;

  // Actions
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chassisDisplay = chassis;

    return Card(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
              // IMAGE (responsive to available width)
              Hero(
                tag: heroTag ?? ValueKey(imageUrl),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ImageLoader(
                    url: imageUrl,
                    placeholder: const _ImageErrorTile(),
                  ),
                ),
              ),
              //
              // // DETAILS (fills remainder; internally kept ultra-compact)
              Padding(
                // Remove bottom padding so the card height hugs the content
                padding: const EdgeInsets.all(12),
                child: _DetailsCompact(
                  model: model,
                  plate: plate,
                  chassisDisplay: chassisDisplay,
                  onBook: onBook,
                ),
              ),
              const SizedBox(height: 8),
            ],
          )
    );
  }

  // --- helpers ---------------------------------------------------------------

  static void _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}

class _DetailsCompact extends StatelessWidget {
  const _DetailsCompact({
    required this.model,
    required this.plate,
    required this.chassisDisplay,
    required this.onBook,
  });

  final String model;
  final String plate;
  final String chassisDisplay;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Everything here is single-line & dense to guarantee fit.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title – compact style
        Text(
          model,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 2),

        _SpecRow(
          icon: Icons.confirmation_number_outlined,
          label: 'Plate',
          value: plate,
          onCopy:  () => HomeCarOutlinedCard._copy(context, plate),
        ),
        const SizedBox(height: 2),

        _SpecRow(
          icon: Icons.qr_code_2,
          label: 'Chassis',
          value: chassisDisplay,
          onCopy: () => HomeCarOutlinedCard._copy(context, chassisDisplay),
        ),

        const SizedBox(height: 8),

        if (onBook != null)
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onBook,
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Book Now'.toUpperCase()),
            ),
          ),
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          '$label:',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.05,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        if (onCopy != null)
          IconButton(
            tooltip: 'Copy',
            onPressed: onCopy,
            icon: const Icon(Icons.copy, size: 13),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
          ),
      ],
    );
  }
}

class _ImageErrorTile extends StatelessWidget {
  const _ImageErrorTile();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(child: Icon(Icons.image_not_supported_outlined, size: 20)),
    );
  }
}













