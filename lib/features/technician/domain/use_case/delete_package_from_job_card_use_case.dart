import '../entity/operation_result_entity.dart';
import '../repository/i_technician_repository.dart';

class DeletePackageFromJobCardUseCase {
  DeletePackageFromJobCardUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<OperationResultEntity> call({
    required String packageLineId,
    required String userId,
  }) {
    return _repository.deletePackageFromJobCard(
      packageLineId: packageLineId,
      userId: userId,
    );
  }
}
