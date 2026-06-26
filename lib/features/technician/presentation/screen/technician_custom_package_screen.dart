import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';

import '../../domain/entity/custom_package_category_entity.dart';
import '../../domain/entity/custom_package_item_entity.dart';
import '../../domain/entity/job_card_package_entity.dart';
import '../../domain/entity/job_card_package_line_entity.dart';
import '../../provider/technician_provider.dart';
import '../view_model/job_card_operation_state.dart';
import '../../../../generated/l10n.dart';

class TechnicianCustomPackageScreen extends ConsumerStatefulWidget {
  const TechnicianCustomPackageScreen({
    super.key,
    required this.package,
    required this.jobCardNumber,
    required this.userId,
  });

  final JobCardPackageEntity package;
  final String jobCardNumber;
  final String userId;

  @override
  ConsumerState<TechnicianCustomPackageScreen> createState() =>
      _TechnicianCustomPackageScreenState();
}

class _TechnicianCustomPackageScreenState
    extends ConsumerState<TechnicianCustomPackageScreen> {
  String? _selectedCategoryId;
  String? _selectedItemId;
  String? _packageLineId;
  bool _isResolvingLineId = false;
  String? _lineIdError;
  final TextEditingController _qtyController = TextEditingController(text: '1');
  String? _deletingLineId;

  @override
  void initState() {
    super.initState();
    final initialLineId = widget.package.lineId.trim();
    if (initialLineId.isNotEmpty) {
      _packageLineId = initialLineId;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPackageLineId();
      });
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  bool _isCustomOperation(JobCardOperationType type) {
    return type == JobCardOperationType.addCustomItem ||
        type == JobCardOperationType.deleteCustomItem;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<JobCardOperationState>(
      jobCardOperationViewModelProvider,
      (previous, next) {
        if (next is JobCardOperationSuccess &&
            _isCustomOperation(next.operationType)) {
          _handleActionSuccess(next);
        } else if (next is JobCardOperationFailure &&
            _isCustomOperation(next.operationType)) {
          _handleActionFailure(next);
        }
      },
    );

    final categoriesAsync = ref.watch(customPackageCategoriesProvider);
    final itemsAsync =
        _selectedCategoryId == null
            ? null
            : ref.watch(
              customPackageItemsProvider(
                CustomPackageItemsRequest(
                  jobCardNumber: widget.jobCardNumber,
                  categoryId: _selectedCategoryId!,
                ),
              ),
            );
    final actionState = ref.watch(jobCardOperationViewModelProvider);
    final request = _linesRequest;
    final linesAsync = ref.watch(jobCardPackageLinesProvider(request));
    final isAddLoading =
        actionState is JobCardOperationLoading &&
        actionState.operationType == JobCardOperationType.addCustomItem;
    final isDeleteLoading =
        actionState is JobCardOperationLoading &&
        actionState.operationType == JobCardOperationType.deleteCustomItem;

    return Scaffold(
      appBar: InternalAppBar(
        title: S.of(context).customPackageManagerTitle,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _PackageSummaryCard(
            package: widget.package,
            jobCardNumber: widget.jobCardNumber,
          ),
          const SizedBox(height: 16),
          _PackageLinesSection(
            linesAsync: linesAsync,
            onRetry: () => ref.invalidate(
              jobCardPackageLinesProvider(request),
            ),
            onDeleteLine: _onDeleteLine,
            isDeleteLoading: isDeleteLoading,
            deletingLineId: _deletingLineId,
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).addItemsOrServicesTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_resolvedLineId.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  if (_isResolvingLineId)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (_isResolvingLineId) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _lineIdError == null
                          ? S.of(context).resolvingPackageLineIdMessage
                          : _lineIdError!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _lineIdError == null
                            ? Colors.grey.shade600
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                  if (!_isResolvingLineId)
                    IconButton(
                      tooltip: S.of(context).retryButtonLabel,
                      onPressed: _loadPackageLineId,
                      icon: const Icon(Icons.refresh),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          _buildCategoriesField(context, categoriesAsync),
          const SizedBox(height: 12),
          _buildItemsField(context, itemsAsync),
          const SizedBox(height: 12),
          TextFormField(
            controller: _qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: S.of(context).quantityLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed:
                isAddLoading || _resolvedLineId.isEmpty
                    ? null
                    : _onAddItem,
            icon: isAddLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(
              _resolvedLineId.isEmpty
                  ? S.of(context).packageLineUnavailableLabel
                  : S.of(context).addItemButtonLabel,
            ),
          ),
          if (_resolvedLineId.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                S.of(context).packageNoLineIdMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoriesField(
    BuildContext context,
    AsyncValue<List<CustomPackageCategoryEntity>> categoriesAsync,
  ) {
    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return _StatusMessage(
            message: S.of(context).noCategoriesAvailableMessage,
            icon: Icons.category_outlined,
            onRetry: () =>
                ref.invalidate(customPackageCategoriesProvider),
          );
        }
        final categoryItems = categories
            .map(
              (category) => DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.displayName.isNotEmpty
                    ? category.displayName
                    : category.id),
              ),
            )
            .toList();
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          decoration: InputDecoration(
            labelText: S.of(context).categoryLabel,
            suffixIcon: IconButton(
              tooltip: S.of(context).refreshCategoriesTooltip,
              onPressed: () =>
                  ref.invalidate(customPackageCategoriesProvider),
              icon: const Icon(Icons.refresh),
            ),
            border: const OutlineInputBorder(),
          ),
          items: categoryItems,
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
              _selectedItemId = null;
            });
            if (value != null) {
              ref.invalidate(
                customPackageItemsProvider(
                  CustomPackageItemsRequest(
                    jobCardNumber: widget.jobCardNumber,
                    categoryId: value,
                  ),
                ),
              );
            }
          },
        );
      },
      loading:
          () => const LinearProgressIndicator(minHeight: 2),
      error:
          (error, _) => _StatusMessage(
            message: _humanizeMessage(error.toString()),
            icon: Icons.error_outline,
            onRetry: () =>
                ref.invalidate(customPackageCategoriesProvider),
          ),
    );
  }

  Widget _buildItemsField(
    BuildContext context,
    AsyncValue<List<CustomPackageItemEntity>>? itemsAsync,
  ) {
    if (_selectedCategoryId == null) {
      return Text(
        S.of(context).selectCategoryToLoadItemsMessage,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey.shade600,
        ),
      );
    }
    if (itemsAsync == null) {
      return const LinearProgressIndicator(minHeight: 2);
    }
    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return _StatusMessage(
            message: S.of(context).noItemsForCategoryMessage,
            icon: Icons.inventory_2_outlined,
            onRetry: () =>
                ref.invalidate(
                  customPackageItemsProvider(
                    CustomPackageItemsRequest(
                      jobCardNumber: widget.jobCardNumber,
                      categoryId: _selectedCategoryId!,
                    ),
                  ),
                ),
          );
        }
        return DropdownButtonFormField<String>(
          value: _selectedItemId,
          decoration: InputDecoration(
            labelText: S.of(context).itemsCountLabel(items.length),
            border: const OutlineInputBorder(),
          ),
          isExpanded: true,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.inventoryItemId,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemCode,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (item.description.trim().isNotEmpty)
                            Text(
                              item.description,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedItemId = value;
            });
          },
        );
      },
      loading:
          () => const LinearProgressIndicator(minHeight: 2),
      error:
          (error, _) => _StatusMessage(
            message: _humanizeMessage(error.toString()),
            icon: Icons.error_outline,
            onRetry: () =>
                ref.invalidate(
                  customPackageItemsProvider(
                    CustomPackageItemsRequest(
                      jobCardNumber: widget.jobCardNumber,
                      categoryId: _selectedCategoryId!,
                    ),
                  ),
                ),
          ),
    );
  }

  Future<void> _onAddItem() async {
    final categoryId = _selectedCategoryId;
    final itemId = _selectedItemId;
    final qtyText = _qtyController.text.trim();
    if (categoryId == null || categoryId.isEmpty) {
      _showSnack(S.of(context).pleaseSelectCategoryMessage);
      return;
    }
    if (itemId == null || itemId.isEmpty) {
      _showSnack(S.of(context).pleaseSelectItemToAddMessage);
      return;
    }
    if (qtyText.isEmpty) {
      _showSnack(S.of(context).enterQuantityMessage);
      return;
    }
    final qtyValue = double.tryParse(qtyText);
    if (qtyValue == null || qtyValue <= 0) {
      _showSnack(S.of(context).quantityMustBeGreaterThanZeroMessage);
      return;
    }
    final lineId = _resolvedLineId;
    if (lineId.isEmpty) {
      _showSnack(S.of(context).packageLineIdUnavailableMessage);
      return;
    }
    FocusScope.of(context).unfocus();
    await ref
        .read(jobCardOperationViewModelProvider.notifier)
        .addItem(
          jobCardNumber: widget.jobCardNumber,
          lineId: lineId,
          categoryId: categoryId,
          inventoryItemId: itemId,
          qty: qtyValue.toString(),
          userId: widget.userId,
        );
  }

  Future<void> _onDeleteLine(JobCardPackageLineEntity line) async {
    if (_deletingLineId != null) {
      _showSnack(S.of(context).waitForCurrentDeleteActionMessage);
      return;
    }
    final srLineId = line.srLineId.trim().isNotEmpty
        ? line.srLineId.trim()
        : line.lineId.trim().isNotEmpty
            ? line.lineId.trim()
            : line.packageLineId.trim();
    if (srLineId.isEmpty) {
      _showSnack(S.of(context).lineIdentifierUnavailableMessage);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).removeItemTitle),
          content: Text(
            S.of(context).deleteItemConfirmation(
              line.itemDescription.isNotEmpty ? line.itemDescription : line.itemCode,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.of(context).deleteButtonLabel),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    setState(() => _deletingLineId = srLineId);
    FocusScope.of(context).unfocus();
    await ref
        .read(jobCardOperationViewModelProvider.notifier)
        .deleteItem(srLineId: srLineId);
  }

  void _handleActionSuccess(JobCardOperationSuccess state) {
    if (!mounted) return;
    ref
        .read(jobCardOperationViewModelProvider.notifier)
        .reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message)),
    );
    if (state.operationType == JobCardOperationType.addCustomItem) {
      setState(() {
        _selectedItemId = null;
        _qtyController.text = '1';
      });
    } else if (state.operationType == JobCardOperationType.deleteCustomItem) {
      setState(() => _deletingLineId = null);
    }
    ref.invalidate(
      technicianJobCardPackagesProvider(widget.jobCardNumber),
    );
    ref.invalidate(jobCardPackageLinesProvider(_linesRequest));
  }

  void _handleActionFailure(JobCardOperationFailure state) {
    if (!mounted) return;
    ref
        .read(jobCardOperationViewModelProvider.notifier)
        .reset();
    setState(() => _deletingLineId = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message)),
    );
  }

  Future<void> _loadPackageLineId() async {
    if (_isResolvingLineId) return;
    setState(() {
      _isResolvingLineId = true;
      _lineIdError = null;
    });
    try {
      final lines = await ref.read(getJobCardPackageLinesUseCaseProvider)(
        srNumber: widget.jobCardNumber,
        packageId: widget.package.packageId,
      );
      String? resolved;
      for (final line in lines) {
        final candidate =
            line.lineId.trim().isNotEmpty
                ? line.lineId.trim()
                : line.packageLineId.trim();
        if (candidate.isNotEmpty) {
          resolved = candidate;
          break;
        }
      }
      if (!mounted) return;
      if (resolved != null) {
        setState(() => _packageLineId = resolved);
      } else {
        setState(() {
          _lineIdError = S.of(context).unableToResolvePackageLineIdMessage;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _lineIdError = _humanizeMessage(error.toString()));
    } finally {
      if (mounted) {
        setState(() => _isResolvingLineId = false);
      }
    }
  }

  String get _resolvedLineId =>
      (_packageLineId ?? widget.package.lineId).trim();

  JobCardPackageLinesRequest get _linesRequest =>
      JobCardPackageLinesRequest(
        srNumber: widget.jobCardNumber,
        packageId: widget.package.packageId,
      );

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _humanizeMessage(String message) {
    if (message.toLowerCase().contains('timeout')) {
      return S.of(context).connectionTimedOutMessage;
    }
    return message.isNotEmpty ? message : S.of(context).somethingWentWrong;
  }
}

class _PackageSummaryCard extends StatelessWidget {
  const _PackageSummaryCard({
    required this.package,
    required this.jobCardNumber,
  });

  final JobCardPackageEntity package;
  final String jobCardNumber;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.displayName.isNotEmpty
                  ? package.displayName
                  : S.of(context).packageCodeFallbackLabel(package.packageCode),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              S.of(context).jobCardNumberLabel(jobCardNumber),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Chip(label: package.isCustomPackage ? S.of(context).customTagLabel : S.of(context).standardTagLabel),
                const SizedBox(width: 8),
                _Chip(label: S.of(context).lineIdChipLabel(package.lineId.isNotEmpty ? package.lineId : S.of(context).notApplicableAbbreviation)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageLinesSection extends StatelessWidget {
  const _PackageLinesSection({
    required this.linesAsync,
    required this.onRetry,
    required this.onDeleteLine,
    required this.isDeleteLoading,
    required this.deletingLineId,
  });

  final AsyncValue<List<JobCardPackageLineEntity>> linesAsync;
  final VoidCallback onRetry;
  final Future<void> Function(JobCardPackageLineEntity) onDeleteLine;
  final bool isDeleteLoading;
  final String? deletingLineId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    S.of(context).packageItemsTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: S.of(context).refreshTooltip,
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            linesAsync.when(
              data: (lines) {
                if (lines.isEmpty) {
                  return _StatusMessage(
                    message: S.of(context).noLineItemsFoundMessage,
                    icon: Icons.inventory_2_outlined,
                    onRetry: onRetry,
                  );
                }
                return Column(
                  children:
                      lines
                          .map(
                            (line) {
                              final srLine =
                                  line.srLineId.trim().isNotEmpty
                                      ? line.srLineId.trim()
                                      : line.lineId.trim().isNotEmpty
                                          ? line.lineId.trim()
                                          : line.packageLineId.trim();
                              final isDeleting =
                                  isDeleteLoading &&
                                  deletingLineId != null &&
                                  srLine == deletingLineId;
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  line.itemCode.isNotEmpty
                                      ? line.itemCode
                                      : S.of(context).lineNumberFallbackLabel(line.lineNumber),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(line.itemDescription),
                                    if (srLine.isNotEmpty)
                                      Text(
                                        S.of(context).srLineIdLabel(srLine),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(S.of(context).quantityValueLabel(line.quantity)),
                                    const SizedBox(height: 6),
                                    IconButton(
                                      tooltip: S.of(context).deleteItemTooltip,
                                      onPressed:
                                          isDeleting
                                              ? null
                                              : () => onDeleteLine(line),
                                      icon:
                                          isDeleting
                                              ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                              : const Icon(Icons.delete_outline),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                          .toList(),
                );
              },
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (error, _) => _StatusMessage(
                message: error.toString(),
                icon: Icons.error_outline,
                onRetry: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.message,
    required this.icon,
    this.onRetry,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              if (onRetry != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: onRetry,
                    child: Text(S.of(context).retryButtonLabel),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
