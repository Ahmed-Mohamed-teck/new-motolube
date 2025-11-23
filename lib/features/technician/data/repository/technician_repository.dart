import '../../domain/entity/booking_status.dart';
import '../../domain/entity/custom_package_category_entity.dart';
import '../../domain/entity/custom_package_item_entity.dart';
import '../../domain/entity/job_card_entity.dart';
import '../../domain/entity/job_card_package_entity.dart';
import '../../domain/entity/job_card_package_line_entity.dart';
import '../../domain/entity/operation_result_entity.dart';
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
  Future<List<JobCardEntity>> completeServiceRequest({
    required String srNumber,
    required String userId,
  }) async {
    final models = await _remoteDataSource.completeServiceRequest(
      srNumber: srNumber,
      userId: userId,
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

  @override
  Future<List<CustomPackageCategoryEntity>> getCustomPackageCategories() async {
    final models = await _remoteDataSource.getCustomPackageCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CustomPackageItemEntity>> getCustomPackageItems({
    required String jobCardNumber,
    required String categoryId,
  }) async {
    final models = await _remoteDataSource.getCustomPackageItems(
      jobCardNumber: jobCardNumber,
      categoryId: categoryId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<OperationResultEntity> addCustomPackageItem({
    required String jobCardNumber,
    required String lineId,
    required String categoryId,
    required String inventoryItemId,
    required String qty,
    required String userId,
  }) {
    return _remoteDataSource.addItemToCustomPackage(
      jobCardNumber: jobCardNumber,
      lineId: lineId,
      categoryId: categoryId,
      inventoryItemId: inventoryItemId,
      qty: qty,
      userId: userId,
    );
  }

  @override
  Future<OperationResultEntity> deleteCustomPackageItem({
    required String srLineId,
  }) {
    return _remoteDataSource.deleteCustomPackageItem(srLineId: srLineId);
  }

  @override
  Future<List<JobCardPackageLineEntity>> getJobCardPackageLines({
    required String srNumber,
    String? packageId,
  }) async {
    final models = await _remoteDataSource.getJobCardPackageLines(
      srNumber: srNumber,
      packageId: packageId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<OperationResultEntity> addPackageToJobCard({
    required String srNumber,
    required String packageId,
    required String userId,
    String campaignLineId = '',
  }) {
    return _remoteDataSource.addPackageToJobCard(
      srNumber: srNumber,
      packageId: packageId,
      userId: userId,
      campaignLineId: campaignLineId,
    );
  }

  @override
  Future<OperationResultEntity> deletePackageFromJobCard({
    required String packageLineId,
    required String userId,
  }) {
    return _remoteDataSource.deletePackageFromJobCard(
      packageLineId: packageLineId,
      userId: userId,
    );
  }

  @override
  Future<OperationResultEntity> postChecklist({
    required String srNumber,
    required String checklistId,
    required Map<String, dynamic> data,
  }) {
    return _remoteDataSource.postChecklist(
      srNumber: srNumber,
      checklistId: checklistId,
      data: data,
    );
  }

  @override
  Future<List<JobCardPackageEntity>> getPackagesOfJobCard({
    required String srNumber,
  }) async {
    final models = await _remoteDataSource.getPackagesOfJobCard(
      srNumber: srNumber,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
