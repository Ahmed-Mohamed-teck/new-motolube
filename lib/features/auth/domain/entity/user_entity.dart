class UserEntity{
  String id;
  String? name;
  String? email;
  bool isEmergencyTech;
  String? photoUrl;
  UserType userType;
  String mobileNo;

  UserEntity({
    required this.id,
    required this.userType,
    required this.isEmergencyTech,
    required this.mobileNo,
    this.name,
    this.email,
    this.photoUrl,
  });
}

enum UserType{
  customer,
  technician,
  manager,
}