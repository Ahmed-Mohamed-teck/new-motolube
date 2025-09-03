
 import 'package:newmotorlube/features/user_cars/domain/entity/car_brand_entity.dart';
import 'package:newmotorlube/features/user_cars/domain/entity/manufacture_entity.dart';

import '../entity/car_entity.dart';

abstract class IUserCarRepository {
  Future<void> addCar({required CarEntity car});
  Future<void> deleteCar({required String carId});
  Future<List<CarEntity>> getUserCars();
  Future<List<ManufactureEntity>> getManufacturers();
  Future<List<CarBrandEntity>> getCarBrands({required String carModelId});
}