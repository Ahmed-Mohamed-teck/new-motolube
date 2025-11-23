import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';

import '../../../auth/provider/auth_provider.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../domain/entity/booking_status.dart';
import '../../domain/entity/job_card_package_entity.dart';
import '../../domain/entity/technician_appointment_entity.dart';
import '../../domain/utils/job_card_utils.dart';
import '../../provider/technician_provider.dart';
import '../view_model/job_card_operation_state.dart';
import '../view_model/technician_appointment_update_state.dart';
import 'technician_checklist_screen.dart';
import 'technician_job_card_management_screen.dart';

class TechnicianAppointmentDetailsScreen extends ConsumerStatefulWidget {
  const TechnicianAppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  final TechnicianAppointmentEntity appointment;

  @override
  ConsumerState<TechnicianAppointmentDetailsScreen> createState() =>
      _TechnicianAppointmentDetailsScreenState();
}

class _TechnicianAppointmentDetailsScreenState
    extends ConsumerState<TechnicianAppointmentDetailsScreen> {
  late int _selectedStatusId;
  late int _initialStatusId;
  bool _hasUpdates = false;
  bool _isCreatingSr = false;
  bool _isCompletingSr = false;
  int? _pendingStatusId;
  String _srNumber = '';
  String? _selectedPackageId;

  @override
  void initState() {
    super.initState();
    final initialId =
        int.tryParse(widget.appointment.bookingStatus.code) ??
        TechnicianHomeScreenDefaults.statusId;
    _initialStatusId = initialId;
    _selectedStatusId = initialId;
    _srNumber =
        _sanitizeSrNumber(widget.appointment.srNumber) ??
        _extractSrFromRaw(widget.appointment.raw) ??
        '';
  }

  @override
  void didUpdateWidget(covariant TechnicianAppointmentDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final latest =
        _sanitizeSrNumber(widget.appointment.srNumber) ??
        _extractSrFromRaw(widget.appointment.raw);
    if (latest != null && latest != _srNumber) {
      setState(() {
        _srNumber = latest;
        _selectedPackageId = null;
      });
      ref.invalidate(technicianJobCardPackagesProvider(latest));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TechnicianAppointmentUpdateState>(
      technicianAppointmentUpdateViewModelProvider,
      (previous, next) {
        if (next is TechnicianAppointmentUpdateSuccess) {
          if (!mounted) return;
          setState(() {
            if (_pendingStatusId != null) {
              _selectedStatusId = _pendingStatusId!;
              _initialStatusId = _pendingStatusId!;
              _pendingStatusId = null;
            }
            _hasUpdates = true;
          });
          _showSnack('Status updated successfully.');
          ref
              .read(technicianAppointmentUpdateViewModelProvider.notifier)
              .reset();
        } else if (next is TechnicianAppointmentUpdateError) {
          if (!mounted) return;
          setState(() {
            _pendingStatusId = null;
          });
          _showSnack(_humanizeMessage(next.message));
          ref
              .read(technicianAppointmentUpdateViewModelProvider.notifier)
              .reset();
        }
      },
    );
    ref.listen<JobCardOperationState>(
      jobCardOperationViewModelProvider,
      (previous, next) {
        if (next is JobCardOperationSuccess &&
            next.operationType == JobCardOperationType.addPackage) {
          if (!mounted) return;
          _showSnack(next.message);
          final sr = _sanitizeSrNumber();
          if (sr != null && sr.isNotEmpty) {
            ref.invalidate(technicianJobCardPackagesProvider(sr));
          }
          ref.read(jobCardOperationViewModelProvider.notifier).reset();
        } else if (next is JobCardOperationFailure &&
            next.operationType == JobCardOperationType.addPackage) {
          if (!mounted) return;
          _showSnack(_humanizeMessage(next.message));
          ref.read(jobCardOperationViewModelProvider.notifier).reset();
        }
      },
    );

    final updateState = ref.watch(technicianAppointmentUpdateViewModelProvider);
    final isUpdating = updateState is TechnicianAppointmentUpdateLoading;
    final statusesAsync = ref.watch(technicianBookingStatusesProvider);
    final statuses = statusesAsync.maybeWhen(
      data: (value) => value,
      orElse: () => const <TechnicianBookingStatus>[],
    );
    final statusesError = statusesAsync.whenOrNull(
      error: (error, _) => error.toString(),
    );
    final statusesLoading = statusesAsync.isLoading;
    final isProcessing = isUpdating || _isCreatingSr || _isCompletingSr;
    final srNumber = _sanitizeSrNumber();
    final hasOpenJobCard = _hasOpenJobCard;
    final shouldFetchPackages = srNumber != null;
    final packagesAsync =
        shouldFetchPackages
            ? ref.watch(technicianJobCardPackagesProvider(srNumber!))
            : null;
    final jobCardOperationState = ref.watch(jobCardOperationViewModelProvider);
    final isAddingPackage =
        jobCardOperationState is JobCardOperationLoading &&
        jobCardOperationState.operationType == JobCardOperationType.addPackage;

    List<TechnicianBookingStatus> orderedStatuses = statuses;
    if (statuses.isNotEmpty) {
      orderedStatuses = [...statuses]
        ..sort((a, b) => _parseStatusId(a).compareTo(_parseStatusId(b)));
      final resolvedIndex = _resolveCurrentStatusIndex(orderedStatuses) ?? 0;
      final resolvedId = _statusIdAtIndex(orderedStatuses, resolvedIndex);
      if (resolvedId != _selectedStatusId &&
          !isProcessing &&
          _pendingStatusId == null &&
          mounted &&
          statusesError == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _selectedStatusId = resolvedId;
          });
        });
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_hasUpdates);
        return false;
      },
      child: Scaffold(
        appBar: InternalAppBar(
          title: 'Appointment Details',
          onBack: () => Navigator.of(context).pop(_hasUpdates),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _HeaderCard(appointment: widget.appointment),
            const SizedBox(height: 12),
            _InfoCard(appointment: widget.appointment),
            const SizedBox(height: 12),
            if (!shouldFetchPackages)
              _JobCardPackagesPlaceholder(
                isCreatingSr: _isCreatingSr,
                hasOpenJobCard: hasOpenJobCard,
              )
            else if (packagesAsync != null)
              packagesAsync.when(
                data: (packages) {
                  _syncSelectedPackage(packages);
                  return Column(
                    children: [
                      _JobCardPackagesSection(
                        srNumber: srNumber!,
                        packages: packages,
                        selectedPackageId: _selectedPackageId,
                        onPackageChanged: (package) {
                          if (_selectedPackageId == package.packageId) return;
                          setState(() => _selectedPackageId = package.packageId);
                        },
                        onAddPackage: _canManageJobCard ? _handleAddPackage : null,
                        isAddInProgress: isAddingPackage,
                        canAddPackage: _canManageJobCard,
                        onRetry:
                            () => ref.invalidate(
                              technicianJobCardPackagesProvider(srNumber),
                            ),
                      ),
                      if (_canManageJobCard) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _openChecklistScreen,
                                icon: const Icon(Icons.checklist),
                                label: const Text('Vehicle checklist'),
                              ),
                              TextButton.icon(
                                onPressed: _openJobCardManagementScreen,
                                icon: const Icon(Icons.admin_panel_settings_outlined),
                                label: const Text('Manage packages'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
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
                          message: _humanizeMessage(error.toString()),
                          action: TextButton(
                            onPressed:
                                () => ref.invalidate(
                                  technicianJobCardPackagesProvider(srNumber),
                                ),
                            child: const Text('Retry'),
                          ),
                        ),
                      ),
                    ),
              ),
            const SizedBox(height: 12),
            if (statusesLoading)
              const _StatusHelperCard.loading()
            else if (statusesError != null)
              _StatusHelperCard.error(
                message: _humanizeMessage(statusesError),
                onRetry:
                    () => ref.invalidate(technicianBookingStatusesProvider),
              )
            else if (statuses.isEmpty)
              const _StatusHelperCard.error(
                message: 'No booking statuses available.',
              )
            else
              _buildStatusFlow(
                context,
                orderedStatuses,
                isProcessing,
                _resolveCurrentStatusId(orderedStatuses),
              ),
            if (isProcessing)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddPackage(JobCardPackageEntity package) async {
    final srNumber = _sanitizeSrNumber();
    if (srNumber == null || srNumber.isEmpty) {
      _showSnack('Job card number unavailable.');
      return;
    }
    final userId = await _fetchFirebaseId();
    if (userId.isEmpty) {
      _showSnack('Unable to determine technician identifier.');
      return;
    }
    await ref.read(jobCardOperationViewModelProvider.notifier).addPackage(
      srNumber: srNumber,
      packageId: package.packageId,
      userId: userId,
      campaignLineId: package.campaignLineId,
    );
  }

  Future<void> _openJobCardManagementScreen() async {
    final srNumber = _sanitizeSrNumber();
    if (srNumber == null || srNumber.isEmpty) {
      _showSnack('Job card number unavailable.');
      return;
    }
    final userId = await _fetchFirebaseId();
    if (userId.isEmpty) {
      _showSnack('Unable to determine technician identifier.');
      return;
    }
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder:
            (context) => TechnicianJobCardManagementScreen(
              srNumber: srNumber,
              userId: userId,
            ),
      ),
    );
  }

  Future<void> _openChecklistScreen() async {
    final srNumber = _sanitizeSrNumber();
    if (srNumber == null || srNumber.isEmpty) {
      _showSnack('Job card number unavailable.');
      return;
    }
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder:
            (context) => TechnicianChecklistScreen(
              appointment: widget.appointment,
            ),
      ),
    );
  }

  Future<String> _fetchFirebaseId() async {
    final authState = ref.read(authViewModelProvider);
    if (authState is AuthenticatedState) {
      final firebaseId = authState.user.fireBaseId.trim();
      if (firebaseId.isNotEmpty) return firebaseId;
    }
    final authRepo = ref.read(authLocalRepositoryProvider);
    final stored = await authRepo.getStoredAuth();
    if (stored != null && stored.fireBaseId.trim().isNotEmpty) {
      return stored.fireBaseId.trim();
    }
    return '';
  }

  String _resolveUserId() {
    final authState = ref.read(authViewModelProvider);
    if (authState is AuthenticatedState) {
      final firebaseId = authState.user.fireBaseId.trim();
      if (firebaseId.isNotEmpty) return firebaseId;
      final oracleId = authState.user.oracleId.trim();
      if (oracleId.isNotEmpty) return oracleId;
    }
    return '';
  }


  bool get _canManageJobCard {
    final sr = _sanitizeSrNumber();
    if (sr == null || sr.isEmpty) return false;
    final userId = _resolveUserId();
    return userId.isNotEmpty;
  }

  Future<void> _submit(int statusId) async {
    await ref
        .read(technicianAppointmentUpdateViewModelProvider.notifier)
        .update(
          bookingId: widget.appointment.bookingId,
          statusId: statusId.toString(),
        );
  }

  Future<void> _handleStatusTap(
    TechnicianBookingStatus status,
    List<TechnicianBookingStatus> statuses,
  ) async {
    final statusId = int.tryParse(status.code);
    if (statusId == null) return;
    final currentStatusId = _resolveCurrentStatusId(statuses);
    final currentIndex = _resolveCurrentStatusIndex(statuses) ?? 0;
    if (statusId <= currentStatusId || _isCreatingSr) {
      if (statusId == currentStatusId) {
        _showSnack('Already on ${status.label}.');
      }
      return;
    }

    final targetIndex =
        _statusIndex(statuses, statusId) ??
        _statusIndexByLabel(statuses, status.label);
    if (targetIndex == null || targetIndex <= currentIndex) {
      return;
    }

    if (_requiresJobCard(status)) {
      final created = await _createServiceRequest();
      if (!created) {
        return;
      }
    }

    if (_isCompleteJobCardStatus(status)) {
      final completed = await _completeServiceRequest();
      if (!completed) {
        return;
      }
    }

    _pendingStatusId = statusId;
    await _submit(statusId);
  }

  bool _requiresJobCard(TechnicianBookingStatus status) {
    final label = status.label.toLowerCase();
    if (label.contains('openjobcard') || label.contains('open job card')) {
      return true;
    }
    return status.code == '6';
  }

  bool _isCompleteJobCardStatus(TechnicianBookingStatus status) {
    final normalized = _normalizeStatusLabel(status.label);
    if (normalized.contains('completejobcard') ||
        normalized.contains('closejobcard')) {
      return true;
    }
    return status.code.trim() == '7';
  }

  bool get _hasOpenJobCard {
    final srStatus = widget.appointment.srStatus.trim().toLowerCase();
    if (srStatus.contains('open')) return true;
    final normalizedSrStatus = _normalizeStatusLabel(
      widget.appointment.srStatus,
    );
    if (normalizedSrStatus.contains('openjobcard')) return true;
    final bookingStatusLabel =
        widget.appointment.statusLabel.trim().toLowerCase();
    if (bookingStatusLabel.contains('open job card') ||
        bookingStatusLabel.contains('openjobcard')) {
      return true;
    }
    final normalizedBookingLabel = _normalizeStatusLabel(
      widget.appointment.statusLabel,
    );
    if (normalizedBookingLabel.contains('openjobcard')) return true;
    final statusId = _parseStatusId(widget.appointment.bookingStatus);
    return statusId == 6;
  }

  String? _sanitizeSrNumber([String? value]) {
    return sanitizeJobCardId(value ?? _srNumber);
  }

  String? _extractSrFromRaw(Map<String, dynamic> raw) {
    if (raw.isEmpty) return null;
    return findJobCardId(raw);
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

  int? _statusIndex(List<TechnicianBookingStatus> statuses, int statusId) {
    for (var i = 0; i < statuses.length; i++) {
      if (int.tryParse(statuses[i].code) == statusId) {
        return i;
      }
    }
    return null;
  }

  int? _statusIndexByLabel(
    List<TechnicianBookingStatus> statuses,
    String label,
  ) {
    final normalized = _normalizeStatusLabel(label);
    if (normalized.isEmpty) return null;
    for (var i = 0; i < statuses.length; i++) {
      if (_normalizeStatusLabel(statuses[i].label) == normalized) {
        return i;
      }
    }
    return null;
  }

  int? _resolveCurrentStatusIndex(List<TechnicianBookingStatus> statuses) {
    final byLabel = _statusIndexByLabel(
      statuses,
      widget.appointment.statusLabel,
    );
    if (byLabel != null) return byLabel;
    return _statusIndex(statuses, _initialStatusId);
  }

  int _statusIdAtIndex(List<TechnicianBookingStatus> statuses, int index) {
    if (index < 0 || index >= statuses.length) {
      return _initialStatusId;
    }
    return _parseStatusId(statuses[index]);
  }

  int _resolveCurrentStatusId(List<TechnicianBookingStatus> statuses) {
    final index = _resolveCurrentStatusIndex(statuses);
    if (index != null) {
      return _statusIdAtIndex(statuses, index);
    }
    return _initialStatusId;
  }

  String _normalizeStatusLabel(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  int _parseStatusId(TechnicianBookingStatus status) {
    return int.tryParse(status.code) ?? TechnicianHomeScreenDefaults.statusId;
  }

  Future<bool> _createServiceRequest() async {
    setState(() => _isCreatingSr = true);
    try {
      final authRepo = ref.read(authLocalRepositoryProvider);
      final stored = await authRepo.getStoredAuth();
      if (stored == null || stored.fireBaseId.isEmpty) {
        _showSnack('Missing FireBaseId for technician.');
        return false;
      }
      final useCase = ref.read(createJobCardUseCaseProvider);
      final vin =
          widget.appointment.vin.isNotEmpty ? widget.appointment.vin : 'NA';
      final mileage =
          widget.appointment.mileage.isNotEmpty
              ? widget.appointment.mileage
              : '0';
      final coupon =
          widget.appointment.couponNumber.isNotEmpty
              ? widget.appointment.couponNumber
              : 'NA';
      final isEstimation = widget.appointment.isEstimation ? 'Y' : 'N';
      final results = await useCase(
        fireBaseId: stored.fireBaseId,
        phoneNumber: stored.phoneNumber.isNotEmpty ? stored.phoneNumber : 'NA',
        vin: vin,
        mileage: mileage,
        couponNumber: coupon,
        isEstimation: isEstimation,
        bookingId: widget.appointment.bookingId,
      );
      if (results.isNotEmpty) {
        final createdSr = results.first.srNumber;
        final normalized = sanitizeJobCardId(createdSr);
        if (normalized != null && mounted) {
          setState(() => _srNumber = normalized);
          ref.invalidate(technicianJobCardPackagesProvider(normalized));
        }
        _showSnack('Job card ${results.first.srNumber} created.');
      } else {
        _showSnack('Service request created.');
      }
      return true;
    } catch (error) {
      _showSnack(_humanizeMessage(error.toString()));
      return false;
    } finally {
      if (mounted) {
        setState(() => _isCreatingSr = false);
      }
    }
  }

  Future<bool> _completeServiceRequest() async {
    final sr = _sanitizeSrNumber();
    if (sr == null || sr.isEmpty) {
      _showSnack('Job card number is missing.');
      return false;
    }
    final userId = await _fetchFirebaseId();
    if (userId.isEmpty) {
      _showSnack('User identifier is missing.');
      return false;
    }
    setState(() => _isCompletingSr = true);
    try {
      final results = await ref.read(completeServiceRequestUseCaseProvider)(
        srNumber: sr,
        userId: userId,
      );
      if (results.isNotEmpty) {
        final normalized = sanitizeJobCardId(results.first.srNumber);
        if (normalized != null && mounted) {
          setState(() => _srNumber = normalized);
        }
      }
      _showSnack('Job card completed successfully.');
      return true;
    } catch (error) {
      _showSnack(_humanizeMessage(error.toString()));
      return false;
    } finally {
      if (mounted) {
        setState(() => _isCompletingSr = false);
      }
    }
  }

  void _showSnack(String message) {
    if (message.isEmpty) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _humanizeMessage(String message) {
    if (message.toLowerCase().contains('timeout')) {
      return 'Connection timed out. Please try again.';
    }
    return message.isNotEmpty ? message : 'Something went wrong.';
  }

  Widget _buildStatusFlow(
    BuildContext context,
    List<TechnicianBookingStatus> statuses,
    bool isProcessing,
    int currentStatusId,
  ) {
    final currentIndex = _resolveCurrentStatusIndex(statuses) ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                for (var i = 0; i < statuses.length; i++)
                  _buildStatusChip(
                    context: context,
                    status: statuses[i],
                    index: i,
                    currentIndex: currentIndex,
                    currentStatusId: currentStatusId,
                    isProcessing: isProcessing,
                    onTap: () => _handleStatusTap(statuses[i], statuses),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip({
    required BuildContext context,
    required TechnicianBookingStatus status,
    required int index,
    required int currentIndex,
    required int currentStatusId,
    required bool isProcessing,
    required VoidCallback onTap,
  }) {
    final statusId = int.tryParse(status.code);
    if (statusId == null) {
      return const SizedBox.shrink();
    }
    final isPast = index < currentIndex;
    final isCurrent = index == currentIndex;
    final isFuture = index > currentIndex;
    final isSelected = statusId == _selectedStatusId;
    final color =
        status.colorValue != null
            ? Color(status.colorValue!)
            : Theme.of(context).colorScheme.primary;
    final enabled = isFuture && !isProcessing;
    final background =
        isSelected
            ? color.withOpacity(0.18)
            : isFuture
            ? Colors.white
            : const Color(0xFFF2F4F7);
    final borderColor =
        isSelected
            ? color
            : isPast
            ? Colors.grey.shade300
            : color.withOpacity(0.45);

    return ChoiceChip(
      label: Text(
        status.label.isNotEmpty ? status.label : 'Status ${status.code}',
      ),
      selected: isSelected,
      onSelected: enabled ? (_) => onTap() : null,
      selectedColor: color.withOpacity(0.2),
      backgroundColor: background,
      side: BorderSide(color: borderColor),
      labelStyle: TextStyle(
        color:
            isSelected
                ? color
                : isPast
                ? Colors.grey.shade500
                : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      avatar:
          isPast
              ? const Icon(Icons.check_circle, size: 16, color: Colors.green)
              : isCurrent
              ? Icon(Icons.flag, size: 16, color: color)
              : null,
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.appointment});

  final TechnicianAppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final initials =
        appointment.customerName.trim().isNotEmpty
            ? appointment.customerName
                .trim()
                .split(' ')
                .map((w) => w.isNotEmpty ? w[0] : '')
                .take(2)
                .join()
                .toUpperCase()
            : 'ML';
    final statusColor =
        appointment.statusColorValue != null
            ? Color(appointment.statusColorValue!)
            : Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: statusColor.withOpacity(0.15),
              child: Text(
                initials,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.customerName.isNotEmpty
                        ? appointment.customerName
                        : 'Customer',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.packageLabel.isNotEmpty
                        ? appointment.packageLabel
                        : 'Maintenance package',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      appointment.statusLabel.isNotEmpty
                          ? appointment.statusLabel
                          : 'Status',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.appointment});

  final TechnicianAppointmentEntity appointment;

  String _formatDate(TechnicianAppointmentEntity appointment) {
    if (appointment.bookingDate != null) {
      return DateFormat('EEE, dd MMM yyyy').format(appointment.bookingDate!);
    }
    if (appointment.bookingDateText.isNotEmpty) {
      return appointment.bookingDateText;
    }
    return '--';
  }

  @override
  Widget build(BuildContext context) {
    final rows = <_DetailRowData>[
      _DetailRowData(
        'Branch',
        appointment.branchName.isNotEmpty
            ? appointment.branchName
            : 'Not assigned',
      ),
      _DetailRowData(
        'Vehicle',
        appointment.displayCar.isNotEmpty
            ? appointment.displayCar
            : 'Vehicle not set',
      ),
      _DetailRowData(
        'Plate',
        appointment.displayPlate.isNotEmpty
            ? appointment.displayPlate
            : 'Unavailable',
      ),
      _DetailRowData(
        'Schedule',
        '${_formatDate(appointment)}'
            '${appointment.slotTime.isNotEmpty ? ' · ${appointment.slotTime}' : ''}',
      ),
      _DetailRowData(
        'VIN',
        appointment.vin.isNotEmpty ? appointment.vin : '--',
      ),
      _DetailRowData(
        'Technician',
        appointment.technicianNameEn.isNotEmpty
            ? appointment.technicianNameEn
            : appointment.technicianNameAr.isNotEmpty
            ? appointment.technicianNameAr
            : '--',
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              rows
                  .map(
                    (row) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              row.label,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              row.value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _JobCardPackagesPlaceholder extends StatelessWidget {
  const _JobCardPackagesPlaceholder({
    required this.isCreatingSr,
    required this.hasOpenJobCard,
  });

  final bool isCreatingSr;
  final bool hasOpenJobCard;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        hasOpenJobCard
            ? 'Job card is open, loading package details...'
            : isCreatingSr
            ? 'Creating job card... packages will appear shortly.'
            : 'Open a job card to view its associated packages.';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job card packages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
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
                        'Job card packages',
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
                  tooltip: 'Refresh packages',
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (packages.isEmpty)
              _JobCardPackagesMessage(
                icon: Icons.inventory_2_outlined,
                message: 'No packages found for this job card.',
              )
            else ...[
              DropdownButtonFormField<String>(
                value: selected?.packageId ?? packages.first.packageId,
                decoration: const InputDecoration(
                  labelText: 'Select package',
                  border: OutlineInputBorder(),
                ),
                items:
                    packages
                        .map(
                          (pkg) => DropdownMenuItem<String>(
                            value: pkg.packageId,
                            child: Text(
                              pkg.displayName.isNotEmpty
                                  ? pkg.displayName
                                  : 'Package ${pkg.packageCode}',
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
                      label: const Text('Add package to job card'),
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
    final priceText = price > 0 ? currencyFormat.format(price) : 'Included';
    final tags = <Widget>[];
    if (package.isEmergency) {
      tags.add(const _PackageTag(label: 'Emergency', color: Color(0xFFB42318)));
    }
    if (package.isCustomPackage) {
      tags.add(const _PackageTag(label: 'Custom', color: Color(0xFF027A48)));
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
                    : 'Package ${package.packageCode}',
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
          'Code: ${package.packageCode}',
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
          'Line price',
          currencyFormat.format(package.linePrice),
        ),
        _PackageDetailRow(
          'Total price',
          currencyFormat.format(package.totalPrice),
        ),
        _PackageDetailRow('Total tax', currencyFormat.format(package.totalTax)),
        _PackageDetailRow(
          'Total discount',
          package.totalDiscount > 0
              ? '- ${currencyFormat.format(package.totalDiscount)}'
              : '0.00',
        ),
        _PackageDetailRow(
          'List price',
          currencyFormat.format(package.totalListPrice),
        ),
        if (package.packageShortName.isNotEmpty)
          _PackageDetailRow('Short name', package.packageShortName),
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

class _DetailRowData {
  _DetailRowData(this.label, this.value);

  final String label;
  final String value;
}

class _StatusHelperCard extends StatelessWidget {
  const _StatusHelperCard._({
    this.isLoading = false,
    this.message,
    this.onRetry,
  });

  const _StatusHelperCard.loading() : this._(isLoading: true);
  const _StatusHelperCard.error({
    required String message,
    VoidCallback? onRetry,
  }) : this._(message: message, onRetry: onRetry);

  final bool isLoading;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const LinearProgressIndicator(minHeight: 2)
            else if (message != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      message!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (onRetry != null)
                    TextButton(onPressed: onRetry, child: const Text('Retry')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TechnicianHomeScreenDefaults {
  static const int statusId = 12;
}
