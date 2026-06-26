import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';
import 'package:newmotorlube/generated/l10n.dart';

import '../../../../core/utils/helper_fuc.dart';
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
  late String _initialStatusCode;
  bool _hasUpdates = false;
  bool _isCreatingSr = false;
  bool _isCompletingSr = false;
  int? _pendingStatusId;
  String _srNumber = '';
  String? _selectedPackageId;

  @override
  void initState() {
    super.initState();
    final initialId = _resolveInitialStatusId();
    _initialStatusCode = _resolveInitialStatusCode();
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
    if (oldWidget.appointment.bookingStatus.code !=
            widget.appointment.bookingStatus.code ||
        oldWidget.appointment.bookingStatus.label !=
            widget.appointment.bookingStatus.label) {
      final parsedId = _resolveInitialStatusId();
      _initialStatusCode = _resolveInitialStatusCode();
      _initialStatusId = parsedId;
      _selectedStatusId = parsedId;
    }
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
          _showSnack(S.of(context).statusUpdatedSuccessfully);
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
    final visibleStatuses = _filterStatusesForCurrentState(statuses);
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

    List<TechnicianBookingStatus> orderedStatuses = visibleStatuses;
    if (visibleStatuses.isNotEmpty) {
      orderedStatuses = [...visibleStatuses]
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

    final showChatAction = widget.appointment.bookingId.trim().isNotEmpty;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_hasUpdates);
        return false;
      },
      child: Scaffold(
        appBar: InternalAppBar(
          title: S.of(context).appointmentDetailsTitle,
          onBack: () => Navigator.of(context).pop(_hasUpdates),
          actions: [
            if (showChatAction)
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                color: Theme.of(context).colorScheme.primary,
                tooltip: S.of(context).chatTitle,
                onPressed: _openChat,
              ),
          ],
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
                                label: Text(S.of(context).vehicleChecklistTitle),
                              ),
                              TextButton.icon(
                                onPressed: _openJobCardManagementScreen,
                                icon: const Icon(Icons.admin_panel_settings_outlined),
                                label: Text(S.of(context).managePackagesButtonLabel),
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
                            child: Text(S.of(context).retryButtonLabel),
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
            else if (visibleStatuses.isEmpty)
              _StatusHelperCard.error(
                message: S.of(context).noBookingStatusesAvailableMessage,
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
      _showSnack(S.of(context).jobCardNumberUnavailableMessage);
      return;
    }
    final userId = await _fetchFirebaseId();
    if (userId.isEmpty) {
      _showSnack(S.of(context).unableToDetermineTechnicianIdMessage);
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
      _showSnack(S.of(context).jobCardNumberUnavailableMessage);
      return;
    }
    final userId = await _fetchFirebaseId();
    if (userId.isEmpty) {
      _showSnack(S.of(context).unableToDetermineTechnicianIdMessage);
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
      _showSnack(S.of(context).jobCardNumberUnavailableMessage);
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
        _showSnack(S.of(context).alreadyOnStatusMessage(status.label));
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
      final parsed = _parseStatusInt(statuses[i].code);
      if (parsed != null && parsed == statusId) {
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

  int? _statusIndexByCode(
    List<TechnicianBookingStatus> statuses,
    String code,
  ) {
    final normalized = _normalizeStatusCode(code);
    if (normalized.isEmpty) return null;
    for (var i = 0; i < statuses.length; i++) {
      if (_normalizeStatusCode(statuses[i].code) == normalized) {
        return i;
      }
    }
    return null;
  }

  int? _resolveCurrentStatusIndex(List<TechnicianBookingStatus> statuses) {
    final byCode = _statusIndexByCode(
      statuses,
      widget.appointment.bookingStatus.code,
    );
    if (byCode != null) return byCode;
    final bySelected = _statusIndex(statuses, _selectedStatusId);
    if (bySelected != null) return bySelected;
    final byId = _statusIndex(statuses, _initialStatusId);
    if (byId != null) return byId;
    final byLabel = _statusIndexByLabel(
      statuses,
      widget.appointment.statusLabel,
    );
    if (byLabel != null) return byLabel;
    return null;
  }

  int _statusIdAtIndex(List<TechnicianBookingStatus> statuses, int index) {
    if (index < 0 || index >= statuses.length) {
      return _initialStatusId;
    }
    return _parseStatusId(statuses[index]);
  }

  int _resolveCurrentStatusId(List<TechnicianBookingStatus> statuses) {
    final selectedIndex = _statusIndex(statuses, _selectedStatusId);
    if (selectedIndex != null) {
      return _statusIdAtIndex(statuses, selectedIndex);
    }
    final index = _resolveCurrentStatusIndex(statuses);
    if (index != null) {
      return _statusIdAtIndex(statuses, index);
    }
    return _initialStatusId;
  }

  String _normalizeStatusLabel(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  int _resolveInitialStatusId() {
    final codeId = _parseStatusInt(widget.appointment.bookingStatus.code);
    if (codeId != null) return codeId;
    final labelId = _parseStatusInt(widget.appointment.bookingStatus.label);
    if (labelId != null) return labelId;
    return TechnicianHomeScreenDefaults.statusId;
  }

  String _resolveInitialStatusCode() {
    final rawCode = widget.appointment.bookingStatus.code.trim();
    if (rawCode.isNotEmpty) return rawCode;
    final label = widget.appointment.bookingStatus.label.trim();
    if (label.isNotEmpty) return label;
    return '';
  }

  int _parseStatusId(TechnicianBookingStatus status) {
    return _parseStatusInt(status.code) ?? TechnicianHomeScreenDefaults.statusId;
  }

  int? _parseStatusInt(String? code) {
    final raw = code?.trim() ?? '';
    if (raw.isEmpty) return null;

    final canonical = _canonicalStatusKey(raw);
    if (canonical != null) {
      final mapped = getStatusIdFromStatusName(canonical);
      if (mapped != 0) return mapped;
    }

    final mapped = getStatusIdFromStatusName(raw);
    if (mapped != 0) return mapped;

    final intVal = int.tryParse(raw);
    if (intVal != null) return intVal;

    final doubleVal = double.tryParse(raw);
    if (doubleVal != null) return doubleVal.toInt();

    final digits = RegExp(r'-?\d+').firstMatch(raw);
    if (digits != null) {
      final fromDigits = int.tryParse(digits.group(0)!);
      if (fromDigits != null) return fromDigits;
    }

    return null;
  }

  String _normalizeStatusCode(String? code) {
    final raw = code?.trim() ?? '';
    if (raw.isEmpty) return '';
    final parsed = _parseStatusInt(raw);
    if (parsed != null) return parsed.toString();
    return raw.toLowerCase();
  }

  List<TechnicianBookingStatus> _filterStatusesForCurrentState(
    List<TechnicianBookingStatus> statuses,
  ) {
    if (!_isInvoicedPaidStatus(statuses)) return statuses;
    const hiddenKeys = {
      'cancelled',
      'needapproval',
      'companyrejected',
      'expired',
    };
    return statuses.where((status) {
      final normalizedCode = _normalizeStatusCode(status.code);
      final normalizedLabel = _normalizeStatusLabel(status.label);
      return !hiddenKeys.contains(normalizedCode) &&
          !hiddenKeys.contains(normalizedLabel);
    }).toList();
  }

  bool _isInvoicedPaidStatus(List<TechnicianBookingStatus> statuses) {
    final invoicedPaidId = getStatusIdFromStatusName('invoicedPaid');
    if (invoicedPaidId != 0) {
      final currentStatusId = _resolveCurrentStatusId(statuses);
      if (currentStatusId == invoicedPaidId) return true;
    }
    final normalizedCode = _normalizeStatusCode(
      widget.appointment.bookingStatus.code,
    );
    if (normalizedCode == 'invoicedpaid' || normalizedCode == '8') return true;
    final normalizedLabel = _normalizeStatusLabel(
      widget.appointment.bookingStatus.label,
    );
    return normalizedLabel == 'invoicedpaid';
  }

  String? _canonicalStatusKey(String raw) {
    final normalized = raw.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (normalized.isEmpty) return null;
    const map = {
      'newbooking': 'newBooking',
      'accepted': 'accepted',
      'rejected': 'rejected',
      'drivetocustomer': 'driveToCustomer',
      'arrived': 'arrived',
      'openjobcard': 'openJobCard',
      'completedjobcard': 'completedJobCard',
      'invoicedpaid': 'invoicedPaid',
      'cancelled': 'cancelled',
      'needapproval': 'needApproval',
      'companyrejected': 'companyRejected',
      'expired': 'expired',
    };
    return map[normalized];
  }

  Future<bool> _createServiceRequest() async {
    setState(() => _isCreatingSr = true);
    try {
      final authRepo = ref.read(authLocalRepositoryProvider);
      final stored = await authRepo.getStoredAuth();
      if (stored == null || stored.fireBaseId.isEmpty) {
        _showSnack(S.of(context).missingFirebaseIdForTechnicianMessage);
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
        _showSnack(S.of(context).jobCardCreatedMessage(results.first.srNumber));
      } else {
        _showSnack(S.of(context).serviceRequestCreatedMessage);
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
      _showSnack(S.of(context).jobCardNumberMissingMessage);
      return false;
    }
    final userId = await _fetchFirebaseId();
    if (userId.isEmpty) {
      _showSnack(S.of(context).userIdentifierMissingMessage);
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
      _showSnack(S.of(context).jobCardCompletedSuccessfullyMessage);
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

  void _openChat() {
    final bookingId = widget.appointment.bookingId.trim();
    if (bookingId.isEmpty) {
      _showSnack(S.of(context).chatMissingBookingId);
      return;
    }
    Navigator.of(context, rootNavigator: true).pushNamed(
      'chatScreen',
      arguments: bookingId,
    );
  }

  String _humanizeMessage(String message) {
    if (message.toLowerCase().contains('timeout')) {
      return S.of(context).connectionTimedOutMessage;
    }
    return message.isNotEmpty ? message : S.of(context).somethingWentWrong;
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
              S.of(context).bookingStatusTitle,
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

    return IgnorePointer(
      ignoring: !enabled,
      child: ChoiceChip(
        label: Text(
          status.label.isNotEmpty
              ? status.label
              : S.of(context).statusCodeLabel(status.code),
        ),
        selected: isSelected,
        onSelected: (_) {
          if (!enabled) return;
          onTap();
        },
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
      ),
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
                        : S.of(context).customerDefaultLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.packageLabel.isNotEmpty
                        ? appointment.packageLabel
                        : S.of(context).maintenancePackageDefaultLabel,
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
                          : S.of(context).statusLabel,
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
        S.of(context).branchFieldLabel,
        appointment.branchName.isNotEmpty
            ? appointment.branchName
            : S.of(context).notAssignedLabel,
      ),
      _DetailRowData(
        S.of(context).vehicleFieldLabel,
        appointment.displayCar.isNotEmpty
            ? appointment.displayCar
            : S.of(context).vehicleNotSetLabel,
      ),
      _DetailRowData(
        S.of(context).plateFieldLabel,
        appointment.displayPlate.isNotEmpty
            ? appointment.displayPlate
            : S.of(context).unavailableLabel,
      ),
      _DetailRowData(
        S.of(context).scheduleFieldLabel,
        '${_formatDate(appointment)}'
            '${appointment.slotTime.isNotEmpty ? ' · ${appointment.slotTime}' : ''}',
      ),
      _DetailRowData(
        S.of(context).vinFieldLabel,
        appointment.vin.isNotEmpty ? appointment.vin : '--',
      ),
      _DetailRowData(
        S.of(context).technicianFieldLabel,
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
            ? S.of(context).jobCardOpenLoadingPackagesMessage
            : isCreatingSr
            ? S.of(context).creatingJobCardMessage
            : S.of(context).openJobCardToViewPackagesMessage;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).jobCardPackagesTitle,
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
              S.of(context).bookingStatusTitle,
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
                    TextButton(onPressed: onRetry, child: Text(S.of(context).retryButtonLabel)),
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
