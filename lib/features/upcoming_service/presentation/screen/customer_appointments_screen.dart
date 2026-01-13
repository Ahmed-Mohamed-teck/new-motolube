import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../../core/widget/internal_app_bar.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../../technician/domain/entity/booking_status.dart';
import '../../../technician/presentation/widget/status_picker_sheet.dart';
import '../../../technician/provider/technician_provider.dart';
import '../../domain/entity/upcoming_service_entity.dart';
import '../../provider/upcoming_service_provider.dart';
import '../view_model/upcoming_service_state.dart';
import '../widget/booking_card.dart';

class CustomerAppointmentsScreen extends ConsumerStatefulWidget {
  const CustomerAppointmentsScreen({super.key});

  @override
  ConsumerState<CustomerAppointmentsScreen> createState() =>
      _CustomerAppointmentsScreenState();
}

class _CustomerAppointmentsScreenState
    extends ConsumerState<CustomerAppointmentsScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  int? _statusId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialFetch();
    });
  }

  void _triggerInitialFetch() {
    final authState = ref.read(authViewModelProvider);
    final isAuthed = authState is AuthenticatedState;
    if (isAuthed) {
      ref
          .read(upcomingServiceViewModelProvider.notifier)
          .fetchUpcomingServices(
            fromDate: _fromDate,
            toDate: _toDate,
            statusId: _statusId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (prev, next) {
      if (next is UnauthenticatedState) {
        ref.invalidate(upcomingServiceViewModelProvider);
      } else if (prev is! AuthenticatedState && next is AuthenticatedState) {
        _triggerInitialFetch();
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final s = S.of(context);
    final servicesState = ref.watch(upcomingServiceViewModelProvider);
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
    final statusLabel =
        _statusId == null
            ? 'Any status'
            : _statusLabelFor(statuses, _statusId!);
    final statusHelperText =
        statusLoading
            ? 'Loading booking statuses...'
            : statusErrorMessage != null
            ? _humanizeMessage(statusErrorMessage)
            : (statuses.isEmpty ? 'No statuses available.' : null);
    final statusHelperIsError = statusErrorMessage != null;
    final statusRetryCallback =
        statusErrorMessage != null ? _retryStatuses : null;

    return Scaffold(
      appBar: InternalAppBar(title: s.upcomingService),
      body: SafeArea(
        child: Column(
          children: [
            _FilterBar(
              fromDateLabel: _formatDateLabel(_fromDate),
              toDateLabel: _formatDateLabel(_toDate),
              statusLabel: statusLabel,
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
              onApply: () {
                setState(() {}); // Rebuild to apply filters locally
                ref
                    .read(upcomingServiceViewModelProvider.notifier)
                    .fetchUpcomingServices(
                      fromDate: _fromDate,
                      toDate: _toDate,
                      statusId: _statusId,
                    );
              },
            ),
            Expanded(
              child: _buildContent(
                context: context,
                authState: authState,
                servicesState: servicesState,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required AuthState authState,
    required UpcomingServiceState servicesState,
  }) {
    if (authState is UnauthenticatedState) {
      return _LoginPromptCard(
        onTap: () {
          navigatorKey.currentState?.pushNamed('loginScreen');
        },
      );
    }

    if (servicesState is UpcomingServiceLoading ||
        servicesState is UpcomingServiceInitial) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: List.generate(
          2,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _UpcomingServiceLoadingCard(),
          ),
        ),
      );
    }

    if (servicesState is UpcomingServiceLoaded) {
      final services = servicesState.services;
      if (services.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: const [_UpcomingServiceEmpty()],
        );
      }
      final children = services
          .map((service) => _mapToBookingCard(service))
          .expand((widget) => [widget, const SizedBox(height: 12)])
          .toList()
        ..removeLast();
      return RefreshIndicator(
        onRefresh: () => ref
            .read(upcomingServiceViewModelProvider.notifier)
            .fetchUpcomingServices(
              fromDate: _fromDate,
              toDate: _toDate,
              statusId: _statusId,
            ),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: children,
        ),
      );
    }

    if (servicesState is UpcomingServiceEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [_UpcomingServiceEmpty()],
      );
    }

    if (servicesState is UpcomingServiceError) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _UpcomingServiceErrorCard(message: servicesState.message),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _pickDate({required bool isFromDate}) async {
    final now = DateTime.now();
    final fallback = DateTime(now.year, now.month, now.day);
    final initialDate =
        isFromDate ? (_fromDate ?? fallback) : (_toDate ?? _fromDate ?? fallback);
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
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatusPickerSheet(
          statuses: statuses,
          selectedId: _statusId ?? -1,
          onSelected: (status) {
            setState(() {
              _statusId = int.tryParse(status.code);
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _retryStatuses() {
    ref.invalidate(technicianBookingStatusesProvider);
  }

  void _resetFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _statusId = null;
    });
  }

  String _formatDateLabel(DateTime? value) {
    if (value == null) return 'Any date';
    return DateFormat('dd-MMM-yyyy').format(value);
  }

  String _statusLabelFor(List<TechnicianBookingStatus> statuses, int id) {
    final match = statuses.firstWhere(
      (status) => int.tryParse(status.code) == id,
      orElse: () => TechnicianBookingStatus(
        code: id.toString(),
        label: 'Status $id',
      ),
    );
    return match.label.isNotEmpty ? match.label : 'Status ${match.code}';
  }

  String _humanizeMessage(String message) {
    if (message.toLowerCase().contains('timeout')) {
      return 'Connection timed out. Please try again.';
    }
    return message.isNotEmpty ? message : 'Something went wrong.';
  }

  Widget _mapToBookingCard(UpcomingServiceEntity service) {
    final s = S.of(context);
    final dateLabel = _formatDate(context, service);
    final timeLabel = _formatTime(service);
    final branchLabel = _valueOrFallback(
      service.branchLabel.isNotEmpty ? service.branchLabel : service.location ?? '',
      fallback: s.upcomingServicesLocationFallback,
    );
    final technicianLabel = _valueOrFallback(
      service.technicianLabel,
      fallback: s.upcomingServicesTechnicianFallback,
    );
    final plateText = _valueOrFallback(
      service.plateText,
      fallback: s.upcomingServicesPlateFallback,
    );
    final carCandidate =
        service.carTitle.isNotEmpty ? service.carTitle : service.serviceName;
    final carTitle = _valueOrFallback(
      carCandidate,
      fallback: s.upcomingServicesVehiclePlaceholder,
    );
    final packageCandidate = service.packageTitle.isNotEmpty
        ? service.packageTitle
        : service.serviceName;
    final package = _valueOrFallback(
      packageCandidate,
      fallback: s.upcomingServicesServicePlaceholder,
    );
    final statusRaw = service.status.trim();
    final statusLabel = _statusLabel(context, statusRaw);
    final statusColors = _statusColorsForStatus(
      statusRaw.isEmpty ? 'pending' : statusRaw,
    );

    return BookingSummaryCard(
      carTitle: carTitle,
      plate: plateText,
      packageTitle: package,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      locationLabel: branchLabel,
      technicianLabel: technicianLabel,
      statusText: statusLabel,
      statusBg: statusColors.$1,
      statusFg: statusColors.$2,
      onTap: () async {
        final result = await Navigator.of(context, rootNavigator: true).pushNamed(
          'bookingDetailScreen',
          arguments: service,
        );
        if (result == true && mounted) {
          await ref.read(upcomingServiceViewModelProvider.notifier).fetchUpcomingServices(
                fromDate: _fromDate,
                toDate: _toDate,
                statusId: _statusId,
              );
        }
      },
    );
  }

String _formatDate(BuildContext context, UpcomingServiceEntity service) {
  final date = service.appointmentDate;
  if (date != null) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  final raw = service.appointmentDateText.trim();
  if (raw.isNotEmpty) {
    return raw;
  }
  return S.of(context).upcomingServicesDateFallback;
}

String _formatTime(UpcomingServiceEntity service) {
  final slot = service.timeSlot?.trim() ?? '';
  if (slot.isNotEmpty) {
    return slot;
  }
  final date = service.appointmentDate;
  if (date != null && (date.hour != 0 || date.minute != 0)) {
    return DateFormat('hh:mm a').format(date);
  }
  return '';
}

String _valueOrFallback(String value, {required String fallback}) {
  final trimmed = value.trim();
  return trimmed.isNotEmpty ? trimmed : fallback;
}

String _statusLabel(BuildContext context, String status) {
  final s = S.of(context);
  final lower = status.toLowerCase();
  if (lower.contains('expired')) return s.upcomingServicesStatusExpired;
  if (lower.contains('upcoming')) return s.upcomingServicesStatusUpcoming;
  if (lower.contains('pending')) return s.upcomingServicesStatusPending;
  if (lower.contains('complete')) return s.upcomingServicesStatusCompleted;
  if (lower.contains('cancel')) return s.upcomingServicesStatusCancelled;
  if (lower.contains('new')) return s.upcomingServicesStatusNew;
  return status.isEmpty ? s.upcomingServicesStatusPending : status;
}

(Color, Color) _statusColorsForStatus(String status) {
  final normalized = status.toLowerCase();
  if (normalized.contains('complete')) {
    return (const Color(0xFFE5F5EB), const Color(0xFF1E8052));
  }
  if (normalized.contains('cancel') || normalized.contains('expire')) {
    return (const Color(0xFFFDE7E6), const Color(0xFFBE3A2E));
  }
  if (normalized.contains('schedule') ||
      normalized.contains('confirm') ||
      normalized.contains('book')) {
    return (const Color(0xFFE2ECFF), const Color(0xFF0F4AA3));
  }
  return (const Color(0xFFF1F2F4), const Color(0xFF44474F));
}

}

class _UpcomingServiceLoadingCard extends StatelessWidget {
  const _UpcomingServiceLoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseFg = theme.colorScheme.onSurfaceVariant;
    final s = S.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonLine(width: 120, height: 14, color: baseFg),
            const SizedBox(height: 8),
            _SkeletonLine(width: 160, height: 12, color: baseFg),
            const SizedBox(height: 8),
            _SkeletonLine(width: 100, height: 12, color: baseFg.withOpacity(0.7)),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(s.upcomingServicesLoadingStatus),
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  labelStyle: TextStyle(color: baseFg),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _UpcomingServiceEmpty extends StatelessWidget {
  const _UpcomingServiceEmpty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).upcomingServicesEmptyMessage,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingServiceErrorCard extends StatelessWidget {
  const _UpcomingServiceErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${S.of(context).upcomingServicesErrorPrefix}\n$message',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginPromptCard extends StatelessWidget {
  const _LoginPromptCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        S.of(context).upcomingServicesLoginPrompt,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    child: Text(S.of(context).upcomingServicesViewButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
                      'Plan your day',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap a filter to refine your appointments.',
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
                label: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FilterButton(
                label: 'From',
                value: fromDateLabel,
                icon: Icons.calendar_today,
                onTap: onSelectFromDate,
                enabled: true,
              ),
              _FilterButton(
                label: 'To',
                value: toDateLabel,
                icon: Icons.event,
                onTap: onSelectToDate,
                enabled: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _FilterButton(
            label: 'Status',
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
                      child: const Text('Retry'),
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
              label: const Text('Apply filters'),
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
