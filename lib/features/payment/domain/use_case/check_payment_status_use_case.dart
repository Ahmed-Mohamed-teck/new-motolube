import '../entity/payment_status_result.dart';
import '../repository/i_payment_repository.dart';

class CheckPaymentStatusUseCase {
  CheckPaymentStatusUseCase(this._repository);

  final IPaymentRepository _repository;

  Future<PaymentStatusResult> call({
    required String transactionId,
  }) {
    return _repository.getPaymentStatus(transactionId);
  }
}
