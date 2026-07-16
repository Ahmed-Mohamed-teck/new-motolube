import '../entity/device_registration.dart';
import '../repository/i_device_registration_repository.dart';

class RegisterDeviceUseCase {
  const RegisterDeviceUseCase(this._repository);

  final IDeviceRegistrationRepository _repository;

  Future<DeviceRegistration?> call({
    required String userId,
    required String oracleId,
    required String fcmToken,
    required String platform,
    required String deviceId,
  }) async {
    final resolvedUserId = _resolveUserId(userId, oracleId);
    final normalizedToken = fcmToken.trim();
    final normalizedPlatform = platform.trim();
    final normalizedDeviceId = deviceId.trim();

    if (resolvedUserId == null ||
        normalizedToken.isEmpty ||
        normalizedPlatform.isEmpty ||
        normalizedDeviceId.isEmpty) {
      return null;
    }

    final registration = DeviceRegistration(
      userId: resolvedUserId,
      fcmToken: normalizedToken,
      platform: normalizedPlatform,
      deviceId: normalizedDeviceId,
    );
    await _repository.registerDevice(registration);
    return registration;
  }

  int? _resolveUserId(String userId, String oracleId) {
    final apiUserId = int.tryParse(userId.trim());
    if (apiUserId != null) return apiUserId;
    return int.tryParse(oracleId.trim());
  }
}
