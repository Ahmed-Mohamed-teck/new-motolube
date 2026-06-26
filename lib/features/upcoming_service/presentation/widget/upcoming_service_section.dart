import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widget/error_widget.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../domain/entity/upcoming_service_entity.dart';
import '../../provider/upcoming_service_provider.dart';
import 'booking_card.dart';
import '../view_model/upcoming_service_state.dart';

class UpcomingServiceSection extends ConsumerWidget {
  const UpcomingServiceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next is! AuthenticatedState) {
        ref.invalidate(upcomingServiceViewModelProvider);
      }
    });

    final authState = ref.watch(authViewModelProvider);

    if (authState is! AuthenticatedState) {
      return _LoginPromptCard(
        onTap: () {
          navigatorKey.currentState?.pushNamed('loginScreen');
        },
      );
    }

    final state = ref.watch(upcomingServiceViewModelProvider);

    if (state is UpcomingServiceInitial) {
      Future.microtask(
        () =>
            ref
                .read(upcomingServiceViewModelProvider.notifier)
                .fetchUpcomingServices(),
      );
    }

    if (state is UpcomingServiceLoading || state is UpcomingServiceInitial) {
      return Column(
        children:
            List.generate(2, (_) => const _UpcomingServiceLoadingCard())
                .expand((widget) => [widget, const SizedBox(height: 12)])
                .toList()
              ..removeLast(),
      );
    }

    if (state is UpcomingServiceLoaded) {
      final services = state.services;
      if (services.isEmpty) {
        return const _UpcomingServiceEmpty();
      }
      final children =
          services
              .map((service) => _mapToBookingCard(context, service))
              .expand((widget) => [widget, const SizedBox(height: 12)])
              .toList();
      if (children.isNotEmpty) {
        children.removeLast();
      }
      return Column(children: children);
    }

    if (state is UpcomingServiceEmpty) {
      return const _UpcomingServiceEmpty();
    }

    if (state is UpcomingServiceError) {
      return ErrorStateWidget(
        onRetry:
            () =>
                ref
                    .read(upcomingServiceViewModelProvider.notifier)
                    .fetchUpcomingServices(),
      );
    }

    return const SizedBox.shrink();
  }
}

Widget _mapToBookingCard(BuildContext context, UpcomingServiceEntity service) {
  final s = S.of(context);
  final dateLabel = _formatDate(context, service);
  final timeLabel = _formatTime(service);
  final branchLabel = _valueOrFallback(
    service.branchLabel.isNotEmpty
        ? service.branchLabel
        : service.location ?? '',
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
  final packageCandidate =
      service.packageTitle.isNotEmpty
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
    onTap: () {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed('bookingDetailScreen', arguments: service);
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

class _UpcomingServiceLoadingCard extends StatelessWidget {
  const _UpcomingServiceLoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseFg = theme.colorScheme.onSurfaceVariant;
    final s = S.of(context);
    return Skeletonizer(
      child: BookingSummaryCard(
        carTitle: s.upcomingServicesLoadingVehicle,
        plate: s.upcomingServicesLoadingPlate,
        packageTitle: s.upcomingServicesLoadingPackage,
        dateLabel: s.upcomingServicesLoadingDate,
        timeLabel: s.upcomingServicesLoadingTime,
        locationLabel: s.upcomingServicesLoadingLocation,
        technicianLabel: s.upcomingServicesLoadingTechnician,
        statusText: s.upcomingServicesLoadingStatus,
        statusBg: theme.colorScheme.surfaceContainerHighest,
        statusFg: baseFg,
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
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
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

class _LoginPromptCard extends StatelessWidget {
  const _LoginPromptCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
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
                Icon(Icons.lock_outline, color: theme.colorScheme.primary),
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
    );
  }
}
