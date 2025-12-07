import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../data/data_source/i_payment_remote_data_source.dart';
import '../data/data_source/payment_remote_data_source.dart';
import '../data/repository/payment_repository.dart';
import '../domain/repository/i_payment_repository.dart';
import '../domain/use_case/initiate_payment_use_case.dart';
import '../domain/use_case/check_payment_status_use_case.dart';
import '../presentation/state/payment_state.dart';
import '../presentation/view_model/payment_view_model.dart';

final paymentRemoteDataSourceProvider =
    Provider<IPaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSource(ref.read(dioProvider));
});

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  return PaymentRepository(ref.read(paymentRemoteDataSourceProvider));
});

final initiatePaymentUseCaseProvider =
    Provider<InitiatePaymentUseCase>((ref) {
  return InitiatePaymentUseCase(ref.read(paymentRepositoryProvider));
});

final checkPaymentStatusUseCaseProvider =
    Provider<CheckPaymentStatusUseCase>((ref) {
  return CheckPaymentStatusUseCase(ref.read(paymentRepositoryProvider));
});

final paymentViewModelProvider =
    StateNotifierProvider<PaymentViewModel, PaymentState>((ref) {
  return PaymentViewModel(
    ref.read(initiatePaymentUseCaseProvider),
    ref.read(checkPaymentStatusUseCaseProvider),
  );
});
