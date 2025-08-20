import '../../domain/entity/verify_otp_result.dart';
import 'tokens_model.dart';
import 'user_model.dart';

class VerifyOtpResponse {
  final String message;
  final UserModel user;
  final TokensModel tokens;
  VerifyOtpResponse({
    required this.message,
    required this.user,
    required this.tokens,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
        message: json['message'] as String,
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        tokens: TokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
      );

  VerifyOtpResult toEntity() => VerifyOtpResult(
        message: message,
        user: user.toEntity(),
        tokens: tokens.toEntity(),
      );
}
