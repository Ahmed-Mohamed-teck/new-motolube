import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/device_registration/data/data_source/i_device_registration_remote_data_source.dart';
import 'package:newmotorlube/features/device_registration/data/model/device_registration_model.dart';
import 'package:newmotorlube/features/device_registration/data/repository/device_registration_repository.dart';
import 'package:newmotorlube/features/device_registration/domain/entity/device_registration.dart';

void main() {
  test('maps the domain entity to a remote data model', () async {
    final remoteDataSource = _FakeDeviceRegistrationRemoteDataSource();
    final repository = DeviceRegistrationRepositoryImpl(remoteDataSource);
    const registration = DeviceRegistration(
      userId: 42,
      fcmToken: 'fcm-token',
      platform: 'android',
      deviceId: 'device-id',
    );

    await repository.registerDevice(registration);

    expect(remoteDataSource.model, isA<DeviceRegistrationModel>());
    expect(remoteDataSource.model?.toJson(), {
      'userId': 42,
      'fcmToken': 'fcm-token',
      'platform': 'android',
      'deviceId': 'device-id',
    });
  });
}

class _FakeDeviceRegistrationRemoteDataSource
    implements IDeviceRegistrationRemoteDataSource {
  DeviceRegistrationModel? model;

  @override
  Future<void> registerDevice(DeviceRegistrationModel request) async {
    model = request;
  }
}
