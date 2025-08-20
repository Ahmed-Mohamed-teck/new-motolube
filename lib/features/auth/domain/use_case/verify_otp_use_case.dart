import '../entity/verify_otp_result.dart';
import '../repository/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<VerifyOtpResult> call({required String phone, required String otp}) {
    return repository.verifyOtp(phone: phone, otp: otp);
  }
}
