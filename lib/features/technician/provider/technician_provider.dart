import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../data/data_source/i_technician_remote_data_source.dart';
import '../data/data_source/technician_remote_data_source.dart';
import '../data/repository/technician_repository.dart';
import '../domain/repository/i_technician_repository.dart';
import '../domain/use_case/search_nearby_technicians_use_case.dart';
import '../presentation/view_model/technician_search_state.dart';
import '../presentation/view_model/technician_search_view_model.dart';

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

final technicianSearchViewModelProvider = StateNotifierProvider.autoDispose<
  TechnicianSearchViewModel,
  TechnicianSearchState
>((ref) {
  return TechnicianSearchViewModel(
    ref.read(searchNearbyTechniciansUseCaseProvider),
  );
});
