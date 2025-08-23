
import '../../domain/entity/user_entity.dart';

class UserModel {
  final String userId;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  UserModel({
    required this.userId,
    this.name,
    required this.mobileNo,
    this.email,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['userId']??json['id'] as String,
    name: json['name'] as String?,
    mobileNo: json['mobileNo']??json['mobileNumber'] as String,
    email: json['email'] as String?,
    isVerified: json['isVerified'] as bool? ?? false,
  );

  User toEntity() => User(
    userId: userId,
    name: name,
    mobileNo: mobileNo,
    email: email,
    isVerified: isVerified,
  );
}