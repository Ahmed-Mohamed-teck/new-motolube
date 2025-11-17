import '../../domain/entity/booking_status.dart';

class TechnicianBookingStatusModel extends TechnicianBookingStatus {
  TechnicianBookingStatusModel({
    required super.label,
    required super.code,
    required super.hexColor,
  });

  factory TechnicianBookingStatusModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['Id'] ?? '').toString();
    final name = (json['name'] ?? json['Name'] ?? '').toString();
    final color = (json['hexColor'] ?? json['HexColor'] ?? '').toString();
    return TechnicianBookingStatusModel(label: name, code: id, hexColor: color);
  }

  TechnicianBookingStatus toEntity() {
    return TechnicianBookingStatus(
      label: label,
      code: code,
      hexColor: hexColor,
    );
  }
}
