import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/dio_provider.dart';
import '../data/data_source/auth_remote_data_source.dart';
import '../data/repository/auth_repository.dart';
import '../domain/repository/i_auth_repository.dart';
import '../domain/use_case/is_registered_user_use_case.dart';
import '../presentation/state/auth_flow_state.dart';
import '../presentation/state/auth_state.dart';
import '../presentation/state/login_phone_state.dart';
import '../presentation/state/otp_state.dart';
import '../presentation/state/register_state.dart';
import '../presentation/view_model/auth_flow_state_controller.dart';
import '../presentation/view_model/auth_view_model.dart';
import '../presentation/view_model/login_phone_view_model.dart';
import '../presentation/view_model/otp_view_model.dart';
import '../presentation/view_model/register_view_model.dart';

final authViewModelProvider =
StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(
    isRegisteredUserUseCase: ref.read(isRegisteredUserUseCaseProvider),
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSourceImpl>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider)); // Replace with the actual instantiation logic
});

final authRepositoryImplProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider), // Ensure this is properly instantiated
  ); // Ensure this is properly instantiated
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return ref.read(authRepositoryImplProvider);
});

final isRegisteredUserUseCaseProvider = Provider<IsRegisteredUserUseCase>(
      (ref) => IsRegisteredUserUseCase(ref.read(authRepositoryProvider)),
);





// //////////

final authFlowProvider =
StateNotifierProvider<AuthFlowController, AuthFlowState>((ref) {
  return AuthFlowController(ref);
});


final loginPhoneProvider =
StateNotifierProvider<LoginPhoneVM, LoginPhoneState>((ref) => LoginPhoneVM());

final registerProvider =
StateNotifierProvider<RegisterVM, RegisterState>((ref) => RegisterVM());

final otpProvider =
StateNotifierProvider<OtpVM, OtpState>((ref) => OtpVM(ref));

