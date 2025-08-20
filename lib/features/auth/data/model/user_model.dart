import '../../domain/entity/user.dart';

class UserModel {
  final String id;
  final String? name;
  final String mobileNumber;
  final String? email;
  final bool isVerified;
  UserModel({
    required this.id,
    this.name,
    required this.mobileNumber,
    this.email,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String?,
        mobileNumber: json['mobileNumber'] as String,
        email: json['email'] as String?,
        isVerified: json['isVerified'] as bool? ?? false,
      );

  User toEntity() => User(
        id: id,
        name: name,
        mobileNumber: mobileNumber,
        email: email,
        isVerified: isVerified,
      );
}
