import '../entity/register_result.dart';
import '../repository/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;
  RegisterUserUseCase(this.repository);

  Future<RegisterResult> call({required String name, required String phone, String? email}) {
    return repository.register(name: name, phone: phone, email: email);
  }
}
