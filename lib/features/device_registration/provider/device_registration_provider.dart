import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../../../core/providers/general_providers.dart';
import '../../../core/providers/push_notifications_service.dart';
import '../data/data_source/device_id_local_data_source.dart';
import '../data/data_source/device_registration_remote_data_source.dart';
import '../data/data_source/i_device_id_local_data_source.dart';
import '../data/data_source/i_device_registration_remote_data_source.dart';
import '../data/data_source/i_push_token_data_source.dart';
import '../data/data_source/push_token_data_source.dart';
import '../data/repository/device_registration_repository.dart';
import '../domain/repository/i_device_registration_repository.dart';
import '../domain/use_case/register_device_use_case.dart';
import '../presentation/view_model/device_registration_state.dart';
import '../presentation/view_model/device_registration_view_model.dart';

final deviceRegistrationRemoteDataSourceProvider =
    Provider<IDeviceRegistrationRemoteDataSource>((ref) {
      return DeviceRegistrationRemoteDataSourceImpl(ref.read(dioProvider));
    });

final deviceIdLocalDataSourceProvider = Provider<IDeviceIdLocalDataSource>((
  ref,
) {
  return DeviceIdLocalDataSourceImpl(appPrefsWithCache);
});

final pushTokenDataSourceProvider = Provider<IPushTokenDataSource>((ref) {
  return PushTokenDataSourceImpl(PushNotificationsService.instance);
});

final deviceRegistrationRepositoryProvider =
    Provider<IDeviceRegistrationRepository>((ref) {
      return DeviceRegistrationRepositoryImpl(
        ref.read(deviceRegistrationRemoteDataSourceProvider),
      );
    });

final registerDeviceUseCaseProvider = Provider<RegisterDeviceUseCase>((ref) {
  return RegisterDeviceUseCase(ref.read(deviceRegistrationRepositoryProvider));
});

final devicePlatformProvider = Provider<String>((ref) => _currentPlatform);

final deviceRegistrationViewModelProvider =
    NotifierProvider<DeviceRegistrationViewModel, DeviceRegistrationState>(
      () => DeviceRegistrationViewModel(),
    );

String get _currentPlatform => switch (defaultTargetPlatform) {
  TargetPlatform.android => 'android',
  TargetPlatform.iOS => 'ios',
  TargetPlatform.macOS => 'macos',
  TargetPlatform.windows => 'windows',
  TargetPlatform.linux => 'linux',
  TargetPlatform.fuchsia => 'fuchsia',
};
