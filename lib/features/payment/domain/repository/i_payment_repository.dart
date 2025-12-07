import '../entity/payment_initiation_request.dart';
import '../entity/payment_initiation_result.dart';
import '../entity/payment_status_result.dart';

abstract class IPaymentRepository {
  Future<PaymentInitiationResult> initiatePayment(
    PaymentInitiationRequest request,
  );

  Future<PaymentStatusResult> getPaymentStatus(String transactionId);
}
