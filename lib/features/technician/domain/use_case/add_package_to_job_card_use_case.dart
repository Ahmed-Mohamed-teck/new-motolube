import '../entity/operation_result_entity.dart';
import '../repository/i_technician_repository.dart';

class AddPackageToJobCardUseCase {
  AddPackageToJobCardUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<OperationResultEntity> call({
    required String srNumber,
    required String packageId,
    required String userId,
    String campaignLineId = '',
  }) {
    return _repository.addPackageToJobCard(
      srNumber: srNumber,
      packageId: packageId,
      userId: userId,
      campaignLineId: campaignLineId,
    );
  }
}
