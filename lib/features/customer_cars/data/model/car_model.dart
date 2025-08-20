import 'package:newmotorlube/features/customer_cars/domain/entity/car_entity.dart';

class CarModel extends CarEntity {
  CarModel({
    required super.id,
    required super.name,
    required super.model,
    required super.year,
    required super.vin,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      vin: json['vin'] as String,
    );
  }

  factory CarModel.fromEntity(CarEntity entity) {
    return CarModel(
      id: entity.id,
      name: entity.name,
      model: entity.model,
      year: entity.year,
      vin: entity.vin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'year': year,
      'vin': vin,
    };
  }
}