import 'dart:ffi';

import '../../domain/entity/car_entity.dart';





class CarModel extends CarEntity {
  CarModel({
    required super.vehicleId,
    required super.mileage,
    required super.arabicPlate,
    required super.englishPlate,
    required super.carModel,
    required super.manufacturer,
    required super.modelYear,
    required super.carImages,
    required super.vinNumber,

  });

  factory CarModel.fromJson(Map<String, dynamic> json) {


    final List<String> images = (json['photoUrl'] as String?)
            ?.split(',')
            .map<String>((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];



    return CarModel(
      vehicleId: json['vehiclE_ID'] as String,
      mileage: json['mileage'] as String? ?? '0',
      arabicPlate: (json['platE_AR'] as String).split(''),
      englishPlate: (json['platE_EN'] as String).split(''),
      carModel: json['modeL_NUMBER'] as String? ?? '',
      manufacturer: json['manufactureR_NAME'] as String? ?? '',
      modelYear: json['yeaR_MANUFACTURED'] as String? ?? '',
      carImages: images,
      // carImages: (json['photoUrl'] as List<dynamic> ? ?? [])
      //     .map((item) => item as String)
      //     .toList(),
      vinNumber: json['vin'] as String? ?? '',
    );
  }

  factory CarModel.fromEntity(CarEntity entity) {
    return CarModel(
      vehicleId: entity.vehicleId,
      mileage: entity.mileage,
      arabicPlate: entity.arabicPlate,
      englishPlate: entity.englishPlate,
      carModel: entity.carModel,
      manufacturer: entity.manufacturer,
      modelYear: entity.modelYear,
      carImages: entity.carImages,
      vinNumber: entity.vinNumber,
    );
  }

  Map<String, dynamic> toJson(String userId) {
    return {
      'customeR_ID': userId,
      'plate_ar': arabicPlate.join(''),
      'plate_en': englishPlate.join(''),
      'model_number': carModel,
      'manufacturer_name': manufacturer,
      'year_manufactured': modelYear,
      'photoBase64': carImages.toList(),
      'vin': vinNumber,
    };
  }
}




