import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/user_cars/domain/use_case/get_car_brands_model_use_case.dart';
import 'package:newmotorlube/features/user_cars/domain/use_case/get_manufacturers_use_case.dart';

import '../../../core/providers/dio_provider.dart';
import '../data/data_source/i_user_car_remote_data_source.dart';
import '../data/data_source/user_car_remote_data_source.dart';
import '../data/repository/user_car_repository.dart';
import '../domain/repository/i_user_car_repository.dart';
import '../presentation/view_model/car_brands_state.dart';
import '../presentation/view_model/car_brands_view_model.dart';
import '../presentation/view_model/manufacturers_state.dart';
import '../presentation/view_model/manufacturers_view_model.dart';

final userCarsRemoteDataSourceProvider = Provider<IUserCarRemoteDataSource>((ref) {
  return UserCarsRemoteDataSourceImpl(ref.read(dioProvider));
});

final userCarsRepositoryProvider = Provider<IUserCarRepository>((ref) {
  final remoteDataSource = ref.read(userCarsRemoteDataSourceProvider);
  return UserCarRepository(remoteDataSource);
});

final getManufacturersUseCaseProvider = Provider<GetManufacturersUseCase>((ref) {
  return GetManufacturersUseCase(ref.read(userCarsRepositoryProvider));
});

final getCarBrandsUseCaseProvider = Provider<GetCarBrandsModelUseCase>((ref) {
  return GetCarBrandsModelUseCase(ref.read(userCarsRepositoryProvider));
});


final manufacturersViewModelProvider = StateNotifierProvider.autoDispose<ManufacturersViewModel, ManufacturersState>((ref) {
  return ManufacturersViewModel(ref.read(getManufacturersUseCaseProvider));
});


final carBrandsViewModelProvider = StateNotifierProvider.autoDispose<CarBrandsViewModel, CarBrandsState>((ref) {
  return CarBrandsViewModel(ref.read(getCarBrandsUseCaseProvider));
});


