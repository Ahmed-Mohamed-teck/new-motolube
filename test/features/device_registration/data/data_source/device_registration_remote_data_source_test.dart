import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/core/utils/end_point.dart';
import 'package:newmotorlube/features/device_registration/data/data_source/device_registration_remote_data_source.dart';
import 'package:newmotorlube/features/device_registration/data/model/device_registration_model.dart';

void main() {
  test('posts device details to Device/register', () async {
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
    final dataSource = DeviceRegistrationRemoteDataSourceImpl(dio);
    const request = DeviceRegistrationModel(
      userId: 42,
      fcmToken: 'fcm-token',
      platform: 'ios',
      deviceId: 'device-id',
    );

    await dataSource.registerDevice(request);

    expect(capturedRequest?.method, 'POST');
    expect(capturedRequest?.uri.toString(), registerDeviceEndPoint);
    expect(capturedRequest?.data, request.toJson());
  });
}
