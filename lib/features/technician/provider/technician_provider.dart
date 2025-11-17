import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../data/data_source/i_technician_remote_data_source.dart';
import '../data/data_source/technician_remote_data_source.dart';
import '../data/repository/technician_repository.dart';
import '../domain/entity/booking_status.dart';
import '../domain/entity/job_card_package_entity.dart';
import '../domain/repository/i_technician_repository.dart';
import '../domain/use_case/get_booking_statuses_use_case.dart';
import '../domain/use_case/create_job_card_use_case.dart';
import '../domain/use_case/get_job_card_packages_use_case.dart';
import '../domain/use_case/get_technician_appointments_use_case.dart';
import '../domain/use_case/get_technician_available_slots_use_case.dart';
import '../domain/use_case/search_nearby_technicians_use_case.dart';
import '../domain/use_case/update_appointment_status_use_case.dart';
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

final getJobCardPackagesUseCaseProvider = Provider<GetJobCardPackagesUseCase>((
  ref,
) {
  return GetJobCardPackagesUseCase(ref.read(technicianRepositoryProvider));
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
