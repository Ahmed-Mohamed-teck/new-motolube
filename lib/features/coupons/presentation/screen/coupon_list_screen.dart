import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widget/internal_app_bar.dart';
import '../../../auth/data/repository/auth_local_repository.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../provider/coupon_providers.dart';
import '../../../../legacy/coupon_header_model.dart';
import '../view_model/coupon_state.dart';

class CouponListScreen extends ConsumerStatefulWidget {
  const CouponListScreen({super.key});

  @override
  ConsumerState<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends ConsumerState<CouponListScreen> {
  bool _requestedInitialLoad = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(couponNotifierProvider);
    return Scaffold(
      appBar: InternalAppBar(
        title: 'Coupons',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(couponNotifierProvider.notifier).load(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create coupon',
            onPressed: () async {
              final created = await Navigator.of(context).push<CouponHeaderModel?>(
                MaterialPageRoute(builder: (_) => const CreateCouponScreen()),
              );
              if (created != null) {
                ref.read(couponNotifierProvider.notifier).load();
              }
            },
          ),
        ],
      ),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.of(context).push<CouponHeaderModel?>(
            MaterialPageRoute(builder: (_) => const CreateCouponScreen()),
          );
          if (created != null) {
            ref.read(couponNotifierProvider.notifier).load();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add coupon'),
      ),
    );
  }

  Widget _buildBody(CouponState state) {
    if (state is CouponInitial) {
      _triggerInitialLoad();
    }
    if (state is CouponInitial || state is CouponLoading) {
      return const _CouponListSkeleton();
    }
    if (state is CouponError) {
      return Center(child: Text(state.message));
    }
    if (state is CouponEmpty) {
      return const Center(child: Text('No coupons available.'));
    }
    if (state is CouponLoaded) {
      final coupons = state.coupons;
      return RefreshIndicator(
        onRefresh: () => ref.read(couponNotifierProvider.notifier).load(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: coupons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final c = coupons[index];
            return Card(
              child: ListTile(
                title: Text(c.companyName.isNotEmpty ? c.companyName : 'Coupon'),
                subtitle: Text('Discount: ${c.discountRate.toStringAsFixed(2)}%'),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _triggerInitialLoad() {
    if (_requestedInitialLoad) return;
    _requestedInitialLoad = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(couponNotifierProvider.notifier).load();
    });
  }
}

class _CouponListSkeleton extends StatelessWidget {
  const _CouponListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Card(
          child: ListTile(
            title: Container(
              height: 14,
              width: 180,
              color: Colors.grey.shade300,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                height: 12,
                width: 140,
                color: Colors.grey.shade300,
              ),
            ),
            trailing: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateCouponScreen extends ConsumerStatefulWidget {
  const CreateCouponScreen({super.key});

  @override
  ConsumerState<CreateCouponScreen> createState() =>
      _CreateCouponScreenState();
}

class _CreateCouponScreenState extends ConsumerState<CreateCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _discountController = TextEditingController();
  final _countController = TextEditingController();
  String? _appUserId;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _prefillOracleId();
  }

  Future<void> _prefillOracleId() async {
    try {
      final stored = await ref.read(authLocalRepositoryProvider).getStoredAuth();
      final fireBaseId = stored?.fireBaseId.trim();
      if (fireBaseId != null && fireBaseId.isNotEmpty && mounted) {
        setState(() {
          _appUserId = fireBaseId;
        });
      }
    } catch (_) {
      // ignore and keep empty
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _discountController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required bool isFrom,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromDate == null || _toDate == null) {
      setState(() => _error = 'Please select date range');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final coupon = CouponHeaderModel(
      companyName: _companyController.text.trim(),
      discountRate: double.tryParse(_discountController.text.trim()) ?? 0,
      couponCounts: int.tryParse(_countController.text.trim()) ?? 0,
      fromDate: _fromDate,
      toDate: _toDate,
      appUserId: _appUserId ?? '',
      domain: '0',
    );
    try {
      await ref.read(couponNotifierProvider.notifier).create(
            appUserId: coupon.appUserId ?? '',
            companyName: coupon.companyName,
            fromDate: coupon.fromDate!,
            toDate: coupon.toDate!,
            discountRate: coupon.discountRate,
            couponCounts: coupon.couponCounts,
            domain: '0',
          );
      if (mounted) Navigator.of(context).pop(coupon);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InternalAppBar(title: 'Create Coupon'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount %'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || double.tryParse(v) == null ? 'Enter number' : null,
              ),
              const SizedBox(height: 16,),

              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(labelText: 'Coupon count'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || int.tryParse(v) == null ? 'Enter count' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(_fromDate != null
                        ? 'From: ${_fromDate!.toLocal().toString().split(' ').first}'
                        : 'Select start date'),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(isFrom: true),
                    child: const Text('Pick'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_toDate != null
                        ? 'To: ${_toDate!.toLocal().toString().split(' ').first}'
                        : 'Select end date'),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(isFrom: false),
                    child: const Text('Pick'),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
