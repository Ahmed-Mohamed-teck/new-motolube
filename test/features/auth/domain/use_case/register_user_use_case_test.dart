import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:newmotorlube/features/auth/domain/entity/register_result.dart';
import 'package:newmotorlube/features/auth/domain/repository/auth_repository.dart';
import 'package:newmotorlube/features/auth/domain/use_case/register_user_use_case.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('calls repository to register user', () async {
    final repo = _MockAuthRepository();
    final useCase = RegisterUserUseCase(repo);
    final result = RegisterResult(message: 'ok', userId: '1', mobileNumber: '+123');
    when(() => repo.register(name: 'n', phone: '+123', email: null))
        .thenAnswer((_) async => result);

    final res = await useCase(name: 'n', phone: '+123');

    expect(res, result);
    verify(() => repo.register(name: 'n', phone: '+123', email: null)).called(1);
  });
}
