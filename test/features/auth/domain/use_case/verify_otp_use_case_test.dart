import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:newmotorlube/features/auth/domain/entity/tokens.dart';
import 'package:newmotorlube/features/auth/domain/entity/user.dart';
import 'package:newmotorlube/features/auth/domain/entity/verify_otp_result.dart';
import 'package:newmotorlube/features/auth/domain/repository/auth_repository.dart';
import 'package:newmotorlube/features/auth/domain/use_case/verify_otp_use_case.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('calls repository to verify otp', () async {
    final repo = _MockAuthRepository();
    final useCase = VerifyOtpUseCase(repo);
    final result = VerifyOtpResult(
      message: 'ok',
      user: const User(
          id: '1', mobileNumber: '+123', isVerified: true, name: null, email: null),
      tokens: const Tokens(
          firebaseToken: 'f', jwtToken: 'j', tokenType: 'Bearer', expiresIn: 1),
    );
    when(() => repo.verifyOtp(phone: '+123', otp: '000000'))
        .thenAnswer((_) async => result);

    final res = await useCase(phone: '+123', otp: '000000');

    expect(res, result);
    verify(() => repo.verifyOtp(phone: '+123', otp: '000000')).called(1);
  });
}
