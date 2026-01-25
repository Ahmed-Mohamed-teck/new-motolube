import '../../domain/entity/main_category_entity.dart';
import '../../domain/repository/i_home_repository.dart';
import '../data_source/i_home_remote_data_source.dart';

class HomeRepository implements IHomeRepository {
  final IHomeRemoteDataSource _remoteDataSource;

  HomeRepository(this._remoteDataSource);

  @override
  Future<List<MainCategoryEntity>> getMainCategories() async {
    final models = await _remoteDataSource.getMainCategories();
    return List<MainCategoryEntity>.from(models);
  }
}
