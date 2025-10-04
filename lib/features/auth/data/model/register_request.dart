class RegisterRequest {
  final String? email;
  final bool isEmergencyTech;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final int userType;

  RegisterRequest({
    this.email,
    required this.isEmergencyTech,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'isEmergencyTech': isEmergencyTech,
    'mobileNumber': mobileNumber,
    'firstName': firstName,
    'lastName': lastName,
    'userType': userType,
  };
}
