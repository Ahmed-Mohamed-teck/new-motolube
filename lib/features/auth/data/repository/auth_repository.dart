import '../data_source/auth_remote_data_source.dart';
import '../model/register_request.dart';
import '../model/register_response.dart';
import '../model/send_otp_request.dart';
import '../model/send_otp_response.dart';
import '../model/verify_otp_request.dart';
import '../model/verify_otp_response.dart';
import '../../domain/repository/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<SendOtpResponse> sendOtp(SendOtpRequest request) {
    return remote.sendOtp(request);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    return remote.register(request);
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) {
    return remote.verifyOtp(request);
  }
}
