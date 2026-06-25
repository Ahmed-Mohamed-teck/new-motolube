import '../repository/i_auth_repository.dart';

class DeleteUserAccountUseCase {
  final IAuthRepository _repository;

  DeleteUserAccountUseCase(this._repository);

  Future<void> call(String email) {
    return _repository.deleteUserAccount(email);
  }
}
