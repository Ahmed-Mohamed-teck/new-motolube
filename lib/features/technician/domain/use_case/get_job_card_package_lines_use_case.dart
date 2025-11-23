import '../entity/job_card_package_line_entity.dart';
import '../repository/i_technician_repository.dart';

class GetJobCardPackageLinesUseCase {
  GetJobCardPackageLinesUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<JobCardPackageLineEntity>> call({
    required String srNumber,
    String? packageId,
  }) {
    return _repository.getJobCardPackageLines(
      srNumber: srNumber,
      packageId: packageId,
    );
  }
}
