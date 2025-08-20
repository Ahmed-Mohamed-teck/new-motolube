import 'tokens_model.dart';

class VerifyOtpResponse {
  final String message;
  final User user;
  final TokensModel tokens;
  VerifyOtpResponse({required this.message, required this.user, required this.tokens});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
        message: json['message'] as String,
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        tokens: TokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
      );
}

class User {
  final String id;
  final String? name;
  final String mobileNumber;
  final String? email;
  final bool isVerified;
  User({
    required this.id,
    this.name,
    required this.mobileNumber,
    this.email,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String?,
        mobileNumber: json['mobileNumber'] as String,
        email: json['email'] as String?,
        isVerified: json['isVerified'] as bool? ?? false,
      );
}
