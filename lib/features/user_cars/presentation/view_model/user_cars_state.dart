import '../../domain/entity/car_entity.dart';

sealed class UserCarsState {
  const UserCarsState();
}

class UserCarsInitial extends UserCarsState {
  const UserCarsInitial();
}

class UserCarsLoading extends UserCarsState {
  const UserCarsLoading();
}

class UserCarsLoaded extends UserCarsState {
  final List<CarEntity> cars;
  const UserCarsLoaded(this.cars);
}

class UserCarsError extends UserCarsState {
  final String message;
  const UserCarsError(this.message);
}

