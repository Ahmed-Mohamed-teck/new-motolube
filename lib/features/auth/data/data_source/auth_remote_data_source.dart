import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../../domain/entity/auth_exceptions.dart';
import '../model/register_request.dart';
import '../model/register_response.dart';
import '../model/send_otp_request.dart';
import '../model/send_otp_response.dart';
import '../model/verify_otp_request.dart';
import '../model/verify_otp_response.dart';

abstract class AuthRemoteDataSource {
  Future<SendOtpResponse> sendOtp(SendOtpRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

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
}
