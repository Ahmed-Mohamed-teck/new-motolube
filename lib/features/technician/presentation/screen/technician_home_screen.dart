import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../domain/entity/booking_status.dart';
import '../../domain/entity/technician_appointment_entity.dart';
import '../../provider/technician_provider.dart';
import '../widget/maintenance_request_card.dart';
import '../widget/status_picker_sheet.dart';
import 'technician_appointment_details_screen.dart';
import '../view_model/technician_appointments_state.dart';
import '../../../../generated/l10n.dart';

class TechnicianHomeScreen extends ConsumerStatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  ConsumerState<TechnicianHomeScreen> createState() =>
      _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends ConsumerState<TechnicianHomeScreen> {
  static const int _defaultStatusId = 1;

  DateTime? _fromDate;
  DateTime? _toDate;
  Set<int> _selectedStatusIds = {_defaultStatusId};
  String? _lastFetchedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointmentsForCurrentUser();
    });
  }

  Future<void> _loadAppointmentsForCurrentUser() async {
    final authState = ref.read(authViewModelProvider);
    final userId = _userIdFromState(authState);
    if (userId != null && userId.isNotEmpty) {
      _lastFetchedUserId = userId;
      await _fetchAppointments(userId);
    }
  }

  Future<void> _fetchAppointments(String userId) async {
    if (!mounted) return;
    await ref
        .read(technicianAppointmentsViewModelProvider.notifier)
        .loadAppointments(
          userId: userId,
          fromDate: _fromDate,
          toDate: _toDate,
          statusIds: _effectiveStatusIds(),
        );
  }

  String? _userIdFromState(AuthState? state) {
    if (state is AuthenticatedState) {
      return state.user.oracleId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      final currentUserId = _userIdFromState(next);
      if (currentUserId == null || currentUserId.isEmpty) {
        _lastFetchedUserId = null;
        return;
      }
      if (currentUserId != _lastFetchedUserId) {
        _lastFetchedUserId = currentUserId;
        _fetchAppointments(currentUserId);
      }
    });

    final statusesAsync = ref.watch(technicianBookingStatusesProvider);
    final statuses = statusesAsync.maybeWhen(
      data: (value) => value,
      orElse: () => const <TechnicianBookingStatus>[],
    );
    final statusErrorMessage = statusesAsync.whenOrNull(
      error: (error, _) => error.toString(),
    );
    final statusLoading = statusesAsync.isLoading;
    final statusButtonEnabled =
        !statusLoading && statusErrorMessage == null && statuses.isNotEmpty;
    final statusValueLabel =
        statusLoading
            ? S.of(context).loadingEllipsis
            : statusErrorMessage != null
            ? S.of(context).unavailableLabel
            : (statuses.isEmpty ? S.of(context).noStatusesLabel : _statusLabelFor(statuses));
    final statusHelperText =
        statusLoading
            ? S.of(context).loadingBookingStatusesMessage
            : statusErrorMessage != null
            ? _humanizeMessage(statusErrorMessage)
            : (statuses.isEmpty ? S.of(context).noStatusesAvailableMessage : null);
    final statusHelperIsError = statusErrorMessage != null;
    final statusRetryCallback =
        statusErrorMessage != null ? _retryStatuses : null;

    final appointmentsState = ref.watch(
      technicianAppointmentsViewModelProvider,
    );
    final authState = ref.watch(authViewModelProvider);
    final userId = _userIdFromState(authState);

    if (userId == null || userId.isEmpty) {
      return _UnauthorizedView(onReload: _loadAppointmentsForCurrentUser);
    }

    Widget content;
    if (appointmentsState is TechnicianAppointmentsLoading ||
        appointmentsState is TechnicianAppointmentsInitial) {
      content = const _LoadingView();
    } else if (appointmentsState is TechnicianAppointmentsLoaded) {
      content = _AppointmentsListView(
        appointments: appointmentsState.appointments,
        onViewDetails: _openAppointmentDetails,
      );
    } else if (appointmentsState is TechnicianAppointmentsEmpty) {
      content = const _EmptyAppointmentsView();
    } else if (appointmentsState is TechnicianAppointmentsError) {
      content = _ErrorAppointmentsView(
        message: _humanizeMessage(appointmentsState.message),
        onRetry: () => _fetchAppointments(userId),
      );
    } else {
      content = const _EmptyAppointmentsView();
    }

    return SafeArea(
      child: Column(
        children: [
          _FilterBar(
            fromDateLabel: _formatDateLabel(_fromDate),
            toDateLabel: _formatDateLabel(_toDate),
            statusLabel: statusValueLabel,
            statusEnabled: statusButtonEnabled,
            statusLoading: statusLoading,
            statusHelperText: statusHelperText,
            statusHelperIsError: statusHelperIsError,
            onRetryStatus: statusRetryCallback,
            onSelectFromDate: () => _pickDate(isFromDate: true),
            onSelectToDate: () => _pickDate(isFromDate: false),
            onSelectStatus:
                statusButtonEnabled
                    ? () => _showStatusSelector(statuses)
                    : null,
            onReset: _resetFilters,
            onApply: () => _fetchAppointments(userId),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchAppointments(userId),
              child: content,
            ),
          ),
        ],
      ),
    );
  }

  String _humanizeMessage(String message) {
    if (message.toLowerCase().contains('timeout')) {
      return S.of(context).connectionTimedOutMessage;
    }
    return message.isNotEmpty ? message : S.of(context).somethingWentWrong;
  }

  String _statusLabelFor(List<TechnicianBookingStatus> statuses) {
    final ids = _effectiveStatusIds();
    final labels = <String>[];
    for (final id in ids) {
      final match = _statusById(statuses, id);
      if (match != null && match.label.isNotEmpty) {
        labels.add(match.label);
      }
    }
    if (labels.isEmpty) {
      if (ids.length == 1) return S.of(context).statusIdLabel(ids.first);
      return S.of(context).statusesSelectedCount(ids.length);
    }
    if (labels.length <= 2) return labels.join(', ');
    return '${labels.take(2).join(', ')} +${labels.length - 2} more';
  }

  TechnicianBookingStatus? _statusById(
    List<TechnicianBookingStatus> statuses,
    int id,
  ) {
    for (final status in statuses) {
      final parsed = int.tryParse(status.code);
      if (parsed != null && parsed == id) {
        return status;
      }
    }
    return null;
  }

  Future<void> _pickDate({required bool isFromDate}) async {
    final now = DateTime.now();
    final fallback = DateTime(now.year, now.month, now.day);
    final initialDate =
        isFromDate
            ? (_fromDate ?? fallback)
            : (_toDate ?? _fromDate ?? fallback);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 2),
    );
    if (picked == null) return;
    setState(() {
      final normalized = DateTime(picked.year, picked.month, picked.day);
      if (isFromDate) {
        _fromDate = normalized;
        if (_toDate != null && _toDate!.isBefore(normalized)) {
          _toDate = normalized;
        }
      } else {
        _toDate = normalized;
        if (_fromDate != null && normalized.isBefore(_fromDate!)) {
          _fromDate = normalized;
        }
      }
    });
  }

  void _showStatusSelector(List<TechnicianBookingStatus> statuses) {
    showModalBottomSheet<Set<int>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatusPickerSheet(
          statuses: statuses,
          selectedIds: _effectiveStatusIds().toSet(),
        );
      },
    ).then((selection) {
      if (!mounted || selection == null) return;
      setState(() {
        _selectedStatusIds =
            selection.isEmpty ? {_defaultStatusId} : selection;
      });
    });
  }

  void _retryStatuses() {
    ref.invalidate(technicianBookingStatusesProvider);
  }

  void _resetFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedStatusIds = {_defaultStatusId};
    });
  }

  String _formatDateLabel(DateTime? value) {
    if (value == null) return S.of(context).anyDateLabel;
    return DateFormat('dd-MMM-yyyy').format(value);
  }

  Future<void> _openAppointmentDetails(
    TechnicianAppointmentEntity appointment,
  ) async {
    final updated = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        builder:
            (_) => TechnicianAppointmentDetailsScreen(appointment: appointment),
      ),
    );
    if (updated == true) {
      final userId =
          _lastFetchedUserId ??
          _userIdFromState(ref.read(authViewModelProvider));
      if (userId != null && userId.isNotEmpty) {
        await _fetchAppointments(userId);
      }
    }
  }

  List<int> _effectiveStatusIds() {
    if (_selectedStatusIds.isEmpty) return [_defaultStatusId];
    return _selectedStatusIds.toList()..sort();
  }

}

