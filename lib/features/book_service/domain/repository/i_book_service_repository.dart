import '../entity/create_appointment_result.dart';
import '../entity/service_package_entity.dart';

abstract class IBookServiceRepository {
  Future<List<ServicePackageEntity>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
    String? category,
  });

  Future<CreateAppointmentResult> createAppointment({
    required String bookingDate,
    required String branchId,
    required String userId,
    required String latitude,
    required String longitude,
    required String mileage,
    required String partyId,
    required String vehicleId,
    required String packageId,
    required String selectedSlot,
    required bool isImmediateAppointment,
    required String slotTime,
  });
}
