class JobCardEntity {
  final String srNumber;
  final String srStatus;
  final String openDate;
  final String branch;
  final String technicianName;
  final String customerName;
  final String vin;
  final Map<String, dynamic> raw;

  const JobCardEntity({
    required this.srNumber,
    required this.srStatus,
    required this.openDate,
    required this.branch,
    required this.technicianName,
    required this.customerName,
    required this.vin,
    this.raw = const <String, dynamic>{},
  });
}
