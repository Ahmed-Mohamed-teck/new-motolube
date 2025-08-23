class StoredAuth {
  final String jwtToken;
  final String firebaseToken;
  final String phoneNumber;

  const StoredAuth({
    required this.jwtToken,
    required this.firebaseToken,
    required this.phoneNumber,
  });
}
