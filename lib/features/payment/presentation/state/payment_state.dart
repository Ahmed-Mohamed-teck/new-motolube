import '../../domain/entity/payment_initiation_result.dart';

abstract class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentSuccess extends PaymentState {
  const PaymentSuccess(this.result);

  final PaymentInitiationResult result;
}

class PaymentFailure extends PaymentState {
  const PaymentFailure(this.message);

  final String message;
}
