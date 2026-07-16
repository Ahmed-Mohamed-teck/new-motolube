import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entity/user_entity.dart';
import '../../data/data_source/i_device_id_local_data_source.dart';
import '../../data/data_source/i_push_token_data_source.dart';
import '../../domain/use_case/register_device_use_case.dart';
import '../../provider/device_registration_provider.dart';
import 'device_registration_state.dart';

class DeviceRegistrationViewModel extends Notifier<DeviceRegistrationState> {
  late final RegisterDeviceUseCase _registerDeviceUseCase;
  late final IDeviceIdLocalDataSource _deviceIdLocalDataSource;
  late final IPushTokenDataSource _pushTokenDataSource;
  late final String _platform;

  @override
  DeviceRegistrationState build() {
    _registerDeviceUseCase = ref.read(registerDeviceUseCaseProvider);
    _deviceIdLocalDataSource = ref.read(deviceIdLocalDataSourceProvider);
    _pushTokenDataSource = ref.read(pushTokenDataSourceProvider);
    _platform = ref.read(devicePlatformProvider);
    return const DeviceRegistrationInitial();
  }

  Future<bool> register(User user, {String? fcmToken}) async {
    state = const DeviceRegistrationInProgress();
    try {
      final token = fcmToken ?? await _pushTokenDataSource.getToken();
      final deviceId = await _deviceIdLocalDataSource.getOrCreateDeviceId();
      final registration = await _registerDeviceUseCase(
        userId: user.userId,
        oracleId: user.oracleId,
        fcmToken: token ?? '',
        platform: _platform,
        deviceId: deviceId,
      );

      if (registration == null) {
        state = const DeviceRegistrationSkipped();
        return false;
      }

      state = DeviceRegistrationSuccess(registration);
      return true;
    } catch (error) {
      state = DeviceRegistrationFailure(error);
      rethrow;
    }
  }
}
