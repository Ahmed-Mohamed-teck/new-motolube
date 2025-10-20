class PaymentInitiationResult {
  const PaymentInitiationResult({
    required this.transactionId,
    required this.paymentUrl,
    required this.status,
    required this.createdAt,
    this.payFortParameters,
  });

  final String transactionId;
  final String paymentUrl;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic>? payFortParameters;
}
