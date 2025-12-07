class PaymentStatusResult {
  const PaymentStatusResult({
    required this.transactionId,
    required this.status,
    this.responseCode,
    this.message,
  });

  final String transactionId;
  final String status;
  final String? responseCode;
  final String? message;

  bool get isSuccess {
    final normalizedStatus = status.toLowerCase().trim();
    return normalizedStatus == 'success' || responseCode == '14000';
  }
}
