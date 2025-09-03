import 'package:newmotorlube/features/user_cars/data/model/car_brand_model.dart';
import 'package:newmotorlube/features/user_cars/data/model/manufacture_model.dart';

import '../model/car_model.dart';

abstract class IUserCarRemoteDataSource {
  Future<void> addCar({required CarModel car});
  Future<void> deleteCar({required String carId});
  Future<List<CarModel>> getCars({required String customerId});
  Future<CarModel> getCarById({required String carId});
  Future<List<ManufactureModel>> getManufacturers();
  Future<List<CarBrandModel>> getCarModels({required String carModelId});
}