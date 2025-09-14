import 'dart:ffi';





class CarEntity {
  final String vehicleId;
  final String mileage;
  final List<String> arabicPlate;
  final List<String> englishPlate;
  final String carModel;
  final String manufacturer;
  final String modelYear;
  final List<String> carImages;
  final String vinNumber;



  CarEntity({
    required this.vehicleId,
    required this.mileage,
    required this.arabicPlate,
    required this.englishPlate,
    required this.carModel,
    required this.manufacturer,
    required this.modelYear,
    required this.carImages,
    required this.vinNumber,
  });


}