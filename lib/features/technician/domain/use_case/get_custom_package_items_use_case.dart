import '../entity/custom_package_item_entity.dart';
import '../repository/i_technician_repository.dart';

class GetCustomPackageItemsUseCase {
  GetCustomPackageItemsUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<CustomPackageItemEntity>> call({
    required String jobCardNumber,
    required String categoryId,
  }) {
    return _repository.getCustomPackageItems(
      jobCardNumber: jobCardNumber,
      categoryId: categoryId,
    );
  }
}