class _AppointmentsListView extends StatelessWidget {
  final List<TechnicianAppointmentEntity> appointments;
  final void Function(TechnicianAppointmentEntity appointment) onViewDetails;

  const _AppointmentsListView({
    required this.appointments,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return MaintenanceRequestCard(
          initials: _initials(appointment.customerName),
          name:
              appointment.customerName.isNotEmpty
                  ? appointment.customerName
                  : S.of(context).customerDefaultLabel,
          car:
              appointment.displayCar.isNotEmpty
                  ? appointment.displayCar
                  : S.of(context).vehicleNotSetLabel,
          plate:
              appointment.displayPlate.isNotEmpty
                  ? appointment.displayPlate
                  : S.of(context).plateUnavailableLabel,
          timeRange: _timeRangeText(appointment, context),
          branch:
              appointment.branchName.isNotEmpty
                  ? appointment.branchName
                  : S.of(context).branchNotAssignedLabel,
          service: appointment.packageLabel,
          status:
              appointment.statusLabel.isNotEmpty
                  ? appointment.statusLabel
                  : S.of(context).scheduledStatusLabel,
          statusColor: _statusColor(appointment),
          onViewDetails: () => onViewDetails(appointment),
        );
      },
    );
  }

  static String _initials(String value) {
    final sanitized = value.trim();
    if (sanitized.isEmpty) {
      return 'ML';
    }
    final parts = sanitized.split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    final buffer = StringBuffer();
    for (final part in parts) {
      buffer.write(part.characters.first);
      if (buffer.length >= 2) break;
    }
    final result = buffer.toString().toUpperCase();
    return result.isEmpty ? 'ML' : result;
  }

  static Color _statusColor(TechnicianAppointmentEntity appointment) {
    final raw = appointment.statusColorValue;
    if (raw != null) {
      return Color(raw);
    }
    final label = appointment.statusLabel.toLowerCase();
    if (label.contains('complete')) return const Color(0xFF16A34A);
    if (label.contains('progress')) return const Color(0xFFF97316);
    if (label.contains('cancel')) return const Color(0xFFDC2626);
    if (label.contains('expire')) return const Color(0xFF9CA3AF);
    return AppColors.lightPrimary;
  }

  static String _timeRangeText(
    TechnicianAppointmentEntity appointment,
    BuildContext context,
  ) {
    final parts = <String>[];
    final date = appointment.bookingDate;
    if (date != null) {
      parts.add(DateFormat('EEE, dd MMM yyyy').format(date));
    } else if (appointment.bookingDateText.trim().isNotEmpty) {
      parts.add(appointment.bookingDateText.trim());
    }
    if (appointment.slotTime.trim().isNotEmpty) {
      parts.add(appointment.slotTime.trim());
    }
    return parts.isNotEmpty
        ? parts.join(' • ')
        : S.of(context).scheduleNotSetLabel;
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 120),
      children: const [Center(child: CircularProgressIndicator())],
    );
  }
}

