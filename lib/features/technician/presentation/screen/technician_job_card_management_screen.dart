import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';

import '../../domain/entity/job_card_package_entity.dart';
import '../../domain/entity/job_card_package_line_entity.dart';
import '../../provider/technician_provider.dart';
import '../view_model/job_card_operation_state.dart';
import 'technician_custom_package_screen.dart';
import '../../../../generated/l10n.dart';

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

  String? _selectedPackageId;
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
    final availablePackagesAsync = ref.watch(
      technicianJobCardPackagesProvider(widget.srNumber),
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
        title: S.of(context).jobCardTitle(widget.srNumber),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          availablePackagesAsync.when(
            data: (packages) {
              _syncSelectedPackage(packages);
              return _JobCardPackagesSection(
                srNumber: widget.srNumber,
                packages: packages,
                selectedPackageId: _selectedPackageId,
                onPackageChanged: (package) {
                  if (_selectedPackageId == package.packageId) return;
                  setState(() => _selectedPackageId = package.packageId);
                },
                onAddPackage:
                    widget.userId.isNotEmpty ? _handleAddPackage : null,
                canAddPackage: widget.userId.isNotEmpty,
                isAddInProgress: addingPackage,
                onRetry:
                    () => ref.invalidate(
                      technicianJobCardPackagesProvider(widget.srNumber),
                    ),
              );
            },
            loading:
                () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                ),
            error:
                (error, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _JobCardPackagesMessage(
                      icon: Icons.error_outline,
                      message: _humanizeMessage(context, error.toString()),
                      action: TextButton(
                        onPressed:
                            () => ref.invalidate(
                              technicianJobCardPackagesProvider(
                                widget.srNumber,
                              ),
                            ),
                        child: Text(S.of(context).retryButtonLabel),
                      ),
                    ),
                  ),
                ),
          ),
          const SizedBox(height: 16),
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




  Future<void> _handleAddPackage(JobCardPackageEntity package) async {
    final srNumber = widget.srNumber.trim();
    if (srNumber.isEmpty) {
      _showSnack(S.of(context).jobCardNumberUnavailableMessage);
      return;
    }
    if (widget.userId.isEmpty) {
      _showSnack(S.of(context).unableToDetermineTechnicianIdMessage);
      return;
    }
    await ref.read(jobCardOperationViewModelProvider.notifier).addPackage(
      srNumber: srNumber,
      packageId: package.packageId,
      userId: widget.userId,
      campaignLineId: package.campaignLineId,
    );
  }

  Future<void> _openCustomPackageManager(
    JobCardPackageEntity package,
  ) async {
    if (widget.userId.isEmpty) {
      _showSnack(S.of(context).unableToDetermineTechnicianIdMessage);
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
      _showSnack(S.of(context).waitForCurrentActionMessage);
      return;
    }
    if (widget.userId.isEmpty) {
      _showSnack(S.of(context).unableToDetermineTechnicianIdMessage);
      return;
    }
    final lineId = package.lineId.trim();
    if (lineId.isEmpty) {
      _showSnack(S.of(context).packageLineIdUnavailableMessage);
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
          title: Text(S.of(context).removePackageTitle),
          content: Text(
            S.of(context).removePackageConfirmation(packageName, widget.srNumber),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.of(context).removeButtonLabel),
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

  void _syncSelectedPackage(List<JobCardPackageEntity> packages) {
    final hasExisting =
        _selectedPackageId != null &&
        packages.any((pkg) => pkg.packageId == _selectedPackageId);
    final desiredId =
        hasExisting
            ? _selectedPackageId
            : packages.isNotEmpty
            ? packages.first.packageId
            : null;
    if (desiredId == _selectedPackageId) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _selectedPackageId = desiredId);
    });
  }

  void _showSnack(String message) {
    if (message.isEmpty || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _JobCardPackagesSection extends StatelessWidget {
  const _JobCardPackagesSection({
    required this.srNumber,
    required this.packages,
    required this.onRetry,
    required this.selectedPackageId,
    required this.onPackageChanged,
    this.onAddPackage,
    this.canAddPackage = false,
    this.isAddInProgress = false,
  });

  final String srNumber;
  final List<JobCardPackageEntity> packages;
  final VoidCallback onRetry;
  final String? selectedPackageId;
  final ValueChanged<JobCardPackageEntity> onPackageChanged;
  final ValueChanged<JobCardPackageEntity>? onAddPackage;
  final bool canAddPackage;
  final bool isAddInProgress;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en',
      symbol: 'SAR ',
      decimalDigits: 2,
    );

    JobCardPackageEntity? _findPackage(String? id) {
      if (id == null) return null;
      for (final pkg in packages) {
        if (pkg.packageId == id) return pkg;
      }
      return null;
    }

    final selected =
        _findPackage(selectedPackageId) ??
        (packages.isNotEmpty ? packages.first : null);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).jobCardPackagesTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        srNumber,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: S.of(context).refreshPackagesTooltip,
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (packages.isEmpty)
              _JobCardPackagesMessage(
                icon: Icons.inventory_2_outlined,
                message: S.of(context).noPackagesFoundForJobCardMessage,
              )
            else ...[
              DropdownButtonFormField<String>(
                value: selected?.packageId ?? packages.first.packageId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: S.of(context).selectPackageLabel,
                  border: const OutlineInputBorder(),
                ),
                items:
                    packages
                        .map(
                          (pkg) => DropdownMenuItem<String>(
                            value: pkg.packageId,
                            child: Text(
                              pkg.displayName.isNotEmpty
                                  ? pkg.displayName
                                  : S.of(context).packageCodeFallbackLabel(pkg.packageCode),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final pkg = packages.firstWhere(
                    (element) => element.packageId == value,
                  );
                  onPackageChanged(pkg);
                },
              ),
              const SizedBox(height: 16),
              if (selected != null) ...[
                _SelectedPackageDetails(
                  package: selected,
                  currencyFormat: currencyFormat,
                ),
                if (canAddPackage &&
                    onAddPackage != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed:
                          isAddInProgress ? null : () => onAddPackage?.call(selected),
                      icon:
                          isAddInProgress
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                              : const Icon(Icons.add_circle_outline),
                      label: Text(S.of(context).addPackageToJobCardButtonLabel),
                    ),
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectedPackageDetails extends StatelessWidget {
  const _SelectedPackageDetails({
    required this.package,
    required this.currencyFormat,
  });

  final JobCardPackageEntity package;
  final NumberFormat currencyFormat;

  double get _effectivePrice {
    if (package.totalPrice > 0) return package.totalPrice;
    if (package.linePrice > 0) return package.linePrice;
    if (package.totalListPrice > 0) return package.totalListPrice;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final price = _effectivePrice;
    final priceText =
        price > 0 ? currencyFormat.format(price) : S.of(context).includedLabel;
    final tags = <Widget>[];
    if (package.isEmergency) {
      tags.add(_PackageTag(label: S.of(context).emergencyTagLabel, color: const Color(0xFFB42318)));
    }
    if (package.isCustomPackage) {
      tags.add(_PackageTag(label: S.of(context).customTagLabel, color: const Color(0xFF027A48)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                package.displayName.isNotEmpty
                    ? package.displayName
                    : S.of(context).packageCodeFallbackLabel(package.packageCode),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              priceText,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          S.of(context).packageCodeLabel(package.packageCode),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4, children: tags),
        ],
        const SizedBox(height: 12),
        _PackageDetailRow(
          S.of(context).linePriceLabel,
          currencyFormat.format(package.linePrice),
        ),

      ],
    );
  }
}

class _PackageDetailRow extends StatelessWidget {
  const _PackageDetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(


                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _JobCardPackagesMessage extends StatelessWidget {
  const _JobCardPackagesMessage({
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              if (action != null) ...[const SizedBox(height: 8), action!],
            ],
          ),
        ),
      ],
    );
  }
}

class _PackageTag extends StatelessWidget {
  const _PackageTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
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
    final currencyFormat = NumberFormat.currency(
      locale: 'en',
      symbol: 'SAR ',
      decimalDigits: 2,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: packagesAsync.when(
          data: (packages) {
            if (packages.isEmpty) {
              return _MessageWithAction(
                icon: Icons.inventory_2_outlined,
                message: S.of(context).noPackagesFoundForJobCardMessage,
                onRetry: onRetry,
              );
            }
            final totalAppliedPrice = packages.fold<double>(
              0,
              (sum, pkg) => sum + _effectivePackagePrice(pkg),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).packagesAppliedTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                _AppliedPackagesTotalWidget(
                  totalPrice: totalAppliedPrice,
                  currencyFormat: currencyFormat,
                ),
                const SizedBox(height: 12),
                ...packages.map(
                  (pkg) {
                    final isBusy =
                        isDeleting &&
                        deletingLineId != null &&
                        pkg.lineId == deletingLineId;
                    final packagePrice = _effectivePackagePrice(pkg);
                    final subtitleChildren = <Widget>[
                      Text(S.of(context).packageCodeLabel(pkg.packageCode)),
                      Text(
                        packagePrice > 0
                            ? S.of(context).pricePrefixedLabel(currencyFormat.format(packagePrice))
                            : S.of(context).pricePrefixedIncludedLabel,
                      ),
                    ];
                    if (pkg.lineId.isNotEmpty) {
                      subtitleChildren.add(
                        Text(
                          S.of(context).lineIdChipLabel(pkg.lineId),
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
                                  label: Text(S.of(context).manageButtonLabel),
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
                                  label: Text(S.of(context).removeButtonLabel),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    pkg.displayName.isNotEmpty
                                        ? pkg.displayName
                                        : S.of(context).packageCodeFallbackLabel(pkg.packageCode),
                                    style: Theme.of(context).textTheme.titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (isBusy)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                else
                                  Text(
                                    packagePrice > 0
                                        ? currencyFormat.format(packagePrice)
                                        : S.of(context).includedLabel,
                                    style: Theme.of(context).textTheme.bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ...subtitleChildren,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(minHeight: 2),
          error: (error, _) => _MessageWithAction(
            icon: Icons.error_outline,
            message: _humanizeMessage(context, error.toString()),
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }
}

class _AppliedPackagesTotalWidget extends StatelessWidget {
  const _AppliedPackagesTotalWidget({
    required this.totalPrice,
    required this.currencyFormat,
  });

  final double totalPrice;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final totalText =
        totalPrice > 0 ? currencyFormat.format(totalPrice) : S.of(context).includedLabel;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            S.of(context).totalPriceLabel,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            totalText,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

double _effectivePackagePrice(JobCardPackageEntity package) {
  if (package.totalPrice > 0) return package.totalPrice;
  if (package.linePrice > 0) return package.linePrice;
  if (package.totalListPrice > 0) return package.totalListPrice;
  return 0;
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
            child: Text(S.of(context).retryButtonLabel),
          ),
        ),
      ],
    );
  }
}

String _humanizeMessage(BuildContext context, String message) {
  if (message.toLowerCase().contains('timeout')) {
    return S.of(context).connectionTimedOutMessage;
  }
  return message.isNotEmpty ? message : S.of(context).somethingWentWrong;
}
