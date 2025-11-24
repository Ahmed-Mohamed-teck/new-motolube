class UpcomingServiceEntity {
  final String appointmentId;
  final String serviceName;
  final String status;
  final DateTime? appointmentDate;
  final String appointmentDateText;
  final String? timeSlot;
  final String? location;
  final String carTitle;
  final String plateText;
  final String packageTitle;
  final String branchLabel;
  final String technicianLabel;
  final String srNumber;
  final double srTotal;
  final String couponNumber;
  final double discount;

  const UpcomingServiceEntity({
    required this.appointmentId,
    required this.serviceName,
    required this.status,
    required this.appointmentDateText,
    this.appointmentDate,
    this.timeSlot,
    this.location,
    this.carTitle = '',
    this.plateText = '',
    this.packageTitle = '',
    this.branchLabel = '',
    this.technicianLabel = '',
    this.srNumber = '',
    this.srTotal = 0,
    this.couponNumber = '',
    this.discount = 0,
  });

  bool get hasSchedule => appointmentDate != null || appointmentDateText.isNotEmpty;
}
