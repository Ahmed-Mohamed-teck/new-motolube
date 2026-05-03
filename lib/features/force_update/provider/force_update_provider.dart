import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/general_providers.dart';
import '../data/data_source/force_update_remote_data_source.dart';
import '../data/repository/force_update_repository.dart';
import '../domain/repository/i_force_update_repository.dart';
import '../domain/use_case/check_force_update_use_case.dart';
import '../presentation/view_model/force_update_state.dart';
import '../presentation/view_model/force_update_view_model.dart';

final forceUpdateRemoteDataSourceProvider =
    Provider<ForceUpdateRemoteDataSource>((ref) {
      return ForceUpdateRemoteDataSourceImpl(
        ref.read(firebaseFirestoreProvider),
      );
    });

final forceUpdateRepositoryProvider = Provider<IForceUpdateRepository>((ref) {
  return ForceUpdateRepositoryImpl(
    ref.read(forceUpdateRemoteDataSourceProvider),
  );
});

final checkForceUpdateUseCaseProvider = Provider<CheckForceUpdateUseCase>((
  ref,
) {
  return CheckForceUpdateUseCase(ref.read(forceUpdateRepositoryProvider));
});

final forceUpdateViewModelProvider =
    NotifierProvider<ForceUpdateViewModel, ForceUpdateState>(
      () => ForceUpdateViewModel(),
    );
