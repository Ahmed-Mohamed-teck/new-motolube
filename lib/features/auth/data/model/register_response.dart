import '../../domain/entity/register_result.dart';

class RegisterResponse {
  final String message;

  RegisterResponse({
    required this.message,

  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    message: json['message'] as String,

  );

  RegisterResult toEntity() => RegisterResult(
    message: message,

  );
}