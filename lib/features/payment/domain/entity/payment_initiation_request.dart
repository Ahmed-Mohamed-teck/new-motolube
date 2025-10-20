class PaymentMetadata {
  const PaymentMetadata({
    required this.appVersion,
    required this.platform,
    required this.locale,
    required this.deviceId,
    required this.userAgent,
  });

  final String appVersion;
  final String platform;
  final String locale;
  final String deviceId;
  final String userAgent;
}

class PaymentInitiationRequest {
  const PaymentInitiationRequest({
    required this.amount,
    required this.currency,
    required this.orderId,
    required this.customerId,
    required this.customerEmail,
    required this.metadata,
    this.appliedCoupon,
    this.discount = 0,
  });

  final double amount;
  final String currency;
  final String orderId;
  final String customerId;
  final String customerEmail;
  final PaymentMetadata metadata;
  final String? appliedCoupon;
  final double discount;
}
