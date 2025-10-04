import '../entity/register_result.dart';
import '../repository/i_auth_repository.dart';

class RegisterUserUseCase {
  final IAuthRepository repository;
  RegisterUserUseCase(this.repository);

  Future<RegisterResult> call({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
  }) {
    return repository.register(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
    );
  }
}
