import '../entity/upcoming_service_entity.dart';

abstract class IUpcomingServiceRepository {
  Future<List<UpcomingServiceEntity>> getUpcomingServices({
    DateTime? fromDate,
    DateTime? toDate,
    int? statusId,
  });
}
