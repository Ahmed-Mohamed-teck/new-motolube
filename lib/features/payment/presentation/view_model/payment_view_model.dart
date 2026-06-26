import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/payment_initiation_request.dart';
import '../../domain/entity/payment_initiation_result.dart';
import '../../domain/entity/payment_status_result.dart';
import '../../domain/use_case/initiate_payment_use_case.dart';
import '../../domain/use_case/check_payment_status_use_case.dart';
import '../state/payment_state.dart';
import '../../../../core/providers/global_lang_provider.dart';

class PaymentViewModel extends StateNotifier<PaymentState> {
  PaymentViewModel(
    this._initiatePaymentUseCase,
    this._checkPaymentStatusUseCase,
  )
      : super(const PaymentInitial());

  final InitiatePaymentUseCase _initiatePaymentUseCase;
  final CheckPaymentStatusUseCase _checkPaymentStatusUseCase;

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
            : appLang.unableToInitiatePayment,
      );
      return null;
    }
  }

  Future<PaymentStatusResult> checkPaymentStatus(
    String transactionId,
  ) {
    return _checkPaymentStatusUseCase(transactionId: transactionId);
  }

  void reset() {
    state = const PaymentInitial();
  }
}
