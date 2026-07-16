import '../model/device_registration_model.dart';

abstract interface class IDeviceRegistrationRemoteDataSource {
  Future<void> registerDevice(DeviceRegistrationModel request);
}
