import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/core/utils/end_point.dart';
import 'package:newmotorlube/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:newmotorlube/features/auth/data/model/update_user_profile_request.dart';

void main() {
  test('posts profile updates to UserManagement/update', () async {
    final dio = Dio();
    RequestOptions? capturedRequest;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          capturedRequest = options;
          handler.resolve(Response(requestOptions: options, statusCode: 200));
        },
      ),
    );
    final dataSource = AuthRemoteDataSourceImpl(dio);
    const request = UpdateUserProfileRequest(
      oracleId: 'oracle-123',
      fireBaseId: 'firebase-456',
      photoBase64: 'cGhvdG8=',
      email: 'user@example.com',
      userType: 1,
    );

    await dataSource.updateUserProfile(request);

    expect(capturedRequest?.method, 'POST');
    expect(capturedRequest?.uri.toString(), updateUserProfileEndPoint);
    expect(capturedRequest?.data, request.toJson());
  });
}
