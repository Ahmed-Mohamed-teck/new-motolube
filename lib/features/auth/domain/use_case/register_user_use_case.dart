import '../entity/register_result.dart';
import '../repository/i_auth_repository.dart';

class RegisterUserUseCase {
  final IAuthRepository repository;
  RegisterUserUseCase(this.repository);

  Future<RegisterResult> call({required String name, required String phone, String? email}) {
    return repository.register(name: name, phone: phone, email: email);
  }
}