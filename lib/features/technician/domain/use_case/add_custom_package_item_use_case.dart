import '../entity/operation_result_entity.dart';
import '../repository/i_technician_repository.dart';

class AddCustomPackageItemUseCase {
  AddCustomPackageItemUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<OperationResultEntity> call({
    required String jobCardNumber,
    required String lineId,
    required String categoryId,
    required String inventoryItemId,
    required String qty,
    required String userId,
  }) {
    return _repository.addCustomPackageItem(
      jobCardNumber: jobCardNumber,
      lineId: lineId,
      categoryId: categoryId,
      inventoryItemId: inventoryItemId,
      qty: qty,
      userId: userId,
    );
  }
}
