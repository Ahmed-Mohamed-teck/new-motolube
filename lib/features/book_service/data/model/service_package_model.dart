import '../../domain/entity/service_package_entity.dart';

class ServicePackageModel {
  final String packageId;
  final String packageCode;
  final String packageNameAr;
  final String packageNameEn;
  final double linePrice;
  final bool isEmergency;

  const ServicePackageModel({
    required this.packageId,
    required this.packageCode,
    required this.packageNameAr,
    required this.packageNameEn,
    required this.linePrice,
    required this.isEmergency,
  });

  factory ServicePackageModel.fromJson(Map<String, dynamic> json) {
    final num? rawPrice = json['linePrice'] as num?;
    return ServicePackageModel(
      packageId: (json['packageId'] ?? '').toString(),
      packageCode: (json['packageCode'] ?? '').toString(),
      packageNameAr: (json['packageNameAr'] ?? '').toString(),
      packageNameEn: (json['packageNameEn'] ?? '').toString(),
      linePrice: rawPrice?.toDouble() ?? 0,
      isEmergency:
          ((json['isEmergency'] ?? '').toString()).toUpperCase() == 'Y',
    );
  }

  ServicePackageEntity toEntity() {
    return ServicePackageEntity(
      packageId: packageId,
      packageCode: packageCode,
      packageNameAr: packageNameAr,
      packageNameEn: packageNameEn,
      linePrice: linePrice,
      isEmergency: isEmergency,
    );
  }
}
