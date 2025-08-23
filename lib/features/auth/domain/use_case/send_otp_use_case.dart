import '../entity/otp_info.dart';
import '../repository/i_auth_repository.dart';

class SendOtpUseCase {
  final IAuthRepository repository;
  SendOtpUseCase(this.repository);

  Future<OtpInfo> call(String phone) {
    return repository.sendOtp(phone);
  }
}