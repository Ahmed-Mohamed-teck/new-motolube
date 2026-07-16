import '../../domain/entity/device_registration.dart';

class DeviceRegistrationModel extends DeviceRegistration {
  const DeviceRegistrationModel({
    required super.userId,
    required super.fcmToken,
    required super.platform,
    required super.deviceId,
  });

  factory DeviceRegistrationModel.fromEntity(DeviceRegistration entity) {
    return DeviceRegistrationModel(
      userId: entity.userId,
      fcmToken: entity.fcmToken,
      platform: entity.platform,
      deviceId: entity.deviceId,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fcmToken': fcmToken,
    'platform': platform,
    'deviceId': deviceId,
  };
}
