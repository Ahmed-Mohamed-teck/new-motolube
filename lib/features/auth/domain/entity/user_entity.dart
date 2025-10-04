class User {
  final String oracleId;
  final String userId;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  final int userType;

  const User({
    required this.oracleId,
    required this.userId,
    this.name,
    required this.mobileNo,
    this.email,
    required this.isVerified,
    required this.userType,
  });
}
