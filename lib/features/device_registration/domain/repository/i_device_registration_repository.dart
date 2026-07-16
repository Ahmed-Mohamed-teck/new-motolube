import '../entity/device_registration.dart';

abstract interface class IDeviceRegistrationRepository {
  Future<void> registerDevice(DeviceRegistration registration);
}
