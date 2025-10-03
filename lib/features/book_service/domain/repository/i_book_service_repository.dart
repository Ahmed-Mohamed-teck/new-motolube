import '../entity/service_package_entity.dart';

abstract class IBookServiceRepository {
  Future<List<ServicePackageEntity>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
  });
}
