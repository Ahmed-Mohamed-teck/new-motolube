import 'package:newmotorlube/features/user_cars/domain/entity/car_brand_entity.dart';

import '../entity/manufacture_entity.dart';
import '../repository/i_user_car_repository.dart';

class GetCarBrandsModelUseCase {
  final IUserCarRepository _repository;
  GetCarBrandsModelUseCase(this._repository);
  Future<List<CarBrandEntity>> call({required String carModelId}) {
    return _repository.getCarBrands(carModelId: carModelId);
  }
}