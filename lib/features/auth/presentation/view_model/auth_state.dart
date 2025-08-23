import 'package:newmotorlube/features/auth/domain/entity/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

class InitailAuthState extends AuthState{}


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

class AuthenticatingState extends AuthState{}

class AuthenticatedState extends AuthState {
  final String jwtToken;
  final String firebaseToken;
  final User user;
  const AuthenticatedState({
   required this.jwtToken,
    required this.firebaseToken,
    required this.user,
  });
}

class AuthenticationFailedState extends AuthState {
  final String message;
  const AuthenticationFailedState(this.message);
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class ErrorState extends AuthState {
  final String message;
  const ErrorState(this.message);
}