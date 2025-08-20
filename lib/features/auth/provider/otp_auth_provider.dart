import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../../../core/providers/secure_storage_provider.dart';
import '../data/data_source/auth_remote_data_source.dart';
import '../data/repository/auth_repository.dart';
import '../domain/repository/i_auth_repository.dart';
import '../presentation/state/otp_login_state.dart';
import '../presentation/view_model/otp_login_notifier.dart';

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

final otpLoginNotifierProvider =
    StateNotifierProvider<OtpLoginNotifier, OtpLoginState>((ref) {
  return OtpLoginNotifier(
    ref.read(authRepositoryProvider),
    ref.read(secureStoreProvider),
  );
});
