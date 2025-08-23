import '../entity/auth_session.dart';
import '../entity/verify_otp_result.dart';
import '../repository/i_auth_local_repository.dart';

class SaveAuthSessionUseCase {
  final IAuthLocalRepository repository;
  SaveAuthSessionUseCase(this.repository);

  Future<void> call(VerifyOtpResult result) {
    final session = AuthSession(
      jwtToken: result.tokens.jwtToken,
      firebaseToken: result.tokens.firebaseToken,
      tokenType: result.tokens.tokenType,
      expiresIn: result.tokens.expiresIn,
      userId: result.user.userId,
      userName: result.user.name ?? '',
      userMobileNumber: result.user.mobileNo,
      userEmail: result.user.email,
    );
    return repository.saveAuthSession(session);
  }
}
