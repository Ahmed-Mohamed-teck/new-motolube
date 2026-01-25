import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/dio_provider.dart';

import '../data/data_source/home_remote_data_source.dart';
import '../data/data_source/i_home_remote_data_source.dart';
import '../data/repository/home_repository.dart';
import '../domain/entity/main_category_entity.dart';
import '../domain/repository/i_home_repository.dart';
import '../domain/use_case/get_main_categories_use_case.dart';
import '../presentaion/view_model/main_categories_state.dart';
import '../presentaion/view_model/main_categories_view_model.dart';

final homeRemoteDataSourceProvider = Provider<IHomeRemoteDataSource>((ref) {
  return HomeRemoteDataSource(ref.read(dioProvider));
});

final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  return HomeRepository(ref.read(homeRemoteDataSourceProvider));
});

final getMainCategoriesUseCaseProvider =
    Provider<GetMainCategoriesUseCase>((ref) {
  return GetMainCategoriesUseCase(ref.read(homeRepositoryProvider));
});

final mainCategoriesViewModelProvider = StateNotifierProvider.autoDispose<
    MainCategoriesViewModel, MainCategoriesState>((ref) {
  return MainCategoriesViewModel(ref.read(getMainCategoriesUseCaseProvider));
});

final selectedMainCategoryProvider =
    StateProvider<MainCategoryEntity?>((ref) => null);
