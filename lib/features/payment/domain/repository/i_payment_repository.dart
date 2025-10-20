import '../entity/payment_initiation_request.dart';
import '../entity/payment_initiation_result.dart';

abstract class IPaymentRepository {
  Future<PaymentInitiationResult> initiatePayment(
    PaymentInitiationRequest request,
  );
}
