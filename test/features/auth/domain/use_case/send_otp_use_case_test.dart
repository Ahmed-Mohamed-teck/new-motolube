import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:newmotorlube/features/auth/domain/entity/otp_info.dart';
import 'package:newmotorlube/features/auth/domain/repository/auth_repository.dart';
import 'package:newmotorlube/features/auth/domain/use_case/send_otp_use_case.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('calls repository to send otp', () async {
    final repo = _MockAuthRepository();
    final useCase = SendOtpUseCase(repo);
    final info = OtpInfo(mobileNumber: '+123', expiresIn: 300, message: 'ok');
    when(() => repo.sendOtp('+123')).thenAnswer((_) async => info);

    final result = await useCase('+123');

    expect(result, info);
    verify(() => repo.sendOtp('+123')).called(1);
  });
}
