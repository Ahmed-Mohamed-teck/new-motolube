import '../../domain/entity/user_entity.dart';

class UserModel {
  final String oracleId;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  final int userType;

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    // oracleId: json['oracleId'] as String,
    // todo temporary fix for missing oracleId from login response
    oracleId: "761369",
    userId: json['userId'] ?? json['id'] as String,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    name: _resolveName(
      json['name'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
    ),
    mobileNo: json['mobileNo'] ?? json['mobileNumber'] as String,
    email: json['email'] as String?,
    isVerified: json['isVerified'] as bool? ?? false,
    userType: json['userType'] as int? ?? 1,
  );

  User toEntity() => User(
    oracleId: oracleId,
    userId: userId,
    firstName: firstName,
    lastName: lastName,
    name: name,
    mobileNo: mobileNo,
    email: email,
    isVerified: isVerified,
    userType: userType,
  );
}

String? _resolveName(String? name, String? firstName, String? lastName) {
  if (name != null && name.isNotEmpty) {
    return name;
  }

  final buffer = StringBuffer();
  if (firstName != null && firstName.isNotEmpty) {
    buffer.write(firstName);
  }
  if (lastName != null && lastName.isNotEmpty) {
    if (buffer.isNotEmpty) {
      buffer.write(' ');
    }
    buffer.write(lastName);
  }

  return buffer.isEmpty ? null : buffer.toString();
}
