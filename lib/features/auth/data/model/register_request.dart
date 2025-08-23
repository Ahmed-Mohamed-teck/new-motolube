class RegisterRequest {
  final String? email;
  final bool isEmergencyTech;
  final String mobileNumber;
  final String name;
  final int userType;

  RegisterRequest({
    this.email,
    required this.isEmergencyTech,
    required this.mobileNumber,
    required this.name,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'isEmergencyTech': isEmergencyTech,
    'mobileNumber': mobileNumber,
    'name': name,
    'userType': userType,
  };
}