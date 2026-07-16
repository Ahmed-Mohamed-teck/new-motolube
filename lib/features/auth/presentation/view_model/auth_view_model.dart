import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/providers/secure_storage.dart';
import 'package:newmotorlube/core/storage/secure_store.dart';
import '../../domain/entity/auth_exception.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/use_case/get_stored_auth_use_case.dart';
import '../../domain/use_case/get_user_info_use_case.dart';
import '../../domain/use_case/log_out_use_case.dart';
import '../../domain/use_case/register_user_use_case.dart';
import '../../domain/use_case/save_auth_session_use_case.dart';
import '../../domain/use_case/send_otp_use_case.dart';
import '../../domain/use_case/update_user_profile_use_case.dart';
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
  late final UpdateUserProfileUseCase _updateUserProfileUseCase;
  late final SecureStore _secureStore;

  String? _phone;
  String _otp = '';
  Timer? _timer;
  int _remaining = 0;
  int _expiresIn = 0;
  int _operationId = 0;

  @override
  AuthState build() {
    _sendOtpUseCase = ref.read(sendOtpUseCaseProvider);
    _registerUserUseCase = ref.read(registerUserUseCaseProvider);
    _verifyOtpUseCase = ref.read(verifyOtpUseCaseProvider);
    _getUserInfoUseCase = ref.read(getUserInfoUseCaseProvider);
    _logoutUseCase = ref.read(logoutUseCaseProvider);
    _saveAuthSessionUseCase = ref.read(saveAuthSessionUseCaseProvider);
    _getStoredAuthUseCase = ref.read(getStoredAuthUseCaseProvider);
    _updateUserProfileUseCase = ref.read(updateUserProfileUseCaseProvider);
    _secureStore = ref.read(secureStoreProvider);
    ref.onDispose(() => _timer?.cancel());
    return InitailAuthState();
  }

  void onOtpChanged(String otp) {
    _otp = otp;
  }

  int _startOperation() => ++_operationId;

  bool _isCurrentOperation(int operationId) => operationId == _operationId;

  void _resetOtpFlow() {
    _timer?.cancel();
    _phone = null;
    _otp = '';
    _remaining = 0;
    _expiresIn = 0;
  }

  Future<void> skipAuthentication() async {
    final operationId = _startOperation();
    _resetOtpFlow();
    state = const UnauthenticatedState();
    await _logoutUseCase.call();
    if (!_isCurrentOperation(operationId)) return;
  }

  Future<void> onLoginPressed(String phone) async {
    final operationId = _startOperation();
    state = const CheckingState();
    _phone = phone;
    try {
      final isRegistered = await ref
          .read(isRegisterUseCaseProvider)
          .call(phone);
      if (!_isCurrentOperation(operationId)) return;
      if (isRegistered) {
        final info = await _sendOtpUseCase(phone);
        if (!_isCurrentOperation(operationId)) return;
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
      if (!_isCurrentOperation(operationId)) return;
      state = const RegistrationState();
    } catch (e) {
      if (!_isCurrentOperation(operationId)) return;
      state = ErrorState(e.toString());
    }
  }

  Future<void> onRegisterPressed({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
  }) async {
    final operationId = _startOperation();
    state = const CheckingState();
    try {
      await _registerUserUseCase(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
      );
      if (!_isCurrentOperation(operationId)) return;
      final info = await _sendOtpUseCase(phone);
      if (!_isCurrentOperation(operationId)) return;
      _phone = phone;
      _startTimer(info.expiresIn);
      state = AwaitingOtpState(
        phone: phone,
        expiresIn: info.expiresIn,
        remainingSeconds: _remaining,
      );
    } on UserAlreadyRegisteredException {
      if (!_isCurrentOperation(operationId)) return;
      final info = await _sendOtpUseCase(phone);
      if (!_isCurrentOperation(operationId)) return;
      _phone = phone;
      _startTimer(info.expiresIn);
      state = AwaitingOtpState(
        phone: phone,
        expiresIn: info.expiresIn,
        remainingSeconds: _remaining,
      );
    } catch (e) {
      if (!_isCurrentOperation(operationId)) return;
      state = ErrorState(e.toString());
    }
  }

  Future<void> onVerifyPressed() async {
    final phone = _phone;
    if (phone == null) return;
    final operationId = _startOperation();
    state = VerifyingState(
      phone: phone,
      expiresIn: _expiresIn,
      remainingSeconds: _remaining,
    );
    try {
      final result = await _verifyOtpUseCase(phone: phone, otp: _otp);
      if (!_isCurrentOperation(operationId)) return;
      await _saveAuthSessionUseCase(result);
      if (!_isCurrentOperation(operationId)) {
        await _logoutUseCase.call();
        return;
      }
      state = AuthenticatedState(
        jwtToken: result.tokens.jwtToken,
        firebaseToken: result.tokens.firebaseToken,
        user: User(
          oracleId: result.user.oracleId,
          userId: result.user.userId,
          firstName: result.user.firstName,
          lastName: result.user.lastName,
          name: result.user.name,
          mobileNo: result.user.mobileNo,
          email: result.user.email,
          isVerified: result.user.isVerified,
          userType: result.user.userType,
          fireBaseId: result.user.fireBaseId,
          customer_id: result.user.customer_id,
          photoBase64: result.user.photoBase64,
        ),
      );
    } on InvalidOtpException {
      if (!_isCurrentOperation(operationId)) return;
      state = AwaitingOtpState(
        phone: phone,
        expiresIn: _expiresIn,
        remainingSeconds: _remaining,
        errorMessage: 'Invalid or expired OTP',
      );
    } catch (e) {
      if (!_isCurrentOperation(operationId)) return;
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
          errorMessage: current.errorMessage,
        );
      }
    });
  }

  Future<void> authenticating() async {
    final operationId = _startOperation();
    state = AuthenticatingState();
    final stored = await _getStoredAuthUseCase();
    if (!_isCurrentOperation(operationId)) return;
    if (stored != null) {
      try {
        final user = await _getUserInfoUseCase.call(stored.phoneNumber);
        if (!_isCurrentOperation(operationId)) return;
        state = AuthenticatedState(
          jwtToken: stored.jwtToken,
          firebaseToken: stored.firebaseToken,
          user: User(
            oracleId: user.oracleId,
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            name: user.name,
            mobileNo: user.mobileNo,
            email: user.email,
            isVerified: user.isVerified,
            userType: user.userType,
            fireBaseId:
                user.fireBaseId.isNotEmpty
                    ? user.fireBaseId
                    : stored.fireBaseId,
            customer_id: user.customer_id,
            photoBase64: user.photoBase64,
          ),
        );
      } catch (e) {
        await _logoutUseCase.call();
        if (!_isCurrentOperation(operationId)) return;
        state = AuthenticationFailedState(appLang.authenticationErrorMessage);
      }
    } else {
      state = const UnauthenticatedState();
    }
  }

  Future<void> unAuthenticate() async {
    final operationId = _startOperation();
    _resetOtpFlow();
    await _logoutUseCase.call();
    if (!_isCurrentOperation(operationId)) return;
    state = const UnauthenticatedState();
  }

  Future<void> updateProfile({
    required String? email,
    required String photoBase64,
  }) async {
    final current = state;
    if (current is! AuthenticatedState) {
      throw StateError('The user must be authenticated to update a profile.');
    }

    await _updateUserProfileUseCase(
      oracleId: current.user.oracleId,
      fireBaseId: current.user.fireBaseId,
      photoBase64: photoBase64,
      email: email,
      userType: current.user.userType.value,
    );
    await _secureStore.updateUserEmail(email);

    if (!identical(state, current)) return;
    state = AuthenticatedState(
      jwtToken: current.jwtToken,
      firebaseToken: current.firebaseToken,
      user: current.user.copyWith(email: email, photoBase64: photoBase64),
    );
  }
}
