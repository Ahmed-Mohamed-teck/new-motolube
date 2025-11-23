import '../entity/job_card_entity.dart';
import '../repository/i_technician_repository.dart';

class CompleteServiceRequestUseCase {
  const CompleteServiceRequestUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<JobCardEntity>> call({
    required String srNumber,
    required String userId,
  }) {
    return _repository.completeServiceRequest(
      srNumber: srNumber,
      userId: userId,
    );
  }
}
