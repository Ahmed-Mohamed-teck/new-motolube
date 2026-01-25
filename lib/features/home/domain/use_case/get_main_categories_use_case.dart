import '../entity/main_category_entity.dart';
import '../repository/i_home_repository.dart';

class GetMainCategoriesUseCase {
  final IHomeRepository _repository;

  GetMainCategoriesUseCase(this._repository);

  Future<List<MainCategoryEntity>> call() {
    return _repository.getMainCategories();
  }
}
