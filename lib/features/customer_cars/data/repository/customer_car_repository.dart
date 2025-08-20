import 'package:newmotorlube/features/customer_cars/domain/repository/i_customer_car_repository.dart';
import '../../domain/entity/car_entity.dart';
import '../data_source/i_customer_car_remote_data_source.dart';
import '../model/car_model.dart';

class CustomerCarRepository extends ICustomerCarRepository {
  final ICustomerCarRemoteDataSource _remoteDataSource;

  CustomerCarRepository(this._remoteDataSource);

  @override
  Future<void> addCar({required CarEntity car}) {
    final carModel = CarModel.fromEntity(car);
    return _remoteDataSource.addCar(car: carModel);
  }

  @override
  Future<void> updateCar({required String carId, required CarEntity updatedCar}) {
    final updatedCarModel = CarModel.fromEntity(updatedCar);
    return _remoteDataSource.updateCar(carId: carId, updatedCar: updatedCarModel);
  }

  @override
  Future<void> deleteCar({required String carId}) {
    return _remoteDataSource.deleteCar(carId: carId);
  }

  @override
  Future<List<CarEntity>> getCustomerCars() async{
    // Assuming the remote data source returns a list of CarModel
    List<CarModel> carModels = await _remoteDataSource.getCars(customerId: '');
    return carModels.map((carModel) => CarModel.fromEntity(carModel)).toList();
  }
}