import '../entity/operation_result_entity.dart';
import '../repository/i_technician_repository.dart';

class PostChecklistUseCase {
  PostChecklistUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<OperationResultEntity> call({
    required String srNumber,
    required String checklistId,
    required Map<String, dynamic> data,
  }) {
    return _repository.postChecklist(
      srNumber: srNumber,
      checklistId: checklistId,
      data: data,
    );
  }
}
