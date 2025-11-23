import '../entity/custom_package_category_entity.dart';
import '../repository/i_technician_repository.dart';

class GetCustomPackageCategoriesUseCase {
  GetCustomPackageCategoriesUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<CustomPackageCategoryEntity>> call() {
    return _repository.getCustomPackageCategories();
  }
}
