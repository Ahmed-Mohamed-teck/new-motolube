import 'package:newmotorlube/features/user_cars/domain/entity/car_brand_entity.dart';
import 'package:newmotorlube/features/user_cars/domain/entity/manufacture_entity.dart';

import '../../domain/entity/car_entity.dart';
import '../../domain/repository/i_user_car_repository.dart';
import '../data_source/i_user_car_remote_data_source.dart';
import '../model/car_model.dart';

class UserCarRepository extends IUserCarRepository {
  final IUserCarRemoteDataSource _remoteDataSource;

  UserCarRepository(this._remoteDataSource);

  @override
  Future<void> addCar({required CarEntity car}) {
    final carModel = CarModel.fromEntity(car);
    return _remoteDataSource.addCar(car: carModel);
  }

  @override
  Future<void> updateCar({required CarEntity car}) {
    final carModel = CarModel.fromEntity(car);
    return _remoteDataSource.updateCar(car: carModel);
  }

  @override
  Future<List<CarEntity>> getUserCars({String? customerId}) async {
    final resolvedCustomerId = customerId ?? '';
    final List<CarModel> carModels =
        await _remoteDataSource.getCars(customerId: resolvedCustomerId);
    return carModels.map((carModel) => CarModel.fromEntity(carModel)).toList();
  }

  @override
  Future<List<ManufactureEntity>> getManufacturers() {
    return _remoteDataSource.getManufacturers();
  }

  @override
  Future<List<CarBrandEntity>> getCarBrands({required String carModelId}) {
    return _remoteDataSource.getCarModels(carModelId: carModelId);
  }


}
