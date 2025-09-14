
import 'package:dio/dio.dart';
import 'package:newmotorlube/core/providers/dio_provider.dart';
import 'package:newmotorlube/features/auth/domain/repository/i_auth_local_repository.dart';
import 'package:newmotorlube/features/user_cars/data/model/car_brand_model.dart';
import 'package:newmotorlube/features/user_cars/data/model/manufacture_model.dart';

import '../../../../core/utils/end_point.dart';
import '../model/car_model.dart';
import 'i_user_car_remote_data_source.dart';

class UserCarsRemoteDataSourceImpl extends IUserCarRemoteDataSource{
  final Dio dio;
  final IAuthLocalRepository _authLocalRepository;

  UserCarsRemoteDataSourceImpl(this.dio, this._authLocalRepository);

  @override
  Future<void> addCar({required CarModel car}) async{
    try{
      final storedAuth = await _authLocalRepository.getStoredAuth();
      final oracleId = storedAuth?.oracleId;
      if (oracleId == null || oracleId.isEmpty) {
        throw Exception('Missing oracleId in stored auth');
      }
      await dio.post(
        addVehicleEndPoint,
        data: car.toJson(oracleId),
      );
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
  Future<List<CarModel>> getCars({required String customerId}) async {
    try {
      String id = customerId;
      if (id.isEmpty) {
        final storedAuth = await _authLocalRepository.getStoredAuth();
        id = storedAuth?.oracleId ?? '';
      }
      if (id.isEmpty) {
        throw Exception('Missing customerId');
      }

      final res = await dio.get(getCarsForCustomerEndPoint(id));
      final data = res.data;

      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        final maybeList = data['vehicles'] ?? data['data'] ?? data['items'];
        if (maybeList is List) {
          rawList = maybeList;
        } else {
          rawList = const [];
        }
      } else {
        rawList = const [];
      }

      final cars = rawList
          .map((e) => CarModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      if (cars.isEmpty) {
        throw Exception('No cars found');
      }
      return cars;
    } on DioException {
      rethrow;
    }
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
