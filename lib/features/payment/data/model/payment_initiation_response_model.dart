import '../../domain/entity/payment_initiation_result.dart';

class PaymentInitiationResponseModel extends PaymentInitiationResult {
  PaymentInitiationResponseModel({
    required super.transactionId,
    required super.paymentUrl,
    required super.status,
    required super.createdAt,
    super.payFortParameters,
  });

  factory PaymentInitiationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentInitiationResponseModel(
      transactionId: json['transactionId'] as String? ?? '',
      paymentUrl: json['paymentUrl'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      payFortParameters: _parsePayfortParams(json['payFortParameters']),
    );
  }

  static Map<String, dynamic>? _parsePayfortParams(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value as Map);
    }
    return null;
  }
}
