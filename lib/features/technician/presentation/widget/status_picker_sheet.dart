import 'package:flutter/material.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../domain/entity/booking_status.dart';

class StatusPickerSheet extends StatelessWidget {
  const StatusPickerSheet({
    super.key,
    required this.statuses,
    required this.selectedId,
    required this.onSelected,
  });

  final List<TechnicianBookingStatus> statuses;
  final int selectedId;
  final ValueChanged<TechnicianBookingStatus> onSelected;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: maxHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select booking status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: statuses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    final statusId = int.tryParse(status.code);
                    final isSelected =
                        statusId != null && statusId == selectedId;
                    final color =
                        status.colorValue != null
                            ? Color(status.colorValue!)
                            : AppColors.lightPrimary;
                    return ListTile(
                      onTap: () => onSelected(status),
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(
                          isSelected ? Icons.check : Icons.circle,
                          size: 14,
                          color: color,
                        ),
                      ),
                      title: Text(
                        status.label.isNotEmpty
                            ? status.label
                            : 'Status ${status.code}',
                      ),
                      subtitle: Text('ID ${status.code}'),
                      trailing:
                          isSelected
                              ? Icon(Icons.radio_button_checked, color: color)
                              : const Icon(Icons.radio_button_off),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
