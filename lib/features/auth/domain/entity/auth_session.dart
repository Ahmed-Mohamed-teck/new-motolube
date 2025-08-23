class AuthSession {
  final String jwtToken;
  final String firebaseToken;
  final String tokenType;
  final int expiresIn;
  final String userId;
  final String userName;
  final String userMobileNumber;
  final String? userEmail;

  const AuthSession({
    required this.jwtToken,
    required this.firebaseToken,
    required this.tokenType,
    required this.expiresIn,
    required this.userId,
    required this.userName,
    required this.userMobileNumber,
    this.userEmail,
  });
}
