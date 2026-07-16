import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/auth/domain/entity/user_entity.dart';
import 'package:newmotorlube/features/auth/domain/entity/user_type.dart';
import 'package:newmotorlube/features/device_registration/data/data_source/i_device_id_local_data_source.dart';
import 'package:newmotorlube/features/device_registration/data/data_source/i_push_token_data_source.dart';
import 'package:newmotorlube/features/device_registration/domain/entity/device_registration.dart';
import 'package:newmotorlube/features/device_registration/domain/repository/i_device_registration_repository.dart';
import 'package:newmotorlube/features/device_registration/domain/use_case/register_device_use_case.dart';
import 'package:newmotorlube/features/device_registration/presentation/view_model/device_registration_state.dart';
import 'package:newmotorlube/features/device_registration/provider/device_registration_provider.dart';

void main() {
  test('coordinates token and device sources through the use case', () async {
    final repository = _FakeDeviceRegistrationRepository();
    final container = ProviderContainer(
      overrides: [
        registerDeviceUseCaseProvider.overrideWithValue(
          RegisterDeviceUseCase(repository),
        ),
        deviceIdLocalDataSourceProvider.overrideWithValue(
          _FakeDeviceIdLocalDataSource(),
        ),
        pushTokenDataSourceProvider.overrideWithValue(
          _FakePushTokenDataSource(),
        ),
        devicePlatformProvider.overrideWithValue('android'),
      ],
    );
    addTearDown(container.dispose);

    final registered = await container
        .read(deviceRegistrationViewModelProvider.notifier)
        .register(_user());

    expect(registered, isTrue);
    expect(repository.registration?.fcmToken, 'current-fcm-token');
    expect(repository.registration?.deviceId, 'stable-device-id');
    expect(
      container.read(deviceRegistrationViewModelProvider),
      isA<DeviceRegistrationSuccess>(),
    );
  });
}

User _user() {
  return const User(
    oracleId: '761369',
    userId: '42',
    mobileNo: '0500000000',
    isVerified: true,
    userType: UserType.customer,
  );
}

class _FakeDeviceIdLocalDataSource implements IDeviceIdLocalDataSource {
  @override
  Future<String> getOrCreateDeviceId() async => 'stable-device-id';
}

class _FakePushTokenDataSource implements IPushTokenDataSource {
  @override
  Future<String?> getToken() async => 'current-fcm-token';

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();
}

class _FakeDeviceRegistrationRepository
    implements IDeviceRegistrationRepository {
  DeviceRegistration? registration;

  @override
  Future<void> registerDevice(DeviceRegistration registration) async {
    this.registration = registration;
  }
}
