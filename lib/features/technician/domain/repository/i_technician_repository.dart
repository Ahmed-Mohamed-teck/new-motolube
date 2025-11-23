import '../entity/booking_status.dart';
import '../entity/operation_result_entity.dart';
import '../entity/custom_package_category_entity.dart';
import '../entity/custom_package_item_entity.dart';
import '../entity/job_card_entity.dart';
import '../entity/job_card_package_entity.dart';
import '../entity/job_card_package_line_entity.dart';
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

  Future<List<JobCardEntity>> completeServiceRequest({
    required String srNumber,
    required String userId,
  });

  Future<List<JobCardPackageEntity>> getJobCardPackages({
    required String srNumber,
  });

  Future<List<CustomPackageCategoryEntity>> getCustomPackageCategories();

  Future<List<CustomPackageItemEntity>> getCustomPackageItems({
    required String jobCardNumber,
    required String categoryId,
  });

  Future<OperationResultEntity> addCustomPackageItem({
    required String jobCardNumber,
    required String lineId,
    required String categoryId,
    required String inventoryItemId,
    required String qty,
    required String userId,
  });

  Future<OperationResultEntity> deleteCustomPackageItem({
    required String srLineId,
  });

  Future<List<JobCardPackageLineEntity>> getJobCardPackageLines({
    required String srNumber,
    String? packageId,
  });

  Future<OperationResultEntity> addPackageToJobCard({
    required String srNumber,
    required String packageId,
    required String userId,
    String campaignLineId,
  });

  Future<OperationResultEntity> deletePackageFromJobCard({
    required String packageLineId,
    required String userId,
  });

  Future<OperationResultEntity> postChecklist({
    required String srNumber,
    required String checklistId,
    required Map<String, dynamic> data,
  });

  Future<List<JobCardPackageEntity>> getPackagesOfJobCard({
    required String srNumber,
  });
}
