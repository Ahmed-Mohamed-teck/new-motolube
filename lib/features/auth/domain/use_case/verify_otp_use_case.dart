import '../entity/verify_otp_result.dart';
import '../repository/i_auth_repository.dart';

class VerifyOtpUseCase {
  final IAuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<VerifyOtpResult> call({required String phone, required String otp}) {
    return repository.verifyOtp(phone: phone, otp: otp);
  }
}