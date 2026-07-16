import 'user_type.dart';

class User {
  final String oracleId;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  final UserType userType;
  final String fireBaseId;
  final String? customer_id;
  final String? photoBase64;

  const User({
    required this.oracleId,
    this.userId = '',
    this.firstName,
    this.lastName,
    this.name,
    required this.mobileNo,
    this.email,
    required this.isVerified,
    required this.userType,
    this.fireBaseId = '',
    this.customer_id = '',
    this.photoBase64,
  });

  User copyWith({String? email, String? photoBase64}) {
    return User(
      oracleId: oracleId,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      name: name,
      mobileNo: mobileNo,
      email: email,
      isVerified: isVerified,
      userType: userType,
      fireBaseId: fireBaseId,
      customer_id: customer_id,
      photoBase64: photoBase64 ?? this.photoBase64,
    );
  }
}
