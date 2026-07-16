import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/device_registration/data/model/device_registration_model.dart';

void main() {
  test('serializes the device registration payload', () {
    const model = DeviceRegistrationModel(
      userId: 42,
      fcmToken: 'fcm-token',
      platform: 'android',
      deviceId: 'device-id',
    );

    expect(model.toJson(), {
      'userId': 42,
      'fcmToken': 'fcm-token',
      'platform': 'android',
      'deviceId': 'device-id',
    });
  });
}
