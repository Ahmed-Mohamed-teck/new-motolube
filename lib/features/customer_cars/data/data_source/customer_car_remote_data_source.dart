import 'package:newmotorlube/features/customer_cars/data/data_source/i_customer_car_remote_data_source.dart';
import 'package:newmotorlube/features/customer_cars/data/model/car_model.dart';

class CustomerCarRemoteDataSourceImpl extends ICustomerCarRemoteDataSource{
  @override
  Future<void> addCar({required CarModel car}) {
    // TODO: implement addCar
    throw UnimplementedError();
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

}