import '../entity/force_update_result.dart';
import '../repository/i_force_update_repository.dart';

class CheckForceUpdateUseCase {
  const CheckForceUpdateUseCase(this._repository);

  final IForceUpdateRepository _repository;

  Future<ForceUpdateResult> call() {
    return _repository.checkForUpdate();
  }
}
