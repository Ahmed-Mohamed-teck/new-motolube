import 'package:flutter/material.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.carTitle,
    required this.plate,
    required this.packageTitle,
    required this.dateLabel,
    required this.timeLabel,
    required this.locationLabel,
    required this.technicianLabel,
    this.statusText = 'Expired',
    this.statusBg = const Color(0xFFFDE7E6),
    this.statusFg = const Color(0xFFBE3A2E),
  });

  final String carTitle;
  final String plate;
  final String packageTitle;
  final String dateLabel;
  final String timeLabel;
  final String locationLabel;
  final String technicianLabel;
  final String statusText;
  final Color statusBg;
  final Color statusFg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceSubtle = theme.colorScheme.onSurface.withOpacity(.7);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(.2)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.directions_car_filled_rounded,
                size: 22,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  carTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: statusFg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              'Plate: $plate',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurfaceSubtle,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 14),
          _Line(
            icon: Icons.build_rounded,
            label: packageTitle,
            labelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          _Line(
            icon: Icons.event_rounded,
            label: '$dateLabel • $timeLabel',
            labelStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _Line(
            icon: Icons.location_on_rounded,
            label: locationLabel,
            labelStyle: theme.textTheme.bodyLarge?.copyWith(
              color: onSurfaceSubtle,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _Line(
            icon: Icons.engineering_rounded,
            label: technicianLabel,
            labelStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.icon,
    required this.label,
    required this.labelStyle,
  });

  final IconData icon;
  final String label;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withOpacity(.7),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: labelStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
