import '../model/payment_initiation_request_model.dart';
import '../model/payment_initiation_response_model.dart';
import '../model/payment_status_response_model.dart';

abstract class IPaymentRemoteDataSource {
  Future<PaymentInitiationResponseModel> initiatePayment(
    PaymentInitiationRequestModel request,
  );

  Future<PaymentStatusResponseModel> getPaymentStatus(String transactionId);
}
