import 'dart:ffi';

class CarEntity {
  final String id;
  final String oraIdStage;
  final String oraPartyId;
  final String oraVehicleId;
  final List<String> arabicPlate;
  final List<String> englishPlate;
  final String carModel;
  final String creationDate;
  final String manufacturer;
  final String modelYear;
  final List<String> carImages;
  final String vinNumber;



  CarEntity({
    required this.id,
    required this.oraIdStage,
    required this.oraPartyId,
    required this.oraVehicleId,
    required this.arabicPlate,
    required this.englishPlate,
    required this.carModel,
    required this.creationDate,
    required this.manufacturer,
    required this.modelYear,
    required this.carImages,
    required this.vinNumber,
  });


}