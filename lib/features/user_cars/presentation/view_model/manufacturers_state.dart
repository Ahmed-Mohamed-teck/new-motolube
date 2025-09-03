import '../../domain/entity/manufacture_entity.dart';

abstract class ManufacturersState {}


class ManufacturersInitial extends ManufacturersState {}

class ManufacturersLoading extends ManufacturersState {}

class ManufacturersLoaded extends ManufacturersState {
  final List<ManufactureEntity> manufacturers;

  ManufacturersLoaded(this.manufacturers);
}

class ManufacturersError extends ManufacturersState {
  final String message;

  ManufacturersError(this.message);
}