import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widget/internal_app_bar.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../../payment/domain/entity/payment_initiation_request.dart';
import '../../../payment/presentation/screen/payment_webview_screen.dart';
import '../../../payment/presentation/state/payment_state.dart';
import '../../../payment/provider/payment_provider.dart';
import '../../domain/entity/upcoming_service_entity.dart';
import '../../../../core/utils/helper_fuc.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  const BookingDetailScreen({super.key, required this.service});

  final UpcomingServiceEntity service;

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState
    extends ConsumerState<BookingDetailScreen> {
  Future<void> _handlePayment() async {
    final request = _buildPaymentRequest();
    final result = await ref
        .read(paymentViewModelProvider.notifier)
        .initiatePayment(request);

    if (!mounted) {
      return;
    }

    if (result == null) {
      final state = ref.read(paymentViewModelProvider);
      if (state is PaymentFailure) {
        _showSnack(state.message);
      }
      return;
    }

    if (result.paymentUrl.isEmpty) {
      _showSnack('Missing payment URL. Please try again later.');
      ref.read(paymentViewModelProvider.notifier).reset();
      return;
    }

    final storedAuth = await ref
        .read(authLocalRepositoryProvider)
        .getStoredAuth();
    final bearerToken = storedAuth?.jwtToken.trim();

    final outcome =
        await Navigator.of(context).push<PaymentWebViewResult>(
      MaterialPageRoute(
        builder: (_) => PaymentWebViewScreen(
          paymentUrl: result.paymentUrl,
          payFortParameters: result.payFortParameters,
          bearerToken: bearerToken != null && bearerToken.isNotEmpty
              ? bearerToken
              : null,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    switch (outcome) {
      case PaymentWebViewResult.success:
        await _showStatusDialog(
          title: 'Payment Successful',
          message: 'Your payment has been completed successfully.',
        );
        break;
      case PaymentWebViewResult.failure:
        await _showStatusDialog(
          title: 'Payment Failed',
          message: 'The payment was not completed. Please try again.',
          isSuccess: false,
        );
        break;
      case PaymentWebViewResult.cancelled:
      case null:
        break;
    }

    if (mounted) {
      ref.read(paymentViewModelProvider.notifier).reset();
    }
  }

  PaymentInitiationRequest _buildPaymentRequest() {
    final service = widget.service;
    final srNumber = service.srNumber.trim();
    final orderId =
        srNumber.isNotEmpty
            ? srNumber
            : service.appointmentId.isNotEmpty
            ? service.appointmentId
            : 'order-${DateTime.now().millisecondsSinceEpoch}';

    final amount = service.srTotal > 0 ? service.srTotal : 0;
    final appliedCoupon = service.couponNumber.trim();

    return PaymentInitiationRequest(
      amount: amount.toDouble(),
      currency: 'SAR',
      orderId: orderId,
      customerId:
          service.appointmentId.isNotEmpty ? service.appointmentId : orderId,
      customerEmail: _resolveCustomerEmail(),
      metadata: const PaymentMetadata(
        appVersion: '1.0.0',
        platform: 'flutter',
        locale: 'en-US',
        deviceId: 'mobile-device',
        userAgent: 'newmotorlube-app',
      ),
      appliedCoupon: appliedCoupon.isNotEmpty ? appliedCoupon : null,
      discount: service.discount,
    );
  }

  String _resolveCustomerEmail() {
    final authState = ref.read(authViewModelProvider);
    if (authState is AuthenticatedState) {
      final email = authState.user.email?.trim();
      if (email != null && email.isNotEmpty) {
        return email;
      }
    }
    return 'customer@example.com';
  }

  Future<void> _showStatusDialog({
    required String title,
    required String message,
    bool isSuccess = true,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String message) {
    if (message.isEmpty) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  void _openChat() {
    final bookingId = _bookingIdForChat(widget.service);
    if (bookingId == null) {
      _showSnack('Missing booking id for chat.');
      return;
    }

    Navigator.of(context, rootNavigator: true).pushNamed(
      'chatScreen',
      arguments: bookingId,
    );
  }

  String? _bookingIdForChat(UpcomingServiceEntity service) {
    final candidates = [
      service.appointmentId,
      service.srNumber,
    ];
    for (final candidate in candidates) {
      final id = candidate.trim();
      if (id.isNotEmpty) return id;
    }
    return null;
  }

  int? _parseStatusId(String status) {
    final trimmed = status.trim();
    if (trimmed.isEmpty) return null;

    final mapped = getStatusIdFromStatusName(trimmed);
    if (mapped != 0) return mapped;

    final direct = int.tryParse(trimmed);
    if (direct != null) return direct;

    final match = RegExp(r'\d+').firstMatch(trimmed);
    return match != null ? int.tryParse(match.group(0)!) : null;
  }

  bool _shouldShowChatIcon(UpcomingServiceEntity service) {
    final statusId = _parseStatusId(service.status);
    if (statusId == null) return false;
    return statusId >= 1 && statusId <= 7;
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    final s = S.of(context);
    final paymentState = ref.watch(paymentViewModelProvider);
    final isProcessingPayment = paymentState is PaymentLoading;
    final carCandidate =
        service.carTitle.isNotEmpty ? service.carTitle : service.serviceName;
    final carTitle = _valueOrFallback(
      carCandidate,
      fallback: s.upcomingServicesVehiclePlaceholder,
    );
    final plate = _valueOrFallback(
      service.plateText,
      fallback: s.upcomingServicesPlateFallback,
    );
    final statusLabel = _statusLabel(context, service.status);
    final dateLabel = _formatDate(context, service);
    final timeLabel = _formatTime(service);
    final packageCandidate = service.packageTitle.isNotEmpty
        ? service.packageTitle
        : service.serviceName;
    final package = _valueOrFallback(
      packageCandidate,
      fallback: s.upcomingServicesServicePlaceholder,
    );
    final branch = _valueOrFallback(
      service.branchLabel.isNotEmpty ? service.branchLabel : service.location ?? '',
      fallback: s.upcomingServicesLocationFallback,
    );
    final technician = _valueOrFallback(
      service.technicianLabel,
      fallback: s.upcomingServicesTechnicianFallback,
    );
    final requiresPayment = _requiresPayment(service);
    final showChatIcon = _shouldShowChatIcon(service);

    return Scaffold(
      appBar: InternalAppBar(
        title: s.upcomingServicesBookingDetailsTitle,
        actions: [
          if (showChatIcon)
            IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: _openChat,
              tooltip: 'Chat',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderCard(
                title: carTitle,
                plate: plate,
                status: statusLabel,
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(s.upcomingServicesServicePackageLabel),
                    const SizedBox(height: 6),
                    Text(
                      package,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (dateLabel.isNotEmpty || timeLabel.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 24),
                      if (dateLabel.isNotEmpty)
                        _IconTextRow(
                          icon: Icons.event,
                          text: dateLabel,
                        ),
                      if (dateLabel.isNotEmpty && timeLabel.isNotEmpty)
                        const SizedBox(height: 8),
                      if (timeLabel.isNotEmpty)
                        _IconTextRow(
                          icon: Icons.access_time,
                          text: timeLabel,
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(s.upcomingServicesServiceLocationLabel),
                    const SizedBox(height: 6),
                    Text(
                      branch,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(s.upcomingServicesAssignedTechnicianLabel),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          child: Text(_initials(technician)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            technician,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (requiresPayment) ...[
                const SizedBox(height: 12),
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel('Checkout details'),
                      const SizedBox(height: 12),
                      _KeyValueRow(
                        label: 'Amount due',
                        value: _formatCurrency(service.srTotal),
                      ),
                      if (service.discount > 0) ...[
                        const SizedBox(height: 10),
                        _KeyValueRow(
                          label: 'Discount',
                          value: '-${_formatCurrency(service.discount)}',
                        ),
                      ],
                      if (service.couponNumber.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _KeyValueRow(
                          label: 'Applied coupon',
                          value: service.couponNumber.trim(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isProcessingPayment ? null : _handlePayment,
                  child: isProcessingPayment
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Pay Now'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.title,
    required this.plate,
    required this.status,
  });

  final String title;
  final String plate;
  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _statusColors(context, status);
    final theme = Theme.of(context);
    final plateLabel = S.of(context).plate;

    return _SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.directions_car, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '$plateLabel: $plate',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: theme.textTheme.labelMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.7,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
      ),
    );
  }
}

class _IconTextRow extends StatelessWidget {
  const _IconTextRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

String _formatDate(BuildContext context, UpcomingServiceEntity service) {
  final date = service.appointmentDate;
  if (date != null) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  final raw = service.appointmentDateText.trim();
  if (raw.isEmpty) {
    return S.of(context).upcomingServicesDateFallback;
  }
  try {
    final parsed = DateTime.parse(raw);
    return DateFormat('dd MMM yyyy').format(parsed);
  } catch (_) {
    return raw;
  }
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

String _valueOrFallback(String? value, {required String fallback}) {
  final trimmed = value?.trim() ?? '';
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

(Color, Color) _statusColors(BuildContext context, String status) {
  final lower = status.toLowerCase();
  final scheme = Theme.of(context).colorScheme;
  if (lower.contains('expired') || lower.contains('cancel')) {
    return (scheme.error.withOpacity(0.12), scheme.error);
  }
  if (lower.contains('upcoming') || lower.contains('schedule') || lower.contains('book')) {
    return (Colors.green.withOpacity(0.12), Colors.green.shade700);
  }
  if (lower.contains('pending')) {
    return (Colors.amber.withOpacity(0.16), Colors.amber.shade800);
  }
  if (lower.contains('complete')) {
    return (scheme.primary.withOpacity(0.1), scheme.primary);
  }
  return (scheme.surfaceVariant, scheme.onSurfaceVariant);
}

String _initials(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return '?';
  }
  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

bool _requiresPayment(UpcomingServiceEntity service) {
  final label = service.status.toLowerCase();
  final isComplete = label.contains('completedjobcard');
  return isComplete ;
}

String _formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    symbol: 'SAR ',
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
