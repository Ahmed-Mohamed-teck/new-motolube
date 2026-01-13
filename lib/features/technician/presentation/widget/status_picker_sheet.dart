import 'package:flutter/material.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../domain/entity/booking_status.dart';

class StatusPickerSheet extends StatefulWidget {
  const StatusPickerSheet({
    super.key,
    required this.statuses,
    required this.selectedIds,
    this.allowMultiple = true,
  });

  final List<TechnicianBookingStatus> statuses;
  final Set<int> selectedIds;
  final bool allowMultiple;

  @override
  State<StatusPickerSheet> createState() => _StatusPickerSheetState();
}

class _StatusPickerSheetState extends State<StatusPickerSheet> {
  late final Set<int> _selection = {...widget.selectedIds};

  void _toggleSelection(int? statusId) {
    if (statusId == null) return;
    setState(() {
      if (widget.allowMultiple) {
        if (_selection.contains(statusId)) {
          _selection.remove(statusId);
        } else {
          _selection.add(statusId);
        }
      } else {
        _selection
          ..clear()
          ..add(statusId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selection.clear();
    });
  }

  void _applySelection() {
    Navigator.of(context).pop(_selection);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
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
                'Select booking statuses',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.statuses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final status = widget.statuses[index];
                    final statusId = int.tryParse(status.code);
                    final isSelected =
                        statusId != null && _selection.contains(statusId);
                    final color =
                        status.colorValue != null
                            ? Color(status.colorValue!)
                            : AppColors.lightPrimary;
                    return ListTile(
                      onTap: () => _toggleSelection(statusId),
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
                          widget.allowMultiple
                              ? Checkbox(
                                value: isSelected,
                                onChanged: (_) => _toggleSelection(statusId),
                                activeColor: color,
                              )
                              : Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected ? color : null,
                              ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: _clearSelection,
                    child: const Text('Clear'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _applySelection,
                    icon: const Icon(Icons.done),
                    label: Text(
                      widget.allowMultiple && _selection.isNotEmpty
                          ? 'Apply (${_selection.length})'
                          : 'Apply',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
}
