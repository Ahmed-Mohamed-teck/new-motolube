import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';

import '../../domain/entity/job_card_package_entity.dart';
import '../../domain/entity/job_card_package_line_entity.dart';
import '../../provider/technician_provider.dart';
import '../view_model/job_card_operation_state.dart';
import 'technician_custom_package_screen.dart';

class TechnicianJobCardManagementScreen extends ConsumerStatefulWidget {
  const TechnicianJobCardManagementScreen({
    super.key,
    required this.srNumber,
    required this.userId,
  });

  final String srNumber;
  final String userId;

  @override
  ConsumerState<TechnicianJobCardManagementScreen> createState() =>
      _TechnicianJobCardManagementScreenState();
}

class _TechnicianJobCardManagementScreenState
    extends ConsumerState<TechnicianJobCardManagementScreen> {
  final TextEditingController _packageIdController = TextEditingController();
  final TextEditingController _campaignLineController = TextEditingController();
  final TextEditingController _checklistIdController = TextEditingController();
  final TextEditingController _checklistJsonController =
      TextEditingController(text: '{}');
  final TextEditingController _linesFilterController =
      TextEditingController();

  String? _linesPackageId;
  String? _deletingPackageLineId;

  @override
  void dispose() {
    _packageIdController.dispose();
    _campaignLineController.dispose();
    _checklistIdController.dispose();
    _checklistJsonController.dispose();
    _linesFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<JobCardOperationState>(
      jobCardOperationViewModelProvider,
      (previous, next) {
        if (next is JobCardOperationSuccess) {
          if (next.operationType == JobCardOperationType.addPackage) {
            _handleAddPackageSuccess(next.message);
          } else if (
            next.operationType == JobCardOperationType.submitChecklist
          ) {
            _handleChecklistSuccess(next.message);
          } else if (next.operationType == JobCardOperationType.deletePackage) {
            _handleDeletePackageSuccess(next.message);
          }
        } else if (next is JobCardOperationFailure) {
          if (next.operationType == JobCardOperationType.addPackage ||
              next.operationType == JobCardOperationType.submitChecklist) {
            _showSnack(next.message);
            ref.read(jobCardOperationViewModelProvider.notifier).reset();
          } else if (next.operationType == JobCardOperationType.deletePackage) {
            _handleDeletePackageFailure(next.message);
          }
        }
      },
    );

    final packagesAsync = ref.watch(
      packagesOfJobCardProvider(widget.srNumber),
    );

    final linesAsync = ref.watch(
      jobCardPackageLinesProvider(
        JobCardPackageLinesRequest(
          srNumber: widget.srNumber,
          packageId: _linesPackageId,
        ),
      ),
    );

    final actionState = ref.watch(jobCardOperationViewModelProvider);
    final addingPackage =
        actionState is JobCardOperationLoading &&
        actionState.operationType == JobCardOperationType.addPackage;
    final submittingChecklist =
        actionState is JobCardOperationLoading &&
        actionState.operationType == JobCardOperationType.submitChecklist;
    final deletingPackage =
        actionState is JobCardOperationLoading &&
        actionState.operationType == JobCardOperationType.deletePackage;

    return Scaffold(
      appBar: InternalAppBar(
        title: 'Job Card ${widget.srNumber}',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _PackagesCard(
            packagesAsync: packagesAsync,
            onRetry: () =>
                ref.invalidate(packagesOfJobCardProvider(widget.srNumber)),
            onManageCustomPackage:
                widget.userId.isNotEmpty ? _openCustomPackageManager : null,
            onDeletePackage:
                widget.userId.isNotEmpty ? _confirmDeletePackage : null,
            deletingLineId: _deletingPackageLineId,
            isDeleting: deletingPackage,
          ),
          const SizedBox(height: 16),


        ],
      ),
    );
  }




  Future<void> _openCustomPackageManager(
    JobCardPackageEntity package,
  ) async {
    if (widget.userId.isEmpty) {
      _showSnack('Unable to determine technician identifier.');
      return;
    }
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder:
            (context) => TechnicianCustomPackageScreen(
              package: package,
              jobCardNumber: widget.srNumber,
              userId: widget.userId,
            ),
      ),
    );
    if (!mounted) return;
    ref.invalidate(packagesOfJobCardProvider(widget.srNumber));
    ref.invalidate(
      jobCardPackageLinesProvider(
        JobCardPackageLinesRequest(
          srNumber: widget.srNumber,
          packageId: _linesPackageId,
        ),
      ),
    );
  }

  Future<void> _confirmDeletePackage(JobCardPackageEntity package) async {
    if (_deletingPackageLineId != null) {
      _showSnack('Please wait for the current action to complete.');
      return;
    }
    if (widget.userId.isEmpty) {
      _showSnack('Unable to determine technician identifier.');
      return;
    }
    final lineId = package.lineId.trim();
    if (lineId.isEmpty) {
      _showSnack('Package line ID is unavailable.');
      return;
    }
    final packageName =
        package.displayName.isNotEmpty
            ? package.displayName
            : package.packageCode;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove package'),
          content: Text(
            'Are you sure you want to remove "$packageName" from SR ${widget.srNumber}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !mounted) return;
    await _deletePackage(lineId);
  }

  Future<void> _deletePackage(String lineId) async {
    setState(() => _deletingPackageLineId = lineId);
    await ref.read(jobCardOperationViewModelProvider.notifier).deletePackage(
      packageLineId: lineId,
      userId: widget.userId,
    );
  }

  void _handleAddPackageSuccess(String message) {
    if (!mounted) return;
    _packageIdController.clear();
    _campaignLineController.clear();
    ref.read(jobCardOperationViewModelProvider.notifier).reset();
    _showSnack(message);
    ref.invalidate(technicianJobCardPackagesProvider(widget.srNumber));
    ref.invalidate(packagesOfJobCardProvider(widget.srNumber));
  }

  void _handleChecklistSuccess(String message) {
    if (!mounted) return;
    ref.read(jobCardOperationViewModelProvider.notifier).reset();
    _showSnack(message);
    _checklistIdController.clear();
    _checklistJsonController.text = '{}';
  }

  void _handleDeletePackageSuccess(String message) {
    if (!mounted) return;
    ref.read(jobCardOperationViewModelProvider.notifier).reset();
    setState(() => _deletingPackageLineId = null);
    _showSnack(message);
    ref.invalidate(technicianJobCardPackagesProvider(widget.srNumber));
    ref.invalidate(packagesOfJobCardProvider(widget.srNumber));
    ref.invalidate(
      jobCardPackageLinesProvider(
        JobCardPackageLinesRequest(
          srNumber: widget.srNumber,
          packageId: _linesPackageId,
        ),
      ),
    );
  }

  void _handleDeletePackageFailure(String message) {
    if (!mounted) return;
    ref.read(jobCardOperationViewModelProvider.notifier).reset();
    setState(() => _deletingPackageLineId = null);
    _showSnack(message);
  }

  void _showSnack(String message) {
    if (message.isEmpty || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _PackagesCard extends StatelessWidget {
  const _PackagesCard({
    required this.packagesAsync,
    required this.onRetry,
    this.onManageCustomPackage,
    this.onDeletePackage,
    this.deletingLineId,
    this.isDeleting = false,
  });

  final AsyncValue<List<JobCardPackageEntity>> packagesAsync;
  final VoidCallback onRetry;
  final Future<void> Function(JobCardPackageEntity)? onManageCustomPackage;
  final Future<void> Function(JobCardPackageEntity)? onDeletePackage;
  final String? deletingLineId;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: packagesAsync.when(
          data: (packages) {
            if (packages.isEmpty) {
              return _MessageWithAction(
                icon: Icons.inventory_2_outlined,
                message: 'No packages found for this job card.',
                onRetry: onRetry,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Packages applied',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...packages.map(
                  (pkg) {
                    final isBusy =
                        isDeleting &&
                        deletingLineId != null &&
                        pkg.lineId == deletingLineId;
                    final subtitleChildren = <Widget>[
                      Text('Code: ${pkg.packageCode}'),
                    ];
                    if (pkg.lineId.isNotEmpty) {
                      subtitleChildren.add(
                        Text(
                          'Line ID: ${pkg.lineId}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }
                    final hasManageAction =
                        onManageCustomPackage != null && pkg.isCustomPackage;
                    final hasDeleteAction = onDeletePackage != null;
                    if (hasManageAction || hasDeleteAction) {
                      subtitleChildren.add(
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (hasManageAction)
                                OutlinedButton.icon(
                                  onPressed:
                                      isBusy
                                          ? null
                                          : () {
                                            onManageCustomPackage?.call(pkg);
                                          },
                                  icon: const Icon(Icons.build_outlined),
                                  label: const Text('Manage'),
                                ),
                              if (hasDeleteAction)
                                TextButton.icon(
                                  onPressed:
                                      isBusy
                                          ? null
                                          : () {
                                            onDeletePackage?.call(pkg);
                                          },
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Remove'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        pkg.displayName.isNotEmpty
                            ? pkg.displayName
                            : 'Package ${pkg.packageCode}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: subtitleChildren,
                      ),
                      trailing:
                          isBusy
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                              : null,
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(minHeight: 2),
          error: (error, _) => _MessageWithAction(
            icon: Icons.error_outline,
            message: _humanizeMessage(error.toString()),
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }
}




class _MessageWithAction extends StatelessWidget {
  const _MessageWithAction({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}

String _humanizeMessage(String message) {
  if (message.toLowerCase().contains('timeout')) {
    return 'Connection timed out. Please try again.';
  }
  return message.isNotEmpty ? message : 'Something went wrong.';
}
