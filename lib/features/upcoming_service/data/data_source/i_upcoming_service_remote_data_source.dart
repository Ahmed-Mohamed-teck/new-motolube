import '../model/upcoming_service_model.dart';

abstract class IUpcomingServiceRemoteDataSource {
  Future<List<UpcomingServiceModel>> getUpcomingServices({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  });
}
