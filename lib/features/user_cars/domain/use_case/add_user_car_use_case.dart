import '../entity/car_entity.dart';
import '../repository/i_user_car_repository.dart';

class AddUserCarUseCase {
  final IUserCarRepository _repository;
  AddUserCarUseCase(this._repository);

  Future<void> call({required CarEntity car}) {
    return _repository.addCar(car: car);
  }
}