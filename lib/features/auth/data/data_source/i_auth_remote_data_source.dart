import 'package:newmotorlube/features/auth/data/model/user_model.dart';

import '../model/register_request.dart';
import '../model/register_response.dart';
import '../model/send_otp_request.dart';
import '../model/send_otp_response.dart';
import '../model/verify_opt_response.dart';
import '../model/verify_otp_request.dart';

abstract class AuthRemoteDataSource {
  Future<bool> isUserRegisteredUser(String phoneNumber);
  Future<SendOtpResponse> sendOtp(SendOtpRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request);
  Future<UserModel> getUserInfo(String phoneNumber);
}