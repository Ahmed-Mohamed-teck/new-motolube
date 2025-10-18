import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:newmotorlube/features/home/presentaion/screen/base_home_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      if (next is UnauthenticatedState) {
        ref.invalidate(upcomingServiceViewModelProvider);
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final state = ref.watch(upcomingServiceViewModelProvider);

    if (authState is AuthenticatedState && state is UpcomingServiceInitial) {
      Future.microtask(
        () => ref
            .read(upcomingServiceViewModelProvider.notifier)
            .fetchUpcomingServices(),
      );
    }

    if (authState is UnauthenticatedState) {
      return _LoginPromptCard(
        onTap: () {
          ref.read(currentNavBottomIndexProvider.notifier).state = 4;
        },
      );
    }

    if (state is UpcomingServiceLoading || state is UpcomingServiceInitial) {
      return Column(
        children: List.generate(
          2,
          (_) => const _UpcomingServiceLoadingCard(),
        ).expand((widget) => [widget, const SizedBox(height: 12)]).toList()
          ..removeLast(),
      );
    }

    if (state is UpcomingServiceLoaded) {
      final services = state.services;
      if (services.isEmpty) {
        return const _UpcomingServiceEmpty();
      }
      final children = services
          .map(_mapToBookingCard)
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
      return _UpcomingServiceErrorCard(message: state.message);
    }

    return const SizedBox.shrink();
  }
}

BookingSummaryCard _mapToBookingCard(UpcomingServiceEntity service) {
  final dateLabel = _formatDate(service);
  final timeLabel = _formatTime(service);
  final branchLabel = _valueOrFallback(
    service.branchLabel.isNotEmpty ? service.branchLabel : service.location ?? '',
    fallback: 'Location to be confirmed',
  );
  final technicianLabel = _valueOrFallback(
    service.technicianLabel,
    fallback: 'Technician to be assigned',
  );
  final plateText = _valueOrFallback(
    service.plateText,
    fallback: 'Plate unavailable',
  );
  final carTitle = _valueOrFallback(
    service.carTitle,
    fallback: service.serviceName,
  );
  final package = _valueOrFallback(
    service.packageTitle,
    fallback: service.serviceName,
  );
  final status = service.status.trim().isNotEmpty ? service.status : 'Pending';
  final statusColors = _statusColorsForStatus(status);

  return BookingSummaryCard(
    carTitle: carTitle,
    plate: plateText,
    packageTitle: package,
    dateLabel: dateLabel,
    timeLabel: timeLabel,
    locationLabel: branchLabel,
    technicianLabel: technicianLabel,
    statusText: status,
    statusBg: statusColors.$1,
    statusFg: statusColors.$2,
  );
}

String _formatDate(UpcomingServiceEntity service) {
  final date = service.appointmentDate;
  if (date != null) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  final raw = service.appointmentDateText.trim();
  if (raw.isNotEmpty) {
    return raw;
  }
  return 'Date to be confirmed';
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
    return Skeletonizer(
      child: BookingSummaryCard(
        carTitle: 'Loading vehicle',
        plate: '0000 AAA',
        packageTitle: 'Loading package title',
        dateLabel: '00 Mon 0000',
        timeLabel: '00:00 AM',
        locationLabel: 'Loading location',
        technicianLabel: 'Loading technician',
        statusText: 'Loading',
        statusBg: theme.colorScheme.surfaceVariant,
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
                'No upcoming services scheduled.',
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
                'Unable to load upcoming services.\n$message',
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
                    'Log in to view your upcoming services.',
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
                child: const Text('Log in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
