import '../../domain/entity/payment_status_result.dart';

class PaymentStatusResponseModel extends PaymentStatusResult {
  PaymentStatusResponseModel({
    required super.transactionId,
    required super.status,
    super.responseCode,
    super.message,
  });

  factory PaymentStatusResponseModel.fromJson(Map<String, dynamic> json) {
    String _asString(dynamic value) => value is String
        ? value
        : value != null
            ? value.toString()
            : '';

    final status = _asString(json['status'] ?? json['paymentStatus']);
    final responseCode =
        _asString(json['responseCode'] ?? json['response_code']);
    final message = _asString(json['message'] ?? json['description']);
    final transactionId = _asString(json['transactionId'] ?? json['tid']);

    return PaymentStatusResponseModel(
      transactionId: transactionId,
      status: status,
      responseCode: responseCode.isNotEmpty ? responseCode : null,
      message: message.isNotEmpty ? message : null,
    );
  }
}
