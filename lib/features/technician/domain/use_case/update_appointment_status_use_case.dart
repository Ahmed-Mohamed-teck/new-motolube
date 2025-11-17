import '../repository/i_technician_repository.dart';

class UpdateAppointmentStatusUseCase {
  const UpdateAppointmentStatusUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<void> call({required String bookingId, required String statusId}) {
    return _repository.updateAppointmentStatus(
      bookingId: bookingId,
      statusId: statusId,
    );
  }
}
