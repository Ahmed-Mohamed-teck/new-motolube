import '../entity/job_card_package_entity.dart';
import '../repository/i_technician_repository.dart';

class GetJobCardPackagesUseCase {
  GetJobCardPackagesUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<JobCardPackageEntity>> call({required String srNumber}) {
    return _repository.getJobCardPackages(srNumber: srNumber);
  }
}
