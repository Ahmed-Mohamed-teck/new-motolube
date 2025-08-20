import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:newmotorlube/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:newmotorlube/features/auth/data/model/auth_exceptions.dart';
import 'package:newmotorlube/features/auth/data/model/register_request.dart';
import 'package:newmotorlube/features/auth/data/model/send_otp_request.dart';
import 'package:newmotorlube/features/auth/data/model/verify_otp_request.dart';
import 'package:newmotorlube/features/auth/data/repository/auth_repository.dart';
import 'package:newmotorlube/features/auth/domain/repository/i_auth_repository.dart';
import 'package:newmotorlube/core/utils/end_point.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late IAuthRemoteDataSource dataSource;
  late IAuthRepository repo;

  setUp(() {
    dio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio);
    repo = AuthRepositoryImpl(dataSource);
  });

  test('sendOtp success returns response', () async {
    when(() => dio.post(sendOtpEndPoint, data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        data: {
          'message': 'OTP sent successfully',
          'mobileNumber': '+966500000000',
          'expiresIn': 300,
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: sendOtpEndPoint),
      ),
    );
    final res = await repo.sendOtp(SendOtpRequest('+966500000000'));
    expect(res.expiresIn, 300);
  });

  test('sendOtp unregistered throws', () async {
    when(() => dio.post(sendOtpEndPoint, data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: sendOtpEndPoint),
        response: Response(statusCode: 404, requestOptions: RequestOptions(path: sendOtpEndPoint)),
      ),
    );
    expect(() => repo.sendOtp(SendOtpRequest('+9665')), throwsA(isA<UnregisteredUserException>()));
  });

  test('register existing user throws', () async {
    when(() => dio.post(registerEndPoint, data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: registerEndPoint),
        response: Response(
          statusCode: 400,
          data: {'error': 'User already registered'},
          requestOptions: RequestOptions(path: registerEndPoint),
        ),
      ),
    );
    expect(
        () => repo.register(RegisterRequest(
              email: null,
              isEmergencyTech: false,
              mobileNumber: '+9665',
              name: 'name',
              userType: 1,
            )),
        throwsA(isA<UserAlreadyRegisteredException>()));
  });

  test('verifyOtp invalid throws', () async {
    when(() => dio.post(verifyOtpEndPoint, data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: verifyOtpEndPoint),
        response: Response(
          statusCode: 400,
          data: {'error': 'Invalid or expired OTP'},
          requestOptions: RequestOptions(path: verifyOtpEndPoint),
        ),
      ),
    );
    expect(
        () => repo.verifyOtp(
            VerifyOtpRequest(mobileNumber: '+9665', otp: '123456')),
        throwsA(isA<InvalidOtpException>()));
  });
}
