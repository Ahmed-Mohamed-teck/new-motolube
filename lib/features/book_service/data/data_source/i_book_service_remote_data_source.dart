import '../model/service_package_model.dart';

abstract class IBookServiceRemoteDataSource {
  Future<List<ServicePackageModel>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
  });
}
