import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/payment_initiation_request.dart';
import '../../domain/entity/payment_initiation_result.dart';
import '../../domain/use_case/initiate_payment_use_case.dart';
import '../state/payment_state.dart';

class PaymentViewModel extends StateNotifier<PaymentState> {
  PaymentViewModel(this._initiatePaymentUseCase)
      : super(const PaymentInitial());

  final InitiatePaymentUseCase _initiatePaymentUseCase;

  Future<PaymentInitiationResult?> initiatePayment(
    PaymentInitiationRequest request,
  ) async {
    state = const PaymentLoading();
    try {
      final result = await _initiatePaymentUseCase(request: request);
      state = PaymentSuccess(result);
      return result;
    } catch (error) {
      state = PaymentFailure(
        error.toString().isNotEmpty
            ? error.toString()
            : 'Unable to initiate payment.',
      );
      return null;
    }
  }

  void reset() {
    state = const PaymentInitial();
  }
}
