class Tokens {
  final String firebaseToken;
  final String jwtToken;
  final String tokenType;
  final int expiresIn;
  const Tokens({
    required this.firebaseToken,
    required this.jwtToken,
    required this.tokenType,
    required this.expiresIn,
  });
}
