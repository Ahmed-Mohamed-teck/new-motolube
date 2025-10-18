import '../../domain/entity/upcoming_service_entity.dart';

class UpcomingServiceModel extends UpcomingServiceEntity {
  UpcomingServiceModel({
    required super.appointmentId,
    required super.serviceName,
    required super.status,
    required super.appointmentDateText,
    super.appointmentDate,
    super.timeSlot,
    super.location,
    super.carTitle,
    super.plateText,
    super.packageTitle,
    super.branchLabel,
    super.technicianLabel,
  });

  factory UpcomingServiceModel.fromJson(Map<String, dynamic> json) {
    final appointmentId = (json['bookingId'] ?? '').toString();

    final serviceName = (json['package_name_en'] ?? '').toString();

    final status = (json['booking_status'] ?? '').toString();

    final location = (json['branch_name'] ?? '').toString();

    final timeSlot = json['slotTime']?.toString();

    final rawDate = (json['bookingDate'] ?? '').toString();

    DateTime? parsedDate;
    if (rawDate.isNotEmpty) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    final vehicleName = (json['brand'] ?? '').toString();

    final plate = (json['plate_en'] ?? '').toString();

    final package = serviceName.isNotEmpty
        ? serviceName
        : (json['package_name_ar'] ?? '').toString();

    final technician = (json['tech_name_en'] ?? '').toString();

    return UpcomingServiceModel(
      appointmentId: appointmentId,
      serviceName: serviceName,
      status: status,
      appointmentDateText: rawDate,
      appointmentDate: parsedDate,
      timeSlot: timeSlot,
      location: location.isEmpty ? null : location,
      carTitle: vehicleName,
      plateText: plate,
      packageTitle: package.isEmpty ? serviceName : package,
      branchLabel: location,
      technicianLabel: technician,
    );
  }

  factory UpcomingServiceModel.fromEntity(UpcomingServiceEntity entity) {
    return UpcomingServiceModel(
      appointmentId: entity.appointmentId,
      serviceName: entity.serviceName,
      status: entity.status,
      appointmentDateText: entity.appointmentDateText,
      appointmentDate: entity.appointmentDate,
      timeSlot: entity.timeSlot,
      location: entity.location,
      carTitle: entity.carTitle,
      plateText: entity.plateText,
      packageTitle: entity.packageTitle,
      branchLabel: entity.branchLabel,
      technicianLabel: entity.technicianLabel,
    );
  }
}
