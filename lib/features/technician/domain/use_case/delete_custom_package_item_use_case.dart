import '../entity/operation_result_entity.dart';
import '../repository/i_technician_repository.dart';

class DeleteCustomPackageItemUseCase {
  DeleteCustomPackageItemUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<OperationResultEntity> call({
    required String srLineId,
  }) {
    return _repository.deleteCustomPackageItem(srLineId: srLineId);
  }
}
