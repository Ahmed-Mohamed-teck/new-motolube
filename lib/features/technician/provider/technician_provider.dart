import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../data/data_source/i_technician_remote_data_source.dart';
import '../data/data_source/technician_remote_data_source.dart';
import '../data/repository/technician_repository.dart';
import '../domain/entity/booking_status.dart';
import '../domain/entity/custom_package_category_entity.dart';
import '../domain/entity/custom_package_item_entity.dart';
import '../domain/entity/job_card_package_entity.dart';
import '../domain/entity/job_card_package_line_entity.dart';
import '../domain/repository/i_technician_repository.dart';
import '../domain/use_case/add_custom_package_item_use_case.dart';
import '../domain/use_case/add_package_to_job_card_use_case.dart';
import '../domain/use_case/complete_service_request_use_case.dart';
import '../domain/use_case/create_job_card_use_case.dart';
import '../domain/use_case/delete_custom_package_item_use_case.dart';
import '../domain/use_case/delete_package_from_job_card_use_case.dart';
import '../domain/use_case/get_booking_statuses_use_case.dart';
import '../domain/use_case/get_job_card_package_lines_use_case.dart';
import '../domain/use_case/get_custom_package_categories_use_case.dart';
import '../domain/use_case/get_custom_package_items_use_case.dart';
import '../domain/use_case/get_job_card_packages_use_case.dart';
import '../domain/use_case/get_packages_of_job_card_use_case.dart';
import '../domain/use_case/get_technician_appointments_use_case.dart';
import '../domain/use_case/get_technician_available_slots_use_case.dart';
import '../domain/use_case/post_checklist_use_case.dart';
import '../domain/use_case/search_nearby_technicians_use_case.dart';
import '../domain/use_case/update_appointment_status_use_case.dart';
import '../presentation/view_model/job_card_operation_state.dart';
import '../presentation/view_model/job_card_operation_view_model.dart';
import '../presentation/view_model/technician_appointment_update_state.dart';
import '../presentation/view_model/technician_appointment_update_view_model.dart';
import '../presentation/view_model/technician_appointments_state.dart';
import '../presentation/view_model/technician_appointments_view_model.dart';
import '../presentation/view_model/technician_search_state.dart';
import '../presentation/view_model/technician_search_view_model.dart';
import '../presentation/view_model/technician_slots_state.dart';
import '../presentation/view_model/technician_slots_view_model.dart';

final technicianRemoteDataSourceProvider =
    Provider<ITechnicianRemoteDataSource>((ref) {
      return TechnicianRemoteDataSource(ref.read(dioProvider));
    });

final technicianRepositoryProvider = Provider<ITechnicianRepository>((ref) {
  return TechnicianRepository(ref.read(technicianRemoteDataSourceProvider));
});

