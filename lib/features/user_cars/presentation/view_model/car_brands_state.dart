import 'package:newmotorlube/features/user_cars/domain/entity/car_brand_entity.dart';


abstract class CarBrandsState {}


class CarBrandsInitial extends CarBrandsState {}

class CarBrandsLoading extends CarBrandsState {}

class CarBrandsLoaded extends CarBrandsState {
  final List<CarBrandEntity> carBrands;

  CarBrandsLoaded(this.carBrands);
}

class CarBrandsError extends CarBrandsState {
  final String message;

  CarBrandsError(this.message);
}