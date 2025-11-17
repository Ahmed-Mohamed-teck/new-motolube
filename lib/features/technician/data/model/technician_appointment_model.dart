import '../../domain/entity/booking_status.dart';
import '../../domain/entity/technician_appointment_entity.dart';
import '../../domain/utils/job_card_utils.dart';

class TechnicianAppointmentModel extends TechnicianAppointmentEntity {
  TechnicianAppointmentModel({
    required super.bookingId,
    required super.bookingDateText,
    required super.bookingStatus,
    required super.vehicleId,
    super.bookingDate,
    super.slotTime,
    super.branchId,
    super.branchName,
    super.customerName,
    super.customerType,
    super.plateAr,
    super.plateEn,
    super.vin,
    super.make,
    super.brand,
    super.modelYear,
    super.packageNameAr,
    super.packageNameEn,
    super.technicianId,
    super.technicianNameAr,
    super.technicianNameEn,
    super.createdAtText,
    super.createdAt,
    super.srNumber,
    super.srType,
    super.srStatus,
    super.isEstimation,
    super.isCampaign,
    super.couponNumber,
    super.discount,
    super.srTotal,
    super.raw,
    super.mileage,
  });

  factory TechnicianAppointmentModel.fromJson(Map<String, dynamic> json) {
    final jobCardMap = _mapFor(json, const [
      'jobcard',
      'jobCard',
      'JobCard',
      'job_card',
      'jobCardDetails',
      'jobcarddetails',
      'srDetails',
      'srdetails',
    ]);
    final bookingId = _stringFor(json, const [
      'bookingid',
      'booking_id',
      'BookingId',
      'bookingId',
      'id',
      'Id',
    ]);
    final bookingDateText = _stringFor(json, const [
      'bookingdate',
      'bookingDate',
      'BookingDate',
    ]);
    final slotTime = _stringFor(json, const [
      'slottime',
      'slotTime',
      'SlotTime',
      'timeRange',
      'TimeRange',
    ]);
    final branchId = _stringFor(json, const [
      'branchid',
      'branchId',
      'BranchId',
    ]);
    final branchName = _stringFor(json, const [
      'branch_name',
      'branchName',
      'BranchName',
      'branch',
    ]);
    final customerName = _stringFor(json, const [
      'customer_name',
      'customerName',
      'CustomerName',
    ]);
    final customerType = _stringFor(json, const [
      'customer_type',
      'customerType',
      'CustomerType',
    ]);
    final plateEn = _stringFor(json, const ['plate_en', 'plateEn', 'PlateEn']);
    final plateAr = _stringFor(json, const ['plate_ar', 'plateAr', 'PlateAr']);
    final vin = _stringFor(json, const ['vin', 'Vin', 'VIN']);
    final make = _stringFor(json, const ['make', 'Make']);
    final brand = _stringFor(json, const ['brand', 'Brand']);
    final modelYear = _stringFor(json, const [
      'model_year',
      'modelYear',
      'ModelYear',
    ]);
    final packageNameEn = _stringFor(json, const [
      'package_name_en',
      'packageNameEn',
      'PackageNameEn',
    ]);
    final packageNameAr = _stringFor(json, const [
      'package_name_ar',
      'packageNameAr',
      'PackageNameAr',
    ]);
    final technicianId = _stringFor(json, const [
      'tech_id',
      'technician_id',
      'TechnicianId',
      'Technician_id',
    ]);
    final technicianNameEn = _stringFor(json, const [
      'tech_name_en',
      'technician_name_en',
      'TechnicianNameEn',
    ]);
    final technicianNameAr = _stringFor(json, const [
      'tech_name_ar',
      'technician_name_ar',
      'TechnicianNameAr',
    ]);
    final createdText = _stringFor(json, const [
      'created',
      'CreatedAt',
      'created_at',
    ]);
    var srNumber = _stringFor(json, const [
      'sr_num',
      'srNum',
      'SrNum',
      'srNumber',
      'SRNumber',
      'sr_number',
      'SR_NUMBER',
      'jobCardId',
      'JobCardId',
      'jobcardId',
      'jobCardID',
      'job_card_id',
      'jobcard_id',
      'openJobCardId',
      'OpenJobCardId',
      'open_job_card_id',
      'jobcardNumber',
      'jobCardNumber',
      'JobCardNumber',
    ]);
    if (srNumber.isEmpty && jobCardMap != null) {
      srNumber = _stringFor(jobCardMap, const [
        'sr_num',
        'srNum',
        'SrNum',
        'srNumber',
        'SRNumber',
        'jobcardId',
        'jobCardId',
        'jobcard_id',
        'job_card_id',
        'jobCardNumber',
        'jobcardNumber',
      ]);
    }
    srNumber =
        sanitizeJobCardId(srNumber) ?? findJobCardId(jobCardMap ?? json) ?? '';
    final srType = _stringFor(json, const ['sr_type', 'srType', 'SrType']);
    var srStatus = _stringFor(json, const [
      'sr_status',
      'srStatus',
      'SrStatus',
    ]);
    if (srStatus.isEmpty && jobCardMap != null) {
      srStatus = _stringFor(jobCardMap, const [
        'sr_status',
        'srStatus',
        'SrStatus',
        'status',
        'Status',
      ]);
    }
    final couponNumber = _stringFor(json, const [
      'coupon_num',
      'coupon',
      'couponNumber',
    ]);
    final bookingStatus = TechnicianBookingStatus.fromRaw(
      label: _stringFor(json, const [
        'booking_status',
        'bookingStatus',
        'BookingStatus',
      ]),
      code: _stringFor(json, const ['status_id', 'Status_Id', 'statusId']),
      hexColor: _stringFor(json, const [
        'heX_COLOR',
        'hexColor',
        'HEX_COLOR',
        'color',
      ]),
    );

    final mileage = _stringFor(json, const [
      'mileage',
      'Mileage',
      'miliage',
      'Miliage',
      'odometer',
      'Odometer',
    ]);

    final vehicleId = _stringFor(json, const [
      'vehicle_id',
      'vehicleId',
      'VehicleId',
      'vehi_id',
      'vehiId',
      'VehiId',
    ]);

    return TechnicianAppointmentModel(
      bookingId: bookingId.isNotEmpty ? bookingId : '0',
      bookingDateText: bookingDateText,
      bookingDate: _parseDate(bookingDateText),
      vehicleId: vehicleId,
      slotTime: slotTime,
      branchId: branchId,
      branchName: branchName,
      bookingStatus: bookingStatus,
      customerName: customerName,
      customerType: customerType,
      plateAr: plateAr,
      plateEn: plateEn,
      vin: vin,
      make: make,
      brand: brand,
      modelYear: modelYear,
      packageNameAr: packageNameAr,
      packageNameEn: packageNameEn,
      technicianId: technicianId,
      technicianNameAr: technicianNameAr,
      technicianNameEn: technicianNameEn,
      createdAtText: createdText,
      createdAt: _parseDate(createdText),
      srNumber: srNumber,
      srType: srType,
      srStatus: srStatus,
      isEstimation: _boolFor(json['is_estimation']),
      isCampaign: _boolFor(json['is_campaign']),
      couponNumber: couponNumber,
      discount: _doubleFor(json['discount']),
      srTotal: _doubleFor(json['sr_total']),
      raw: Map<String, dynamic>.from(json),
      mileage: mileage,
    );
  }

  static String _stringFor(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (!json.containsKey(key)) continue;
      final value = json[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) return null;
    return DateTime.tryParse(value.trim());
  }

  static bool _boolFor(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value.toString().trim().toLowerCase();
    if (text.isEmpty) return false;
    return text == 'true' || text == '1' || text == 'yes';
  }

  static double _doubleFor(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static Map<String, dynamic>? _mapFor(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      if (!json.containsKey(key)) continue;
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return value.map((k, v) => MapEntry(k.toString(), v));
      }
    }
    return null;
  }
}
