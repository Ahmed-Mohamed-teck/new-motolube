
import 'package:dio/dio.dart';
import 'package:newmotorlube/core/providers/dio_provider.dart';
import 'package:newmotorlube/features/user_cars/data/model/car_brand_model.dart';
import 'package:newmotorlube/features/user_cars/data/model/manufacture_model.dart';

import '../../../../core/utils/end_point.dart';
import '../model/car_model.dart';
import 'i_user_car_remote_data_source.dart';

class UserCarsRemoteDataSourceImpl extends IUserCarRemoteDataSource{
  final Dio dio;

  UserCarsRemoteDataSourceImpl(this.dio);

  @override
  Future<void> addCar({required CarModel car}) async{
    try{
      print(car.toJson());
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<void> deleteCar({required String carId}) {
    // TODO: implement deleteCar
    throw UnimplementedError();
  }

  @override
  Future<CarModel> getCarById({required String carId}) {
    // TODO: implement getCarById
    throw UnimplementedError();
  }

  @override
  Future<List<CarModel>> getCars({required String customerId}) {
    // TODO: implement getCars
    throw UnimplementedError();
  }

  @override
  Future<void> updateCar({required String carId, required CarModel updatedCar}) {
    // TODO: implement updateCar
    throw UnimplementedError();
  }

  @override
  Future<List<ManufactureModel>> getManufacturers() async{
    try {
      final res = await dio.get(getManufacturersEndPoint);
      final data = res.data as Map<String, dynamic>;
      final List<ManufactureModel> manufactures = ManufacturesModel.fromJson(data).manufactures;
      if(manufactures.isEmpty){
        throw Exception('No manufacturers found');
      }
      return manufactures;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<CarBrandModel>> getCarModels({required String carModelId}) async{
    try {
      final res = await dio.get(getCarModelsEndPoint(carModelId));
      final data = res.data as Map<String, dynamic>;
      final List<CarBrandModel> carBrands = CarBrandsModel.fromJson(data).carBrands;
      if(carBrands.isEmpty){
        throw Exception('No car brands found');
      }
      return carBrands;
    } on DioException {
      rethrow;
    }
  }

}