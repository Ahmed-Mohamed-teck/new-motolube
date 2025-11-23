import '../model/operation_result_model.dart';
import '../model/custom_package_category_model.dart';
import '../model/custom_package_item_model.dart';
import '../model/job_card_model.dart';
import '../model/job_card_package_line_model.dart';
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

  Future<List<JobCardModel>> completeServiceRequest({
    required String srNumber,
    required String userId,
  });

  Future<List<JobCardPackageModel>> getJobCardPackages({
    required String srNumber,
  });

  Future<List<CustomPackageCategoryModel>> getCustomPackageCategories();

  Future<List<CustomPackageItemModel>> getCustomPackageItems({
    required String jobCardNumber,
    required String categoryId,
  });

  Future<OperationResultModel> addItemToCustomPackage({
    required String jobCardNumber,
    required String lineId,
    required String categoryId,
    required String inventoryItemId,
    required String qty,
    required String userId,
  });

  Future<OperationResultModel> deleteCustomPackageItem({
    required String srLineId,
  });

  Future<List<JobCardPackageLineModel>> getJobCardPackageLines({
    required String srNumber,
    String? packageId,
  });

  Future<OperationResultModel> addPackageToJobCard({
    required String srNumber,
    required String packageId,
    required String userId,
    String campaignLineId,
  });

  Future<OperationResultModel> deletePackageFromJobCard({
    required String packageLineId,
    required String userId,
  });

  Future<OperationResultModel> postChecklist({
    required String srNumber,
    required String checklistId,
    required Map<String, dynamic> data,
  });

  Future<List<JobCardPackageModel>> getPackagesOfJobCard({
    required String srNumber,
  });
}
