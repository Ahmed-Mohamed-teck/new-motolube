import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entity/auth_exceptions.dart';
import '../../../domain/use_case/register_user_use_case.dart';
import '../../../domain/use_case/send_otp_use_case.dart';
import '../../../domain/use_case/verify_otp_use_case.dart';
import '../../provider/auth_providers.dart';
import '../../../../core/providers/secure_storage_provider.dart';
import '../../../../core/storage/secure_store.dart';
import 'auth_state.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final SendOtpUseCase _sendOtpUseCase;
  late final RegisterUserUseCase _registerUserUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final SecureStore _secureStore;

  String? _phone;
  String _otp = '';
  Timer? _timer;
  int _remaining = 0;
  int _expiresIn = 0;

  @override
  AuthState build() {
    _sendOtpUseCase = ref.read(sendOtpUseCaseProvider);
    _registerUserUseCase = ref.read(registerUserUseCaseProvider);
    _verifyOtpUseCase = ref.read(verifyOtpUseCaseProvider);
    _secureStore = ref.read(secureStoreProvider);
    return const IdleState();
  }

  void onOtpChanged(String otp) {
    _otp = otp;
  }

  Future<void> onLoginPressed(String phone) async {
    state = const CheckingState();
    _phone = phone;
    try {
      final info = await _sendOtpUseCase(phone);
      _startTimer(info.expiresIn);
      state = AwaitingOtpState(
        phone: phone,
        expiresIn: info.expiresIn,
        remainingSeconds: _remaining,
      );
    } on UnregisteredUserException {
      state = const RegistrationState();
    } catch (e) {
      state = ErrorState(e.toString());
    }
  }

  Future<void> onRegisterPressed({required String name, required String phone, String? email}) async {
    state = const CheckingState();
    try {
      await _registerUserUseCase(name: name, phone: phone, email: email);
      final info = await _sendOtpUseCase(phone);
      _phone = phone;
      _startTimer(info.expiresIn);
      state = AwaitingOtpState(
        phone: phone,
        expiresIn: info.expiresIn,
        remainingSeconds: _remaining,
      );
    } on UserAlreadyRegisteredException {
      final info = await _sendOtpUseCase(phone);
      _phone = phone;
      _startTimer(info.expiresIn);
      state = AwaitingOtpState(
        phone: phone,
        expiresIn: info.expiresIn,
        remainingSeconds: _remaining,
      );
    } catch (e) {
      state = ErrorState(e.toString());
    }
  }

  Future<void> onVerifyPressed() async {
    final phone = _phone;
    if (phone == null) return;
    state = VerifyingState(
      phone: phone,
      expiresIn: _expiresIn,
      remainingSeconds: _remaining,
    );
    try {
      final result = await _verifyOtpUseCase(phone: phone, otp: _otp);
      await _secureStore.saveAuth(
        jwtToken: result.tokens.jwtToken,
        firebaseToken: result.tokens.firebaseToken,
        tokenType: result.tokens.tokenType,
        expiresIn: result.tokens.expiresIn,
        userId: result.user.id,
        userName: result.user.name ?? '',
        userMobileNumber: result.user.mobileNumber,
        userEmail: result.user.email,
      );
      state = const IdleState();
    } on InvalidOtpException {
      state = AwaitingOtpState(
        phone: phone,
        expiresIn: _expiresIn,
        remainingSeconds: _remaining,
        errorMessage: 'Invalid or expired OTP',
      );
    } catch (e) {
      state = ErrorState('Verification failed');
    }
  }

  Future<void> onResendOtp() async {
    final phone = _phone;
    if (phone == null) return;
    await onLoginPressed(phone);
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    _expiresIn = seconds;
    _remaining = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remaining--;
      if (_remaining <= 0) {
        timer.cancel();
        _remaining = 0;
      }
      final current = state;
      if (current is AwaitingOtpState) {
        state = AwaitingOtpState(
          phone: current.phone,
          expiresIn: current.expiresIn,
          remainingSeconds: _remaining,
        );
      }
    });
  }
}
