import '../../domain/entity/otp_info.dart';
import '../../domain/entity/register_result.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/entity/verify_otp_result.dart';
import '../../domain/repository/i_auth_repository.dart';
import '../data_source/i_auth_remote_data_source.dart';
import '../model/register_request.dart';
import '../model/send_otp_request.dart';
import '../model/verify_otp_request.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);


  @override
  Future<bool> isUserRegisteredUser(String phoneNumber) {
    return remote.isUserRegisteredUser(phoneNumber);
  }

  @override
  Future<OtpInfo> sendOtp(String phone) async {
    final res = await remote.sendOtp(SendOtpRequest(phone));
    return res.toEntity();
  }

  @override
  Future<RegisterResult> register({required String name, required String phone, String? email}) async {
    final req = RegisterRequest(
      email: email,
      isEmergencyTech: false,
      mobileNumber: phone,
      name: name,
      userType: 1,
    );
    final res = await remote.register(req);
    return res.toEntity();
  }

  @override
  Future<VerifyOtpResult> verifyOtp({required String phone, required String otp}) async {
    final res = await remote.verifyOtp(VerifyOtpRequest(mobileNumber: phone, otp: otp));
    return res.toEntity();
  }

  @override
  Future<User> getUserInfo({required String phoneNumber}) async {
    final res = await remote.getUserInfo(phoneNumber);
    return res.toEntity();
  }


}