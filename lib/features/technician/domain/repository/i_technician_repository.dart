import '../entity/booking_status.dart';
import '../entity/job_card_entity.dart';
import '../entity/job_card_package_entity.dart';
import '../entity/technician_appointment_entity.dart';
import '../entity/technician_slot_entity.dart';
import '../entity/technician_summary_entity.dart';

abstract class ITechnicianRepository {
  Future<List<TechnicianSummaryEntity>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  });

  Future<List<TechnicianSlotEntity>> getAvailableSlots({
    required String technicianId,
    required String date,
  });

  Future<List<TechnicianAppointmentEntity>> getAppointments({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  });

  Future<List<TechnicianBookingStatus>> getBookingStatuses();

  Future<void> updateAppointmentStatus({
    required String bookingId,
    required String statusId,
  });

  Future<List<JobCardEntity>> createServiceRequest({
    required String fireBaseId,
    required String phoneNumber,
    required String vin,
    required String mileage,
    required String couponNumber,
    required String isEstimation,
    required String bookingId,
  });

  Future<List<JobCardPackageEntity>> getJobCardPackages({
    required String srNumber,
  });
}
