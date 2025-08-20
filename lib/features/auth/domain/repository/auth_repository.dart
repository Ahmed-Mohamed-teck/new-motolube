import '../entity/otp_info.dart';
import '../entity/register_result.dart';
import '../entity/verify_otp_result.dart';

abstract class AuthRepository {
  Future<OtpInfo> sendOtp(String phone);
  Future<RegisterResult> register({required String name, required String phone, String? email});
  Future<VerifyOtpResult> verifyOtp({required String phone, required String otp});
}
