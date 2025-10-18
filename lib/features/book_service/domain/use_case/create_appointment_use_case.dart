import '../entity/create_appointment_result.dart';
import '../repository/i_book_service_repository.dart';

class CreateAppointmentUseCase {
  final IBookServiceRepository _repository;

  CreateAppointmentUseCase(this._repository);

  Future<CreateAppointmentResult> call({
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
  }) {
    return _repository.createAppointment(
      bookingDate: bookingDate,
      branchId: branchId,
      userId: userId,
      latitude: latitude,
      longitude: longitude,
      mileage: mileage,
      partyId: partyId,
      vehicleId: vehicleId,
      packageId: packageId,
      selectedSlot: selectedSlot,
      isImmediateAppointment: isImmediateAppointment,
      slotTime: slotTime,
    );
  }
}
