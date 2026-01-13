import '../model/upcoming_service_model.dart';

abstract class IUpcomingServiceRemoteDataSource {
  Future<List<UpcomingServiceModel>> getUpcomingServices({
    required String userId,
    String? fromDate,
    String? toDate,
    String? statusId,
  });

  Future<void> updateAppointmentStatus({
    required String bookingId,
    required String statusId,
  });
}