class _EmptyAppointmentsView extends StatelessWidget {
  const _EmptyAppointmentsView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              S.of(context).noMaintenanceRequestsYet,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).assignedAppointmentsWillAppearHere,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}

class _ErrorAppointmentsView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorAppointmentsView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 56, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            Text(
              S.of(context).unableToLoadRequests,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(S.of(context).retryButtonLabel),
            ),
          ],
        ),
      ],
    );
  }
}

class _UnauthorizedView extends StatelessWidget {
  final Future<void> Function() onReload;

  const _UnauthorizedView({required this.onReload});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onReload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                S.of(context).signInRequiredTitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).signInAsTechnicianMessage,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.fromDateLabel,
    required this.toDateLabel,
    required this.statusLabel,
    required this.statusEnabled,
    required this.statusLoading,
    required this.statusHelperText,
    required this.statusHelperIsError,
    required this.onRetryStatus,
    required this.onSelectFromDate,
    required this.onSelectToDate,
    required this.onSelectStatus,
    required this.onReset,
    required this.onApply,
  });

  final String fromDateLabel;
  final String toDateLabel;
  final String statusLabel;
  final bool statusEnabled;
  final bool statusLoading;
  final String? statusHelperText;
  final bool statusHelperIsError;
  final VoidCallback? onRetryStatus;
  final VoidCallback onSelectFromDate;
  final VoidCallback onSelectToDate;
  final VoidCallback? onSelectStatus;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
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
                      S.of(context).planYourDay,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).tapFilterToRefineJobs,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(S.of(context).resetButtonLabel),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FilterButton(
                label: S.of(context).fromDateLabel,
                value: fromDateLabel,
                icon: Icons.calendar_today,
                onTap: onSelectFromDate,
                enabled: true,
              ),
              _FilterButton(
                label: S.of(context).toDateLabel,
                value: toDateLabel,
                icon: Icons.event,
                onTap: onSelectToDate,
                enabled: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _FilterButton(
            label: S.of(context).statusLabel,
            value: statusLabel,
            icon: Icons.flag_outlined,
            onTap: onSelectStatus,
            enabled: statusEnabled,
            expanded: true,
          ),
          if (statusHelperText != null || statusLoading) ...[
            const SizedBox(height: 12),
            if (statusHelperText != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      statusHelperText!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            statusHelperIsError
                                ? Colors.redAccent
                                : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  if (statusHelperIsError && onRetryStatus != null)
                    TextButton(
                      onPressed: onRetryStatus,
                      child: Text(S.of(context).retryButtonLabel),
                    ),
                ],
              ),
            if (statusLoading) const LinearProgressIndicator(minHeight: 2),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onApply,
              icon: const Icon(Icons.filter_alt),
              label: Text(S.of(context).applyFiltersButtonLabel),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.value,
    required this.onTap,
    required this.icon,
    required this.enabled,
    this.expanded = false,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData icon;
  final bool enabled;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = OutlinedButton(
      onPressed: enabled ? onTap : null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        alignment: Alignment.centerLeft,
        backgroundColor: enabled ? Colors.white : const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(
          color:
              enabled
                  ? theme.colorScheme.primary.withOpacity(0.35)
                  : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return SizedBox(width: 172, child: button);
  }
}
