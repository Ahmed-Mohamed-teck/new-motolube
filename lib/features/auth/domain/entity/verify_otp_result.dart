import 'package:newmotorlube/features/auth/domain/entity/user_entity.dart';
import 'tokens.dart';

class VerifyOtpResult {
  final String message;
  final User user;
  final Tokens tokens;
  const VerifyOtpResult({
    required this.message,
    required this.user,
    required this.tokens,
  });
}