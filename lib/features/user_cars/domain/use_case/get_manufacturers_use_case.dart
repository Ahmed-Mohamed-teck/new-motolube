import '../entity/manufacture_entity.dart';
import '../repository/i_user_car_repository.dart';

class GetManufacturersUseCase {
  final IUserCarRepository _repository;
  GetManufacturersUseCase(this._repository);
  Future<List<ManufactureEntity>> call() {
    return _repository.getManufacturers();
  }
}