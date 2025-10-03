class ServicePackageEntity {
  final String packageId;
  final String packageCode;
  final String packageNameAr;
  final String packageNameEn;
  final double linePrice;
  final bool isEmergency;

  const ServicePackageEntity({
    required this.packageId,
    required this.packageCode,
    required this.packageNameAr,
    required this.packageNameEn,
    required this.linePrice,
    required this.isEmergency,
  });
}
