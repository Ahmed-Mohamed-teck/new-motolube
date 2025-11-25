import '../entity/upcoming_service_entity.dart';
import '../repository/i_upcoming_service_repository.dart';

class GetUpcomingServicesUseCase {
  final IUpcomingServiceRepository _repository;

  const GetUpcomingServicesUseCase(this._repository);

  Future<List<UpcomingServiceEntity>> call({
    DateTime? fromDate,
    DateTime? toDate,
    int? statusId,
  }) {
    return _repository.getUpcomingServices(
      fromDate: fromDate,
      toDate: toDate,
      statusId: statusId,
    );
  }
}
