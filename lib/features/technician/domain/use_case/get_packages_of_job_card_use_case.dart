import '../entity/job_card_package_entity.dart';
import '../repository/i_technician_repository.dart';

class GetPackagesOfJobCardUseCase {
  GetPackagesOfJobCardUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<JobCardPackageEntity>> call({required String srNumber}) {
    return _repository.getPackagesOfJobCard(srNumber: srNumber);
  }
}
