import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';

import '../../domain/entity/custom_package_category_entity.dart';
import '../../domain/entity/custom_package_item_entity.dart';
import '../../domain/entity/job_card_package_entity.dart';
import '../../domain/entity/job_card_package_line_entity.dart';
import '../../provider/technician_provider.dart';
import '../view_model/job_card_operation_state.dart';

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
      appBar: const InternalAppBar(
        title: 'Custom Package Manager',
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
            'Add items or services',
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
                          ? 'Resolving package line ID...'
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
                      tooltip: 'Retry',
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
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
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
                  ? 'Package line is unavailable'
                  : 'Add item',
            ),
          ),
          if (_resolvedLineId.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'This package does not expose a line ID. Unable to add items.',
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
            message: 'No categories available.',
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
            labelText: 'Category',
            suffixIcon: IconButton(
              tooltip: 'Refresh categories',
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
        'Select a category to load items.',
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
            message: 'No items available for the selected category.',
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
            labelText: 'Items (${items.length})',
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
      _showSnack('Please select a category.');
      return;
    }
    if (itemId == null || itemId.isEmpty) {
      _showSnack('Please select an item to add.');
      return;
    }
    if (qtyText.isEmpty) {
      _showSnack('Enter a quantity.');
      return;
    }
    final qtyValue = double.tryParse(qtyText);
    if (qtyValue == null || qtyValue <= 0) {
      _showSnack('Quantity must be greater than zero.');
      return;
    }
    final lineId = _resolvedLineId;
    if (lineId.isEmpty) {
      _showSnack('Package line ID is unavailable.');
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
      _showSnack('Please wait for the current delete action to finish.');
      return;
    }
    final srLineId = line.srLineId.trim().isNotEmpty
        ? line.srLineId.trim()
        : line.lineId.trim().isNotEmpty
            ? line.lineId.trim()
            : line.packageLineId.trim();
    if (srLineId.isEmpty) {
      _showSnack('Line identifier unavailable for this item.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove item'),
          content: Text(
            'Delete "${line.itemDescription.isNotEmpty ? line.itemDescription : line.itemCode}" from this package?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
          _lineIdError = 'Unable to resolve package line ID.';
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
      return 'Connection timed out. Please try again.';
    }
    return message.isNotEmpty ? message : 'Something went wrong.';
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
                  : 'Package ${package.packageCode}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Job card: $jobCardNumber',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Chip(label: package.isCustomPackage ? 'Custom' : 'Standard'),
                const SizedBox(width: 8),
                _Chip(label: 'Line: ${package.lineId.isNotEmpty ? package.lineId : 'N/A'}'),
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
                    'Package items',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh',
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
                    message: 'No line items found for this package.',
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
                                      : 'Line ${line.lineNumber}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(line.itemDescription),
                                    if (srLine.isNotEmpty)
                                      Text(
                                        'SR Line ID: $srLine',
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
                                    Text('Qty: ${line.quantity}'),
                                    const SizedBox(height: 6),
                                    IconButton(
                                      tooltip: 'Delete item',
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
                    child: const Text('Retry'),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
