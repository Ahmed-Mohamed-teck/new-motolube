import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/secure_storage.dart';
import 'package:newmotorlube/features/auth/domain/use_case/is_registered_user.dart';
import 'package:newmotorlube/features/auth/domain/use_case/log_out_use_case.dart';
import '../../../core/providers/dio_provider.dart';
import '../data/data_source/auth_remote_data_source.dart';
import '../data/data_source/i_auth_remote_data_source.dart';
import '../data/repository/auth_repository.dart';
import '../domain/repository/i_auth_repository.dart';
import '../domain/use_case/get_user_info_use_case.dart';
import '../domain/use_case/register_user_use_case.dart';
import '../domain/use_case/send_otp_use_case.dart';
import '../domain/use_case/verify_otp_use_case.dart';
import '../presentation/view_model/auth_state.dart';
import '../presentation/view_model/auth_view_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

final isRegisterUseCaseProvider = Provider<IsRegisteredUserUseCase>((ref) {
  return IsRegisteredUserUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCase = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(secureStoreProvider));
});


final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  return SendOtpUseCase(ref.read(authRepositoryProvider));
});

final registerUserUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  return RegisterUserUseCase(ref.read(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.read(authRepositoryProvider));
});

final getUserInfoUseCaseProvider = Provider<GetUserInfoUseCase>((ref) {
  return GetUserInfoUseCase(ref.read(authRepositoryProvider));
});

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
      () => AuthViewModel(),
);