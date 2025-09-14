import 'package:newmotorlube/features/user_cars/domain/entity/car_entity.dart';
import 'package:newmotorlube/features/user_cars/domain/repository/i_user_car_repository.dart';


class GetUserCarsUseCase {
  final IUserCarRepository _repository;

  GetUserCarsUseCase(this._repository);

  Future<List<CarEntity>> call() {
    return _repository.getUserCars();
  }
}

