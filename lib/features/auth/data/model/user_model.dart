import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    super.name,
    super.email,
    required super.mobileNo,
    super.photoUrl,
    required super.userType,
    required super.isEmergencyTech,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobileNo: json['mobileNo'],
      photoUrl: json['photoUrl'],
      userType: UserType.values[json['role'] as int],
      isEmergencyTech: json['isEmergencyTech'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNo': mobileNo,
      'photoUrl': photoUrl,
      'userType': UserType.values[userType.index],
      'isEmergencyTech': isEmergencyTech,
    };
  }
}