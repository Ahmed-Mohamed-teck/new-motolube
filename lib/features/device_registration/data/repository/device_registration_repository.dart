import '../../domain/entity/device_registration.dart';
import '../../domain/repository/i_device_registration_repository.dart';
import '../data_source/i_device_registration_remote_data_source.dart';
import '../model/device_registration_model.dart';

class DeviceRegistrationRepositoryImpl
    implements IDeviceRegistrationRepository {
  const DeviceRegistrationRepositoryImpl(this._remoteDataSource);

  final IDeviceRegistrationRemoteDataSource _remoteDataSource;

  @override
  Future<void> registerDevice(DeviceRegistration registration) {
    return _remoteDataSource.registerDevice(
      DeviceRegistrationModel.fromEntity(registration),
    );
  }
}
