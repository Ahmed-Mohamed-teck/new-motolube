import '../../domain/entity/device_registration.dart';

sealed class DeviceRegistrationState {
  const DeviceRegistrationState();
}

class DeviceRegistrationInitial extends DeviceRegistrationState {
  const DeviceRegistrationInitial();
}

class DeviceRegistrationInProgress extends DeviceRegistrationState {
  const DeviceRegistrationInProgress();
}

class DeviceRegistrationSuccess extends DeviceRegistrationState {
  const DeviceRegistrationSuccess(this.registration);

  final DeviceRegistration registration;
}

class DeviceRegistrationSkipped extends DeviceRegistrationState {
  const DeviceRegistrationSkipped();
}

class DeviceRegistrationFailure extends DeviceRegistrationState {
  const DeviceRegistrationFailure(this.error);

  final Object error;
}
