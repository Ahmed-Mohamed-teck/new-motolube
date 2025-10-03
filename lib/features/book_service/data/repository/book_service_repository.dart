import '../../domain/entity/service_package_entity.dart';
import '../../domain/repository/i_book_service_repository.dart';
import '../data_source/i_book_service_remote_data_source.dart';

class BookServiceRepository implements IBookServiceRepository {
  final IBookServiceRemoteDataSource _remoteDataSource;

  BookServiceRepository(this._remoteDataSource);

  @override
  Future<List<ServicePackageEntity>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
  }) async {
    final models = await _remoteDataSource.getPackagesForVehicle(
      customerId: customerId,
      vehicleId: vehicleId,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
