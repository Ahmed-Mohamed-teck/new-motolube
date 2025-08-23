import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import '../../domain/entity/auth_exception.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/use_case/get_stored_auth_use_case.dart';
import '../../domain/use_case/get_user_info_use_case.dart';
import '../../domain/use_case/log_out_use_case.dart';
import '../../domain/use_case/register_user_use_case.dart';
import '../../domain/use_case/save_auth_session_use_case.dart';
import '../../domain/use_case/send_otp_use_case.dart';
import '../../domain/use_case/verify_otp_use_case.dart';
import '../../provider/auth_provider.dart';
import 'auth_state.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final SendOtpUseCase _sendOtpUseCase;
  late final RegisterUserUseCase _registerUserUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final GetUserInfoUseCase _getUserInfoUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final SaveAuthSessionUseCase _saveAuthSessionUseCase;
  late final GetStoredAuthUseCase _getStoredAuthUseCase;

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
    _getUserInfoUseCase = ref.read(getUserInfoUseCaseProvider);
    _logoutUseCase = ref.read(logoutUseCaseProvider);
    _saveAuthSessionUseCase = ref.read(saveAuthSessionUseCaseProvider);
    _getStoredAuthUseCase = ref.read(getStoredAuthUseCaseProvider);
    return InitailAuthState();
  }

  void onOtpChanged(String otp) {
    _otp = otp;
  }

  Future<void> onLoginPressed(String phone) async {
    state = const CheckingState();
    _phone = phone;
    try {
      final isRegistered = await ref.read(isRegisterUseCaseProvider).call(phone);
      if (isRegistered) {
        final info = await _sendOtpUseCase(phone);
        _startTimer(info.expiresIn);
        state = AwaitingOtpState(
          phone: phone,
          expiresIn: info.expiresIn,
          remainingSeconds: _remaining,
        );
      } else {
        state = RegistrationState();
      }
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
      await _saveAuthSessionUseCase(result);
      state = AuthenticatedState(
        jwtToken: result.tokens.jwtToken,
        firebaseToken: result.tokens.firebaseToken,
        user: User(
          userId: result.user.userId,
          name: result.user.name,
          mobileNo: result.user.mobileNo,
          email: result.user.email,
          isVerified: result.user.isVerified,
        ),
      );
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

  Future<void> authenticating() async {
    state = AuthenticatingState();
    final stored = await _getStoredAuthUseCase();
    if (stored != null) {
      try {
        final user = await _getUserInfoUseCase.call(stored.phoneNumber);
        state = AuthenticatedState(
          jwtToken: stored.jwtToken,
          firebaseToken: stored.firebaseToken,
          user: User(
            userId: user.userId,
            name: user.name,
            mobileNo: user.mobileNo,
            email: user.email,
            isVerified: user.isVerified,
          ),
        );
      } catch (e) {
        state = AuthenticationFailedState(appLang.authenticationErrorMessage);
      }
    } else {
      state = const UnauthenticatedState();
    }
  }

  Future<void> unAuthenticate() async {
    await _logoutUseCase.call();
    state = const UnauthenticatedState();
  }
}
