import '../entity/car_entity.dart';
import '../repository/i_user_car_repository.dart';

class UpdateUserCarUseCase {
  final IUserCarRepository _repository;
  UpdateUserCarUseCase(this._repository);

  Future<void> call({required CarEntity car}) {
    return _repository.updateCar(car: car);
  }
}
