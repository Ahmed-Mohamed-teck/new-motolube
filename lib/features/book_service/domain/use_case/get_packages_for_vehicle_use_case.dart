import '../entity/service_package_entity.dart';
import '../repository/i_book_service_repository.dart';

class GetPackagesForVehicleUseCase {
  final IBookServiceRepository _repository;

  GetPackagesForVehicleUseCase(this._repository);

  Future<List<ServicePackageEntity>> call({
    required String customerId,
    required String vehicleId,
  }) {
    return _repository.getPackagesForVehicle(
      customerId: customerId,
      vehicleId: vehicleId,
    );
  }
}
