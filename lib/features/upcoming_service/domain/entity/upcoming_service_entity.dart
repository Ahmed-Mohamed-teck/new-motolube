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
  });

  bool get hasSchedule => appointmentDate != null || appointmentDateText.isNotEmpty;
}