final searchNearbyTechniciansUseCaseProvider =
    Provider<SearchNearbyTechniciansUseCase>((ref) {
      return SearchNearbyTechniciansUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final getTechnicianAvailableSlotsUseCaseProvider =
    Provider<GetTechnicianAvailableSlotsUseCase>((ref) {
      return GetTechnicianAvailableSlotsUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final getTechnicianAppointmentsUseCaseProvider =
    Provider<GetTechnicianAppointmentsUseCase>((ref) {
      return GetTechnicianAppointmentsUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final getBookingStatusesUseCaseProvider = Provider<GetBookingStatusesUseCase>((
  ref,
) {
  return GetBookingStatusesUseCase(ref.read(technicianRepositoryProvider));
});

final updateAppointmentStatusUseCaseProvider =
    Provider<UpdateAppointmentStatusUseCase>((ref) {
  return UpdateAppointmentStatusUseCase(
    ref.read(technicianRepositoryProvider),
  );
});

final createJobCardUseCaseProvider = Provider<CreateJobCardUseCase>((ref) {
  return CreateJobCardUseCase(ref.read(technicianRepositoryProvider));
});

final completeServiceRequestUseCaseProvider =
    Provider<CompleteServiceRequestUseCase>((ref) {
      return CompleteServiceRequestUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final getJobCardPackagesUseCaseProvider = Provider<GetJobCardPackagesUseCase>((
  ref,
) {
  return GetJobCardPackagesUseCase(ref.read(technicianRepositoryProvider));
});

final getPackagesOfJobCardUseCaseProvider =
    Provider<GetPackagesOfJobCardUseCase>((ref) {
      return GetPackagesOfJobCardUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final getJobCardPackageLinesUseCaseProvider =
    Provider<GetJobCardPackageLinesUseCase>((ref) {
      return GetJobCardPackageLinesUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final getCustomPackageCategoriesUseCaseProvider =
    Provider<GetCustomPackageCategoriesUseCase>((ref) {
      return GetCustomPackageCategoriesUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final getCustomPackageItemsUseCaseProvider =
    Provider<GetCustomPackageItemsUseCase>((ref) {
      return GetCustomPackageItemsUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final addCustomPackageItemUseCaseProvider =
    Provider<AddCustomPackageItemUseCase>((ref) {
      return AddCustomPackageItemUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final deleteCustomPackageItemUseCaseProvider =
    Provider<DeleteCustomPackageItemUseCase>((ref) {
      return DeleteCustomPackageItemUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final addPackageToJobCardUseCaseProvider =
    Provider<AddPackageToJobCardUseCase>((ref) {
      return AddPackageToJobCardUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final deletePackageFromJobCardUseCaseProvider =
    Provider<DeletePackageFromJobCardUseCase>((ref) {
      return DeletePackageFromJobCardUseCase(
        ref.read(technicianRepositoryProvider),
      );
    });

final postChecklistUseCaseProvider = Provider<PostChecklistUseCase>((ref) {
  return PostChecklistUseCase(ref.read(technicianRepositoryProvider));
});

final technicianSearchViewModelProvider = StateNotifierProvider.autoDispose<
  TechnicianSearchViewModel,
  TechnicianSearchState
>((ref) {
  return TechnicianSearchViewModel(
    ref.read(searchNearbyTechniciansUseCaseProvider),
  );
});

final technicianSlotsViewModelProvider = StateNotifierProvider.autoDispose<
  TechnicianSlotsViewModel,
  TechnicianSlotsState
>((ref) {
  return TechnicianSlotsViewModel(
    ref.read(getTechnicianAvailableSlotsUseCaseProvider),
  );
});

final technicianAppointmentsViewModelProvider =
    StateNotifierProvider.autoDispose<
      TechnicianAppointmentsViewModel,
      TechnicianAppointmentsState
    >((ref) {
      return TechnicianAppointmentsViewModel(
        ref.read(getTechnicianAppointmentsUseCaseProvider),
      );
    });

final technicianBookingStatusesProvider =
    FutureProvider.autoDispose<List<TechnicianBookingStatus>>((ref) async {
      return ref.read(getBookingStatusesUseCaseProvider)();
    });

final technicianAppointmentUpdateViewModelProvider =
    StateNotifierProvider.autoDispose<
      TechnicianAppointmentUpdateViewModel,
      TechnicianAppointmentUpdateState
    >((ref) {
      return TechnicianAppointmentUpdateViewModel(
        ref.read(updateAppointmentStatusUseCaseProvider),
      );
    });

final technicianJobCardPackagesProvider = FutureProvider.autoDispose
    .family<List<JobCardPackageEntity>, String>((ref, srNumber) async {
      final trimmed = srNumber.trim();
      if (trimmed.isEmpty) return const <JobCardPackageEntity>[];
      return ref.read(getJobCardPackagesUseCaseProvider)(srNumber: trimmed);
    });

final customPackageCategoriesProvider =
    FutureProvider.autoDispose<List<CustomPackageCategoryEntity>>((ref) async {
      return ref.read(getCustomPackageCategoriesUseCaseProvider)();
    });

final customPackageItemsProvider = FutureProvider.autoDispose
    .family<List<CustomPackageItemEntity>, CustomPackageItemsRequest>((
      ref,
      request,
    ) async {
      final jobCard = request.jobCardNumber.trim();
      final categoryId = request.categoryId.trim();
      if (jobCard.isEmpty || categoryId.isEmpty) {
        return const <CustomPackageItemEntity>[];
      }
      return ref.read(getCustomPackageItemsUseCaseProvider)(
        jobCardNumber: jobCard,
        categoryId: categoryId,
      );
    });

final jobCardOperationViewModelProvider =
    StateNotifierProvider.autoDispose<
      JobCardOperationViewModel,
      JobCardOperationState
    >((ref) {
  return JobCardOperationViewModel(
    ref.read(addCustomPackageItemUseCaseProvider),
    ref.read(deleteCustomPackageItemUseCaseProvider),
    ref.read(addPackageToJobCardUseCaseProvider),
    ref.read(deletePackageFromJobCardUseCaseProvider),
    ref.read(postChecklistUseCaseProvider),
  );
});

final jobCardPackageLinesProvider = FutureProvider.autoDispose
    .family<List<JobCardPackageLineEntity>, JobCardPackageLinesRequest>((
      ref,
      request,
    ) async {
      final sr = request.srNumber.trim();
      if (sr.isEmpty) return const <JobCardPackageLineEntity>[];
      return ref.read(getJobCardPackageLinesUseCaseProvider)(
        srNumber: sr,
        packageId: request.packageId,
      );
    });

final packagesOfJobCardProvider = FutureProvider.autoDispose
    .family<List<JobCardPackageEntity>, String>((ref, srNumber) async {
      final trimmed = srNumber.trim();
      if (trimmed.isEmpty) return const <JobCardPackageEntity>[];
      return ref.read(getPackagesOfJobCardUseCaseProvider)(srNumber: trimmed);
    });

class CustomPackageItemsRequest {
  const CustomPackageItemsRequest({
    required this.jobCardNumber,
    required this.categoryId,
  });

  final String jobCardNumber;
  final String categoryId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomPackageItemsRequest &&
        other.jobCardNumber == jobCardNumber &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode => Object.hash(jobCardNumber, categoryId);
}

class JobCardPackageLinesRequest {
  const JobCardPackageLinesRequest({
    required this.srNumber,
    this.packageId,
  });

  final String srNumber;
  final String? packageId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobCardPackageLinesRequest &&
        other.srNumber == srNumber &&
        other.packageId == packageId;
  }

  @override
  int get hashCode => Object.hash(srNumber, packageId);
}
