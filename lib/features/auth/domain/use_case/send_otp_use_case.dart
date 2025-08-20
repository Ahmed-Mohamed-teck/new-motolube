import '../entity/otp_info.dart';
import '../repository/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);

  Future<OtpInfo> call(String phone) {
    return repository.sendOtp(phone);
  }
}
