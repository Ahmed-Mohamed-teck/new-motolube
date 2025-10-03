import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../data/data_source/book_service_remote_data_source.dart';
import '../data/data_source/i_book_service_remote_data_source.dart';
import '../data/repository/book_service_repository.dart';
import '../domain/repository/i_book_service_repository.dart';
import '../domain/use_case/get_packages_for_vehicle_use_case.dart';
import '../presentation/view_model/service_packages_state.dart';
import '../presentation/view_model/service_packages_view_model.dart';

final bookServiceRemoteDataSourceProvider =
    Provider<IBookServiceRemoteDataSource>((ref) {
      return BookServiceRemoteDataSource(ref.read(dioProvider));
    });

final bookServiceRepositoryProvider = Provider<IBookServiceRepository>((ref) {
  return BookServiceRepository(ref.read(bookServiceRemoteDataSourceProvider));
});

final getPackagesForVehicleUseCaseProvider =
    Provider<GetPackagesForVehicleUseCase>((ref) {
      return GetPackagesForVehicleUseCase(
        ref.read(bookServiceRepositoryProvider),
      );
    });

final servicePackagesViewModelProvider = StateNotifierProvider.autoDispose<
  ServicePackagesViewModel,
  ServicePackagesState
>((ref) {
  return ServicePackagesViewModel(
    ref.read(getPackagesForVehicleUseCaseProvider),
  );
});
