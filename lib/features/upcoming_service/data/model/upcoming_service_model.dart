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
    super.srNumber,
    super.srTotal,
    super.couponNumber,
    super.discount,
  });

  factory UpcomingServiceModel.fromJson(Map<String, dynamic> json) {
    final appointmentId = _stringFor(json, const [
      'bookingid',
    ]);

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

    final srNumber = _stringFor(json, const [
      'sr_number',
      'srNumber',
      'srnumber',
      'job_card_number',
      'jobCardNumber',
    ]);

    final srTotal = _doubleFor(json['sr_total'] ?? json['srTotal']);

    final coupon = _stringFor(json, const ['coupon', 'coupon_number', 'couponNumber']);
    final discount = _doubleFor(json['discount']);

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
      srNumber: srNumber,
      srTotal: srTotal,
      couponNumber: coupon,
      discount: discount,
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
      srNumber: entity.srNumber,
      srTotal: entity.srTotal,
      couponNumber: entity.couponNumber,
      discount: entity.discount,
    );
  }
}

String _stringFor(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (!json.containsKey(key)) continue;
    final value = json[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return '';
}

double _doubleFor(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
