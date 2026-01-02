import 'user_type.dart';

class User {
  final String oracleId;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  final UserType userType;
  final String fireBaseId;
  final String? customer_id;

  const User({
    required this.oracleId,
    this.firstName,
    this.lastName,
    this.name,
    required this.mobileNo,
    this.email,
    required this.isVerified,
    required this.userType,
    this.fireBaseId = '',
    this.customer_id = '',
  });
}
