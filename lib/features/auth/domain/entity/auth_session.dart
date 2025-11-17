import 'user_type.dart';

class AuthSession {
  final String jwtToken;
  final String firebaseToken;
  final String fireBaseId;
  final String tokenType;
  final int expiresIn;
  final String oracleId;
  final String userName;
  final String userMobileNumber;
  final String? userEmail;
  final UserType userType;

  const AuthSession({
    required this.jwtToken,
    required this.firebaseToken,
    required this.fireBaseId,
    required this.tokenType,
    required this.expiresIn,
    required this.oracleId,
    required this.userName,
    required this.userMobileNumber,
    this.userEmail,
    required this.userType,
  });
}
