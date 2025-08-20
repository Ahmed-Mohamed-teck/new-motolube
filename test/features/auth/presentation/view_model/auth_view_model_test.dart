import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:newmotorlube/core/storage/secure_store.dart';
import 'package:newmotorlube/features/auth/domain/entity/auth_exceptions.dart';
import 'package:newmotorlube/features/auth/domain/entity/otp_info.dart';
import 'package:newmotorlube/features/auth/domain/use_case/register_user_use_case.dart';
import 'package:newmotorlube/features/auth/domain/use_case/send_otp_use_case.dart';
import 'package:newmotorlube/features/auth/domain/use_case/verify_otp_use_case.dart';
import 'package:newmotorlube/features/auth/provider/auth_providers.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';

class _MockSendOtp extends Mock implements SendOtpUseCase {}
class _MockRegister extends Mock implements RegisterUserUseCase {}
class _MockVerify extends Mock implements VerifyOtpUseCase {}
class _MockStore extends Mock implements SecureStore {}

void main() {
  test('login success leads to awaitingOtp', () async {
    final sendOtp = _MockSendOtp();
    when(() => sendOtp('+123'))
        .thenAnswer((_) async => OtpInfo(mobileNumber: '+123', expiresIn: 60, message: ''));

    final container = ProviderContainer(overrides: [
      sendOtpUseCaseProvider.overrideWithValue(sendOtp),
      registerUserUseCaseProvider.overrideWithValue(_MockRegister()),
      verifyOtpUseCaseProvider.overrideWithValue(_MockVerify()),
      secureStoreProvider.overrideWithValue(_MockStore()),
    ]);

    final vm = container.read(authViewModelProvider.notifier);
    await vm.onLoginPressed('+123');

    final state = container.read(authViewModelProvider);
    expect(state is AwaitingOtpState, true);
  });

  test('unregistered user switches to registration', () async {
    final sendOtp = _MockSendOtp();
    when(() => sendOtp('+123')).thenThrow(UnregisteredUserException());

    final container = ProviderContainer(overrides: [
      sendOtpUseCaseProvider.overrideWithValue(sendOtp),
      registerUserUseCaseProvider.overrideWithValue(_MockRegister()),
      verifyOtpUseCaseProvider.overrideWithValue(_MockVerify()),
      secureStoreProvider.overrideWithValue(_MockStore()),
    ]);

    final vm = container.read(authViewModelProvider.notifier);
    await vm.onLoginPressed('+123');

    final state = container.read(authViewModelProvider);
    expect(state is RegistrationState, true);
  });
}
