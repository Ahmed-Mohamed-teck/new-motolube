import '../entity/stored_auth.dart';
import '../repository/i_auth_local_repository.dart';

class GetStoredAuthUseCase {
  final IAuthLocalRepository repository;
  GetStoredAuthUseCase(this.repository);

  Future<StoredAuth?> call() {
    return repository.getStoredAuth();
  }
}
