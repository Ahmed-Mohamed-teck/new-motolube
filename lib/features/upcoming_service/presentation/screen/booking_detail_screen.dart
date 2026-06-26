import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/widget/internal_app_bar.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../../payment/domain/entity/payment_initiation_request.dart';
import '../../../payment/presentation/screen/payment_webview_screen.dart';
import '../../../payment/presentation/state/payment_state.dart';
import '../../../payment/provider/payment_provider.dart';
import '../../../technician/provider/technician_provider.dart';
import '../../../technician/domain/entity/booking_status.dart';
import '../../domain/entity/upcoming_service_entity.dart';
import '../../provider/upcoming_service_provider.dart';
import '../view_model/upcoming_service_action_state.dart';
import '../../../../core/utils/helper_fuc.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  const BookingDetailScreen({super.key, required this.service});

  final UpcomingServiceEntity service;

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

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
      _showSnack(S.of(context).missingPaymentUrlMessage);
      ref.read(paymentViewModelProvider.notifier).reset();
      return;
    }

    final storedAuth =
        await ref.read(authLocalRepositoryProvider).getStoredAuth();
    final bearerToken = storedAuth?.jwtToken.trim();

    final outcome = await Navigator.of(context).push<PaymentWebViewResult>(
      MaterialPageRoute(
        builder:
            (_) => PaymentWebViewScreen(
              paymentUrl: result.paymentUrl,
              payFortParameters: result.payFortParameters,
              bearerToken:
                  bearerToken != null && bearerToken.isNotEmpty
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
          title: S.of(context).paymentSuccessfulTitle,
          message: S.of(context).paymentCompletedMessage,
        );
        break;
      case PaymentWebViewResult.failure:
        await _showStatusDialog(
          title: S.of(context).paymentFailedTitle,
          message: S.of(context).paymentNotCompletedMessage,
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
    final appointmentId = service.appointmentId.trim();
    final bookingId = appointmentId.isNotEmpty ? appointmentId : null;
    final orderId =
        srNumber.isNotEmpty
            ? srNumber
            : appointmentId.isNotEmpty
            ? appointmentId
            : 'order-${DateTime.now().millisecondsSinceEpoch}';

    final amount = service.srTotal > 0 ? service.srTotal : 0;
    final appliedCoupon = service.couponNumber.trim();

    return PaymentInitiationRequest(
      amount: amount.toDouble(),
      currency: 'SAR',
      bookingId: bookingId,
      srNumber: srNumber,
      orderId: orderId,
      customerId: appointmentId.isNotEmpty ? appointmentId : orderId,
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
              child: Text(S.of(context).okButtonLabel),
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
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openChat() {
    final s = S.of(context);
    final bookingId = _bookingIdForChat(widget.service);
    if (bookingId == null) {
      _showSnack(s.chatMissingBookingId);
      return;
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('chatScreen', arguments: bookingId);
  }

  Future<void> _confirmCancel(String bookingId, String statusId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).cancelAppointmentTitle),
          content: Text(S.of(context).cancelAppointmentConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).noButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.of(context).yesCancelButtonLabel),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await ref
          .read(upcomingServiceActionViewModelProvider.notifier)
          .cancelAppointment(bookingId: bookingId, statusId: statusId);
    }
  }

  String? _bookingIdForChat(UpcomingServiceEntity service) {
    final candidates = [service.appointmentId, service.srNumber];
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
    ref.listen<UpcomingServiceActionState>(
      upcomingServiceActionViewModelProvider,
      (prev, next) {
        if (!mounted) return;
        if (next is UpcomingServiceActionSuccess) {
          _showSnack(S.of(context).appointmentCancelledSuccessfully);
          Navigator.of(context).pop(true);
          ref.read(upcomingServiceActionViewModelProvider.notifier).reset();
        } else if (next is UpcomingServiceActionError) {
          _showSnack(next.message);
          ref.read(upcomingServiceActionViewModelProvider.notifier).reset();
        }
      },
    );
    final service = widget.service;
    final s = S.of(context);
    final statusesAsync = ref.watch(technicianBookingStatusesProvider);
    final cancelStatusId = statusesAsync.maybeWhen(
      data: (list) {
        final match = list.firstWhere(
          (item) => item.label.toLowerCase().contains('cancel'),
          orElse: () => const TechnicianBookingStatus(),
        );
        return match.label.isNotEmpty ? match.code : null;
      },
      orElse: () => null,
    );
    final actionState = ref.watch(upcomingServiceActionViewModelProvider);
    final isCancelling = actionState is UpcomingServiceActionLoading;
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
    final packageCandidate =
        service.packageTitle.isNotEmpty
            ? service.packageTitle
            : service.serviceName;
    final package = _valueOrFallback(
      packageCandidate,
      fallback: s.upcomingServicesServicePlaceholder,
    );
    final branch = _valueOrFallback(
      service.branchLabel.isNotEmpty
          ? service.branchLabel
          : service.location ?? '',
      fallback: s.upcomingServicesLocationFallback,
    );
    final technician = _valueOrFallback(
      service.technicianLabel,
      fallback: s.upcomingServicesTechnicianFallback,
    );
    final requiresPayment = _requiresPayment(service);
    final showChatIcon = _shouldShowChatIcon(service);
    final statusLower = service.status.toLowerCase();
    final statusId = _parseStatusId(service.status);
    final canCancel =
        cancelStatusId != null &&
        service.appointmentId.trim().isNotEmpty &&
        !statusLower.contains('openJobCard') &&
        !statusLower.contains('cancel') &&
        (statusId == null || statusId < 6);

    return Scaffold(
      appBar: InternalAppBar(
        title: s.upcomingServicesBookingDetailsTitle,
        actions: [
          if (showChatIcon)
            IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: _openChat,
              tooltip: s.chatTitle,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderCard(title: carTitle, plate: plate, status: statusLabel),
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
                        _IconTextRow(icon: Icons.event, text: dateLabel),
                      if (dateLabel.isNotEmpty && timeLabel.isNotEmpty)
                        const SizedBox(height: 8),
                      if (timeLabel.isNotEmpty)
                        _IconTextRow(icon: Icons.access_time, text: timeLabel),
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
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
                      _SectionLabel(S.of(context).checkoutDetailsLabel),
                      const SizedBox(height: 12),
                      _KeyValueRow(
                        label: S.of(context).amountDueLabel,
                        value: _formatCurrency(service.srTotal),
                      ),
                      if (service.discount > 0) ...[
                        const SizedBox(height: 10),
                        _KeyValueRow(
                          label: S.of(context).discountLabel,
                          value: '-${_formatCurrency(service.discount)}',
                        ),
                      ],
                      if (service.couponNumber.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _KeyValueRow(
                          label: S.of(context).appliedCouponLabel,
                          value: service.couponNumber.trim(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _AcceptedPaymentLogos(),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: isProcessingPayment ? null : _handlePayment,
                  child:
                      isProcessingPayment
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(S.of(context).payNowButtonLabel),
                ),
              ],
              const SizedBox(height: 12),
              if (canCancel) ...[
                OutlinedButton.icon(
                  onPressed:
                      isCancelling
                          ? null
                          : () {
                            final bookingId = service.appointmentId.trim();
                            final statusId = cancelStatusId!;
                            _confirmCancel(bookingId, statusId);
                          },
                  icon:
                      isCancelling
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                  label: Text(
                    isCancelling
                        ? S.of(context).cancellingEllipsis
                        : S.of(context).cancelAppointmentButtonLabel,
                    style: const TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ] else if (statusLower.contains('open job card')) ...[
                Text(
                  S.of(context).cannotCancelAfterJobCardOpened,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ] else if (cancelStatusId == null && statusesAsync.isLoading) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              ] else if (cancelStatusId == null) ...[
                Text(
                  S.of(context).cancellationStatusUnavailable,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.orange),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AcceptedPaymentLogos extends StatelessWidget {
  const _AcceptedPaymentLogos();

  static const _logos = [
    (path: 'assets/svg/mada-logo.svg', semanticLabel: 'Mada', width: 70.0),
    (path: 'assets/svg/visa-logo.svg', semanticLabel: 'Visa', width: 70.0),
    (
      path: 'assets/svg/master-logo.svg',
      semanticLabel: 'Mastercard',
      width: 58.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Accepted payment methods: Mada, Visa, Mastercard',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children:
              _logos
                  .map(
                    (logo) => SizedBox(
                      width: 78,
                      height: 34,
                      child: Center(
                        child: SvgPicture.asset(
                          logo.path,
                          width: logo.width,
                          height: 28,
                          fit: BoxFit.contain,
                          semanticsLabel: logo.semanticLabel,
                        ),
                      ),
                    ),
                  )
                  .toList(),
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
      child: Padding(padding: const EdgeInsets.all(16), child: child),
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
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
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
  if (lower.contains('upcoming') ||
      lower.contains('schedule') ||
      lower.contains('book')) {
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
  return isComplete;
}

String _formatCurrency(double amount) {
  final formatter = NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2);
  return formatter.format(amount);
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

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
