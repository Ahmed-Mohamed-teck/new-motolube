import '../../domain/entity/user_type.dart';

class RegisterRequest {
  final String? email;
  final String mobileNumber;
  final String firstName;
  final String lastName;

  RegisterRequest({
    this.email,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'mobileNumber': mobileNumber,
    'firstName': firstName,
    'lastName': lastName,
  };
}
