class JobCardPackageEntity {
  final String packageId;
  final String packageCode;
  final String packageNameAr;
  final String packageNameEn;
  final String packageShortName;
  final double linePrice;
  final double totalPrice;
  final double totalTax;
  final double totalCost;
  final double totalDiscount;
  final double totalListPrice;
  final bool isEmergency;
  final bool isCustomPackage;

  const JobCardPackageEntity({
    required this.packageId,
    required this.packageCode,
    required this.packageNameAr,
    required this.packageNameEn,
    required this.packageShortName,
    required this.linePrice,
    required this.totalPrice,
    required this.totalTax,
    required this.totalCost,
    required this.totalDiscount,
    required this.totalListPrice,
    required this.isEmergency,
    required this.isCustomPackage,
  });

  String get displayName =>
      packageNameEn.trim().isNotEmpty
          ? packageNameEn.trim()
          : packageNameAr.trim();
}
