class User {
  final String oracleId;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  final int userType;

  const User({
    required this.oracleId,
    required this.userId,
    this.firstName,
    this.lastName,
    this.name,
    required this.mobileNo,
    this.email,
    required this.isVerified,
    required this.userType,
  });
}
