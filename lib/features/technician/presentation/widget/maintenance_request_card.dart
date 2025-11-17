import 'package:flutter/material.dart';

class MaintenanceRequestCard extends StatelessWidget {
  final String initials;
  final String name;
  final String car;
  final String plate;
  final String timeRange;
  final String branch;
  final String service;
  final String status;
  final Color statusColor;
  final VoidCallback? onViewDetails;

  const MaintenanceRequestCard({
    super.key,
    required this.initials,
    required this.name,
    required this.car,
    required this.plate,
    required this.timeRange,
    required this.branch,
    required this.service,
    required this.status,
    required this.statusColor,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final accent = statusColor;
    final subtle = accent.withOpacity(0.08);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: accent.withOpacity(0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onViewDetails,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: accent,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          service.isNotEmpty ? service : 'Maintenance package',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: subtle,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: subtle,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _infoChip(
                      icon: Icons.access_time_rounded,
                      text: timeRange,
                      color: accent,
                    ),
                    const SizedBox(width: 12),
                    _infoChip(
                      icon: Icons.location_on_outlined,
                      text: branch,
                      color: accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.directions_car_filled_outlined, text: car),
              _InfoRow(icon: Icons.confirmation_number_outlined, text: plate),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onViewDetails,
                      icon: Icon(Icons.visibility_rounded, color: accent),
                      label: Text(
                        'View details',
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: accent.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
