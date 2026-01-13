import '../repository/i_upcoming_service_repository.dart';

class CancelAppointmentUseCase {
  CancelAppointmentUseCase(this._repository);

  final IUpcomingServiceRepository _repository;

  Future<void> call({
    required String bookingId,
    required String statusId,
  }) {
    return _repository.updateAppointmentStatus(
      bookingId: bookingId,
      statusId: statusId,
    );
  }
}
