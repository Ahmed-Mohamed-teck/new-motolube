import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/device_registration/domain/entity/device_registration.dart';
import 'package:newmotorlube/features/device_registration/domain/repository/i_device_registration_repository.dart';
import 'package:newmotorlube/features/device_registration/domain/use_case/register_device_use_case.dart';

void main() {
  test('registers a normalized device payload', () async {
    final repository = _FakeDeviceRegistrationRepository();
    final useCase = RegisterDeviceUseCase(repository);

    final result = await useCase(
      userId: '42',
      oracleId: '761369',
      fcmToken: ' current-fcm-token ',
      platform: ' android ',
      deviceId: ' stable-device-id ',
    );

    expect(result, isNotNull);
    expect(repository.registration?.userId, 42);
    expect(repository.registration?.fcmToken, 'current-fcm-token');
    expect(repository.registration?.platform, 'android');
    expect(repository.registration?.deviceId, 'stable-device-id');
  });

  test('uses oracle ID when the API user ID is unavailable', () async {
    final repository = _FakeDeviceRegistrationRepository();
    final useCase = RegisterDeviceUseCase(repository);

    final result = await useCase(
      userId: '',
      oracleId: '761369',
      fcmToken: 'fcm-token',
      platform: 'ios',
      deviceId: 'device-id',
    );

    expect(result?.userId, 761369);
    expect(repository.registration?.userId, 761369);
  });

  test('skips registration when no numeric user ID is available', () async {
    final repository = _FakeDeviceRegistrationRepository();
    final useCase = RegisterDeviceUseCase(repository);

    final result = await useCase(
      userId: 'user-42',
      oracleId: 'oracle-42',
      fcmToken: 'fcm-token',
      platform: 'android',
      deviceId: 'device-id',
    );

    expect(result, isNull);
    expect(repository.registration, isNull);
  });
}

class _FakeDeviceRegistrationRepository
    implements IDeviceRegistrationRepository {
  DeviceRegistration? registration;

  @override
  Future<void> registerDevice(DeviceRegistration registration) async {
    this.registration = registration;
  }
}
