import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../data/data_source/i_upcoming_service_remote_data_source.dart';
import '../data/data_source/upcoming_service_remote_data_source.dart';
import '../data/repository/upcoming_service_repository.dart';
import '../domain/repository/i_upcoming_service_repository.dart';
import '../domain/use_case/cancel_appointment_use_case.dart';
import '../domain/use_case/get_upcoming_services_use_case.dart';
import '../presentation/view_model/upcoming_service_state.dart';
import '../presentation/view_model/upcoming_service_action_state.dart';
import '../presentation/view_model/upcoming_service_action_view_model.dart';
import '../presentation/view_model/upcoming_service_view_model.dart';

final upcomingServiceRemoteDataSourceProvider =
    Provider<IUpcomingServiceRemoteDataSource>((ref) {
  return UpcomingServiceRemoteDataSourceImpl(ref.read(dioProvider));
});

final upcomingServiceRepositoryProvider =
    Provider<IUpcomingServiceRepository>((ref) {
  return UpcomingServiceRepository(
    ref.read(upcomingServiceRemoteDataSourceProvider),
    ref.read(authLocalRepositoryProvider),
  );
});

final getUpcomingServicesUseCaseProvider =
    Provider<GetUpcomingServicesUseCase>((ref) {
  return GetUpcomingServicesUseCase(
    ref.read(upcomingServiceRepositoryProvider),
  );
});

final cancelAppointmentUseCaseProvider =
    Provider<CancelAppointmentUseCase>((ref) {
  return CancelAppointmentUseCase(
    ref.read(upcomingServiceRepositoryProvider),
  );
});

final upcomingServiceViewModelProvider = StateNotifierProvider.autoDispose<
    UpcomingServiceViewModel, UpcomingServiceState>((ref) {
  return UpcomingServiceViewModel(
    ref.read(getUpcomingServicesUseCaseProvider),
  );
});

final upcomingServiceActionViewModelProvider =
    StateNotifierProvider.autoDispose<UpcomingServiceActionViewModel,
        UpcomingServiceActionState>((ref) {
  return UpcomingServiceActionViewModel(
    ref.read(cancelAppointmentUseCaseProvider),
  );
});
