class DeviceRegistration {
  const DeviceRegistration({
    required this.userId,
    required this.fcmToken,
    required this.platform,
    required this.deviceId,
  });

  final int userId;
  final String fcmToken;
  final String platform;
  final String deviceId;
}
