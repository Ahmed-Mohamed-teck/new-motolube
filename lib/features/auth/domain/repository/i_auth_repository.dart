import '../../data/model/register_request.dart';
import '../../data/model/register_response.dart';
import '../../data/model/send_otp_request.dart';
import '../../data/model/send_otp_response.dart';
import '../../data/model/verify_otp_request.dart';
import '../../data/model/verify_otp_response.dart';

abstract class IAuthRepository {
  Future<SendOtpResponse> sendOtp(SendOtpRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request);
}
