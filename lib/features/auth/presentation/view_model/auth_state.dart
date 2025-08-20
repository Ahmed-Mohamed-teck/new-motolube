sealed class AuthState {
  const AuthState();
}

class IdleState extends AuthState {
  const IdleState();
}

class CheckingState extends AuthState {
  const CheckingState();
}

class RegistrationState extends AuthState {
  const RegistrationState();
}

class AwaitingOtpState extends AuthState {
  final String phone;
  final int expiresIn;
  final int remainingSeconds;
  final String? errorMessage;
  const AwaitingOtpState({
    required this.phone,
    required this.expiresIn,
    required this.remainingSeconds,
    this.errorMessage,
  });
}

class VerifyingState extends AuthState {
  final String phone;
  final int expiresIn;
  final int remainingSeconds;
  const VerifyingState({
    required this.phone,
    required this.expiresIn,
    required this.remainingSeconds,
  });
}

class ErrorState extends AuthState {
  final String message;
  const ErrorState(this.message);
}
