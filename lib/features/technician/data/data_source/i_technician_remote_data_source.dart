import '../model/job_card_model.dart';
import '../model/job_card_package_model.dart';
import '../model/technician_appointment_model.dart';
import '../model/technician_booking_status_model.dart';
import '../model/technician_slot_model.dart';
import '../model/technician_summary_model.dart';

abstract class ITechnicianRemoteDataSource {
  Future<List<TechnicianSummaryModel>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  });

  Future<List<TechnicianSlotModel>> getAvailableSlots({
    required String technicianId,
    required String date,
  });

  Future<List<TechnicianAppointmentModel>> getAppointments({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  });

  Future<List<TechnicianBookingStatusModel>> getBookingStatuses();

  Future<void> updateAppointmentStatus({
    required String bookingId,
    required String statusId,
  });

  Future<List<JobCardModel>> createServiceRequest({
    required String fireBaseId,
    required String phoneNumber,
    required String vin,
    required String mileage,
    required String couponNumber,
    required String isEstimation,
    required String bookingId,
  });

  Future<List<JobCardPackageModel>> getJobCardPackages({
    required String srNumber,
  });
}
