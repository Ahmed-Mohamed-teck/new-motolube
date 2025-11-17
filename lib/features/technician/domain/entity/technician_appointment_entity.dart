import 'booking_status.dart';

class TechnicianAppointmentEntity {
  final String bookingId;
  final String bookingDateText;
  final DateTime? bookingDate;
  final String slotTime;
  final String branchId;
  final String vehicleId;
  final String branchName;
  final TechnicianBookingStatus bookingStatus;
  final String customerName;
  final String customerType;
  final String plateAr;
  final String plateEn;
  final String vin;
  final String make;
  final String brand;
  final String modelYear;
  final String packageNameAr;
  final String packageNameEn;
  final String technicianId;
  final String technicianNameAr;
  final String technicianNameEn;
  final String createdAtText;
  final DateTime? createdAt;
  final String srNumber;
  final String srType;
  final String srStatus;
  final bool isEstimation;
  final bool isCampaign;
  final String couponNumber;
  final double discount;
  final double srTotal;
  final Map<String, dynamic> raw;
  final String mileage;

  const TechnicianAppointmentEntity({
    required this.bookingId,
    required this.bookingDateText,
    required this.bookingStatus,
    required this.vehicleId,
    this.bookingDate,
    this.slotTime = '',
    this.branchId = '',
    this.branchName = '',
    this.customerName = '',
    this.customerType = '',
    this.plateAr = '',
    this.plateEn = '',
    this.vin = '',
    this.make = '',
    this.brand = '',
    this.modelYear = '',
    this.packageNameAr = '',
    this.packageNameEn = '',
    this.technicianId = '',
    this.technicianNameAr = '',
    this.technicianNameEn = '',
    this.createdAtText = '',
    this.createdAt,
    this.srNumber = '',
    this.srType = '',
    this.srStatus = '',
    this.isEstimation = false,
    this.isCampaign = false,
    this.couponNumber = '',
    this.discount = 0,
    this.srTotal = 0,
    this.raw = const <String, dynamic>{},
    this.mileage = '',
  });

  String get displayPlate => plateEn.trim().isNotEmpty ? plateEn : plateAr;

  String get displayCar {
    final buffer = StringBuffer();
    if (brand.trim().isNotEmpty) {
      buffer.write(brand.trim());
    } else if (make.trim().isNotEmpty) {
      buffer.write(make.trim());
    }
    if (modelYear.trim().isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write(' ');
      buffer.write(modelYear.trim());
    }
    return buffer.isNotEmpty ? buffer.toString() : make.trim();
  }

  String get packageLabel {
    if (packageNameEn.trim().isNotEmpty) return packageNameEn.trim();
    if (packageNameAr.trim().isNotEmpty) return packageNameAr.trim();
    return '';
  }

  String get statusLabel => bookingStatus.label;

  int? get statusColorValue => bookingStatus.colorValue;
}
