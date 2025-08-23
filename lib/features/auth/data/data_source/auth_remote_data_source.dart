import 'package:dio/dio.dart';
import '../../../../core/utils/end_point.dart';
import '../../domain/entity/auth_exception.dart';
import '../model/register_request.dart';
import '../model/register_response.dart';
import '../model/send_otp_request.dart';
import '../model/send_otp_response.dart';
import '../model/user_model.dart';
import '../model/verify_opt_response.dart';
import '../model/verify_otp_request.dart';
import 'i_auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);


  @override
  Future<bool> isUserRegisteredUser(String phoneNumber) async {
    try {
      final res = await dio.post(isUserRegisteredEndPoint,data: {'mobileNumber': phoneNumber});
      final data = res.data as Map<String, dynamic>;
      return data['isRegistered'] as bool;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false; // User not found, hence not registered
      }
      rethrow; // Rethrow other errors
    }
  }



  @override
  Future<SendOtpResponse> sendOtp(SendOtpRequest request) async {
    try {
      final res = await dio.post(sendOtpEndPoint, data: request.toJson());
      return SendOtpResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        throw UnregisteredUserException();
      }
      rethrow;
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final res = await dio.post(registerEndPoint, data: request.toJson());
      return RegisterResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['error'] == 'User already registered') {
        throw UserAlreadyRegisteredException();
      }
      rethrow;
    }
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final res = await dio.post(verifyOtpEndPoint, data: request.toJson());
      return VerifyOtpResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['error'] == 'Invalid or expired OTP') {
        throw InvalidOtpException();
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserInfo(String phoneNumber) async {
    try {
      final res = await dio.get(getUserInfoEndPoint(phoneNumber));
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('User not found for phone number: $phoneNumber');
      }
      rethrow;
    }
  }
}