import '../../domain/entity/user_entity.dart';

class UserModel {
  final String oracleId;
  final String userId;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  final int userType;

  UserModel({
    required this.oracleId,
    required this.userId,
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
    name: json['name'] as String?,
    mobileNo: json['mobileNo'] ?? json['mobileNumber'] as String,
    email: json['email'] as String?,
    isVerified: json['isVerified'] as bool? ?? false,
    userType: json['userType'] as int? ?? 1,
  );

  User toEntity() => User(
    oracleId: oracleId,
    userId: userId,
    name: name,
    mobileNo: mobileNo,
    email: email,
    isVerified: isVerified,
    userType: userType,
  );
}
