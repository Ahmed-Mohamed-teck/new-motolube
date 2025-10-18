import '../../domain/entity/create_appointment_result.dart';

class CreateAppointmentResponseModel {
  final String infoCode;
  final String infoType;
  final String infoDescriptionAr;
  final String infoDescriptionEn;
  final String infoDescription;

  const CreateAppointmentResponseModel({
    required this.infoCode,
    required this.infoType,
    required this.infoDescriptionAr,
    required this.infoDescriptionEn,
    required this.infoDescription,
  });

  factory CreateAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateAppointmentResponseModel(
      infoCode: (json['infoCode'] ?? '').toString(),
      infoType: (json['infoType'] ?? '').toString(),
      infoDescriptionAr: (json['infoDescriptionAR'] ?? '').toString(),
      infoDescriptionEn: (json['infoDescriptionEN'] ?? '').toString(),
      infoDescription: (json['infoDescription'] ?? '').toString(),
    );
  }

  CreateAppointmentResult toEntity() {
    return CreateAppointmentResult(
      infoCode: infoCode,
      infoType: infoType,
      infoDescriptionAr: infoDescriptionAr,
      infoDescriptionEn: infoDescriptionEn,
      infoDescription: infoDescription,
    );
  }
}
