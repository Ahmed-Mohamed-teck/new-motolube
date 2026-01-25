import '../entity/main_category_entity.dart';

abstract class IHomeRepository {
  Future<List<MainCategoryEntity>> getMainCategories();
}
