import '../entity/technician_slot_entity.dart';
import '../repository/i_technician_repository.dart';

class GetTechnicianAvailableSlotsUseCase {
  GetTechnicianAvailableSlotsUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<TechnicianSlotEntity>> call({
    required String technicianId,
    required String date,
  }) {
    return _repository.getAvailableSlots(
      technicianId: technicianId,
      date: date,
    );
  }
}
