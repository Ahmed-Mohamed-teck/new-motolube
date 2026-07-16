import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/auth/data/model/user_model.dart';

void main() {
  test('retains a numeric API user ID for device registration', () {
    final user = UserModel.fromJson({
      'oracleId': '761369',
      'userId': 42,
      'mobileNo': '0500000000',
      'isVerified': true,
      'userType': 1,
    });

    expect(user.userId, '42');
    expect(user.toEntity().userId, '42');
  });
}
