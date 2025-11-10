import 'user_type.dart';

class StoredAuth {
  final String jwtToken;
  final String firebaseToken;
  final String phoneNumber;
  final String oracleId;
  final UserType userType;

  const StoredAuth({
    required this.jwtToken,
    required this.firebaseToken,
    required this.phoneNumber,
    required this.oracleId,
    required this.userType,
  });
}
