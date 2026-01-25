import '../model/main_category_model.dart';

abstract class IHomeRemoteDataSource {
  Future<List<MainCategoryModel>> getMainCategories();
}
