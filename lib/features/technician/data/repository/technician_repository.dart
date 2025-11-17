import '../../domain/entity/booking_status.dart';
import '../../domain/entity/job_card_entity.dart';
import '../../domain/entity/job_card_package_entity.dart';
import '../../domain/entity/technician_appointment_entity.dart';
import '../../domain/entity/technician_slot_entity.dart';
import '../../domain/entity/technician_summary_entity.dart';
import '../../domain/repository/i_technician_repository.dart';
import '../data_source/i_technician_remote_data_source.dart';

class TechnicianRepository implements ITechnicianRepository {
  TechnicianRepository(this._remoteDataSource);

  final ITechnicianRemoteDataSource _remoteDataSource;

  @override
  Future<List<TechnicianSummaryEntity>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  }) async {
    final models = await _remoteDataSource.searchNearby(
      latitude: latitude,
      longitude: longitude,
      maxResults: maxResults,
      radiusKm: radiusKm,
      serviceId: serviceId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TechnicianSlotEntity>> getAvailableSlots({
    required String technicianId,
    required String date,
  }) async {
    final models = await _remoteDataSource.getAvailableSlots(
      technicianId: technicianId,
      date: date,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TechnicianAppointmentEntity>> getAppointments({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  }) async {
    final models = await _remoteDataSource.getAppointments(
      userId: userId,
      fromDate: fromDate,
      toDate: toDate,
      statusId: statusId,
    );
    return List<TechnicianAppointmentEntity>.from(models);
  }

  @override
  Future<List<TechnicianBookingStatus>> getBookingStatuses() async {
    final models = await _remoteDataSource.getBookingStatuses();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateAppointmentStatus({
    required String bookingId,
    required String statusId,
  }) {
    return _remoteDataSource.updateAppointmentStatus(
      bookingId: bookingId,
      statusId: statusId,
    );
  }

  @override
  Future<List<JobCardEntity>> createServiceRequest({
    required String fireBaseId,
    required String phoneNumber,
    required String vin,
    required String mileage,
    required String couponNumber,
    required String isEstimation,
    required String bookingId,
  }) async {
    final models = await _remoteDataSource.createServiceRequest(
      fireBaseId: fireBaseId,
      phoneNumber: phoneNumber,
      vin: vin,
      mileage: mileage,
      couponNumber: couponNumber,
      isEstimation: isEstimation,
      bookingId: bookingId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<JobCardPackageEntity>> getJobCardPackages({
    required String srNumber,
  }) async {
    final models = await _remoteDataSource.getJobCardPackages(
      srNumber: srNumber,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
