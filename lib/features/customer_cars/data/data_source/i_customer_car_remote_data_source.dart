import '../model/car_model.dart';

abstract class ICustomerCarRemoteDataSource {
  Future<void> addCar({required CarModel car});
  Future<void> updateCar({required String carId, required CarModel updatedCar});
  Future<void> deleteCar({required String carId});
  Future<List<CarModel>> getCars({required String customerId});
  Future<CarModel> getCarById({required String carId});
}