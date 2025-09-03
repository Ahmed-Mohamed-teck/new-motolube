import 'dart:ffi';

import '../../domain/entity/car_entity.dart';


class CarModel extends CarEntity {
  CarModel({
    required super.id,
    required super.oraIdStage,
    required super.oraPartyId,
    required super.oraVehicleId,
    required super.arabicPlate,
    required super.englishPlate,
    required super.carModel,
    required super.creationDate,
    required super.manufacturer,
    required super.modelYear,
    required super.carImages,
    required super.vinNumber,

  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as String,
      oraIdStage: json['oraIdStage'] as String,
      oraPartyId: json['oraPartyId'] as String,
      oraVehicleId: json['oraVehicleId'] as String,
      arabicPlate: (json['arabicPlate'] as List<String>)
          .map((item) => item)
          .toList(),
      englishPlate: (json['englishPlate'] as List<String>)
          .map((item) => item)
          .toList(),
      carModel: json['carModel'] as String,
      creationDate: json['creationDate'] as String,
      manufacturer: json['manufacturer'] as String,
      modelYear: json['modelYear'] as String,
      carImages: (json['carImages'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      vinNumber: json['vinNumber'] as String,
    );
  }

  factory CarModel.fromEntity(CarEntity entity) {
    return CarModel(
      id: entity.id,
      oraIdStage: entity.oraIdStage,
      oraPartyId: entity.oraPartyId,
      oraVehicleId: entity.oraVehicleId,
      arabicPlate: entity.arabicPlate,
      englishPlate: entity.englishPlate,
      carModel: entity.carModel,
      creationDate: entity.creationDate,
      manufacturer: entity.manufacturer,
      modelYear: entity.modelYear,
      carImages: entity.carImages,
      vinNumber: entity.vinNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oraIdStage': oraIdStage,
      'oraPartyId': oraPartyId,
      'oraVehicleId': oraVehicleId,
      'arabicPlate': arabicPlate.map((item) => item.toString()).toList(),
      'englishPlate': englishPlate.map((item) => item.toString()).toList(),
      'carModel': carModel,
      'creationDate': creationDate,
      'manufacturer': manufacturer,
      'modelYear': modelYear,
      'carImages': carImages,
      'vinNumber': vinNumber,
    };
  }
}