import '../model/create_appointment_response_model.dart';
import '../model/service_package_model.dart';

abstract class IBookServiceRemoteDataSource {
  Future<List<ServicePackageModel>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
    String? category,
  });

  Future<CreateAppointmentResponseModel> createAppointment({
    required Map<String, dynamic> payload,
  });
}
