import '../../domain/entity/payment_initiation_request.dart';

class PaymentMetadataModel extends PaymentMetadata {
  const PaymentMetadataModel({
    required super.appVersion,
    required super.platform,
    required super.locale,
    required super.deviceId,
    required super.userAgent,
  });

  Map<String, dynamic> toJson() {
    return {
      'appVersion': appVersion,
      'platform': platform,
      'locale': locale,
      'deviceId': deviceId,
      'userAgent': userAgent,
    };
  }
}

class PaymentInitiationRequestModel extends PaymentInitiationRequest {
  const PaymentInitiationRequestModel({
    required super.amount,
    required super.currency,
    required super.orderId,
    required super.customerId,
    required super.customerEmail,
    required PaymentMetadataModel super.metadata,
    super.appliedCoupon,
    super.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'orderId': orderId,
      'customerId': customerId,
      'customerEmail': customerEmail,
      'metadata': (metadata as PaymentMetadataModel).toJson(),
      if (appliedCoupon != null) 'appliedCoupon': appliedCoupon,
      'discount': discount,
    };
  }
}
