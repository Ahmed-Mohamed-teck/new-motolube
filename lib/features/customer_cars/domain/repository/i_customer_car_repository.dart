 import 'package:newmotorlube/features/customer_cars/domain/entity/car_entity.dart';

 abstract class ICustomerCarRepository {
  Future<void> addCar({required CarEntity car});
  Future<void> updateCar({required String carId,required CarEntity updatedCar});
  Future<void> deleteCar({required String carId});
  Future<List<CarEntity>> getCustomerCars();
}