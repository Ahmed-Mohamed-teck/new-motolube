import '../entity/technician_appointment_entity.dart';
import '../repository/i_technician_repository.dart';

class GetTechnicianAppointmentsUseCase {
  const GetTechnicianAppointmentsUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<TechnicianAppointmentEntity>> call({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  }) {
    return _repository.getAppointments(
      userId: userId,
      fromDate: fromDate,
      toDate: toDate,
      statusId: statusId,
    );
  }
}
