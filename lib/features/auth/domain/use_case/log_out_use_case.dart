import '../repository/i_auth_local_repository.dart';

class LogoutUseCase {
  final IAuthLocalRepository _repository;
  LogoutUseCase(this._repository);

  Future<void> call() {
    return _repository.clear();
  }
}
