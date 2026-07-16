import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/auth/data/model/update_user_profile_request.dart';

void main() {
  test('serializes the profile update API payload', () {
    const request = UpdateUserProfileRequest(
      oracleId: 'oracle-123',
      fireBaseId: 'firebase-456',
      photoBase64: 'cGhvdG8=',
      email: 'user@example.com',
      userType: 1,
    );

    expect(request.toJson(), {
      'oracleId': 'oracle-123',
      'fireBaseId': 'firebase-456',
      'photoBase64': 'cGhvdG8=',
      'email': 'user@example.com',
      'userType': 1,
    });
  });

  test('keeps a missing email nullable for the API', () {
    const request = UpdateUserProfileRequest(
      oracleId: 'oracle-123',
      fireBaseId: 'firebase-456',
      photoBase64: 'cGhvdG8=',
      email: null,
      userType: 1,
    );

    expect(request.toJson()['email'], isNull);
  });
}
