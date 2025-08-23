import '../repository/i_auth_repository.dart';

class IsRegisteredUserUseCase{
  final IAuthRepository repository;
  IsRegisteredUserUseCase(this.repository);

  Future<bool> call(String phoneNumber) {
    return repository.isUserRegisteredUser(phoneNumber);
  }
}