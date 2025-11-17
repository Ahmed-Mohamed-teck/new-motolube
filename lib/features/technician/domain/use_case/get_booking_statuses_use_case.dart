import '../entity/booking_status.dart';
import '../repository/i_technician_repository.dart';

class GetBookingStatusesUseCase {
  const GetBookingStatusesUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<TechnicianBookingStatus>> call() {
    return _repository.getBookingStatuses();
  }
}
