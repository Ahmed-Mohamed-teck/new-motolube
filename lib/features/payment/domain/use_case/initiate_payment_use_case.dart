import '../entity/payment_initiation_request.dart';
import '../entity/payment_initiation_result.dart';
import '../repository/i_payment_repository.dart';

class InitiatePaymentUseCase {
  InitiatePaymentUseCase(this._repository);

  final IPaymentRepository _repository;

  Future<PaymentInitiationResult> call({
    required PaymentInitiationRequest request,
  }) {
    return _repository.initiatePayment(request);
  }
}
