import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/auth_exceptions.dart';
import '../../data/model/register_request.dart';
import '../../data/model/send_otp_request.dart';
import '../../data/model/verify_otp_request.dart';
import '../../data/model/verify_otp_response.dart';
import '../../domain/repository/i_auth_repository.dart';
import 'package:newmotorlube/core/storage/secure_store.dart';
import '../state/otp_login_state.dart';

class OtpLoginNotifier extends StateNotifier<OtpLoginState> {
  final IAuthRepository _repo;
  final SecureStore _store;
  Timer? _timer;

  OtpLoginNotifier(this._repo, this._store) : super(const OtpLoginState());

  void updatePhone(String value) => state = state.copyWith(phone: value);
  void updateName(String value) => state = state.copyWith(name: value);
  void updateOtp(String value) => state = state.copyWith(otp: value);

  bool _validPhone(String phone) => phone.startsWith('+9665') && phone.length == 13;

  Future<void> sendOtp() async {
    final phone = state.phone.trim();
    if (!_validPhone(phone)) {
      state = state.copyWith(errorMessage: 'Invalid phone number');
      return;
    }
    state = state.copyWith(status: OtpLoginStatus.checkingOrSendingOtp, errorMessage: null);
    try {
      final res = await _repo.sendOtp(SendOtpRequest(phone));
      _startTimer(res.expiresIn);
      state = state.copyWith(status: OtpLoginStatus.awaitingOtp);
    } on UnregisteredUserException {
      state = state.copyWith(status: OtpLoginStatus.registration);
    } catch (_) {
      state = state.copyWith(status: OtpLoginStatus.idle, errorMessage: 'Failed to send OTP');
    }
  }

  Future<void> register() async {
    final name = state.name.trim();
    if (name.isEmpty) {
      state = state.copyWith(errorMessage: 'Name required');
      return;
    }
    state = state.copyWith(status: OtpLoginStatus.registering, errorMessage: null);
    try {
      await _repo.register(RegisterRequest(
        email: null,
        isEmergencyTech: false,
        mobileNumber: state.phone,
        name: name,
        userType: 1,
      ));
      final otpRes = await _repo.sendOtp(SendOtpRequest(state.phone));
      _startTimer(otpRes.expiresIn);
      state = state.copyWith(status: OtpLoginStatus.awaitingOtp);
    } on UserAlreadyRegisteredException {
      final otpRes = await _repo.sendOtp(SendOtpRequest(state.phone));
      _startTimer(otpRes.expiresIn);
      state = state.copyWith(status: OtpLoginStatus.awaitingOtp);
    } catch (_) {
      state = state.copyWith(status: OtpLoginStatus.registration, errorMessage: 'Registration failed');
    }
  }

  Future<void> verifyOtp() async {
    final code = state.otp.trim();
    if (code.length != 6 || int.tryParse(code) == null) {
      state = state.copyWith(errorMessage: 'OTP must be 6 digits');
      return;
    }
    state = state.copyWith(status: OtpLoginStatus.verifyingOtp, errorMessage: null);
    try {
      final VerifyOtpResponse res =
          await _repo.verifyOtp(VerifyOtpRequest(mobileNumber: state.phone, otp: code));
      await _store.saveAuth(res);
      state = state.copyWith(status: OtpLoginStatus.idle, isAuthenticated: true);
    } on InvalidOtpException {
      state = state.copyWith(status: OtpLoginStatus.awaitingOtp, errorMessage: 'Invalid or expired OTP');
    } catch (_) {
      state = state.copyWith(status: OtpLoginStatus.awaitingOtp, errorMessage: 'Verification failed');
    }
  }

  Future<void> resendOtp() async {
    if (state.secondsRemaining > 0) return;
    try {
      final res = await _repo.sendOtp(SendOtpRequest(state.phone));
      _startTimer(res.expiresIn);
      state = state.copyWith(status: OtpLoginStatus.awaitingOtp);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to resend OTP');
    }
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    state = state.copyWith(secondsRemaining: seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.secondsRemaining - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(secondsRemaining: 0);
      } else {
        state = state.copyWith(secondsRemaining: remaining);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

