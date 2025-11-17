import '../../domain/entity/job_card_package_entity.dart';

class JobCardPackageModel extends JobCardPackageEntity {
  JobCardPackageModel({
    required super.packageId,
    required super.packageCode,
    required super.packageNameAr,
    required super.packageNameEn,
    required super.packageShortName,
    required super.linePrice,
    required super.totalPrice,
    required super.totalTax,
    required super.totalCost,
    required super.totalDiscount,
    required super.totalListPrice,
    required super.isEmergency,
    required super.isCustomPackage,
  });

  factory JobCardPackageModel.fromJson(Map<String, dynamic> json) {
    double _doubleFor(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    String _stringFor(String key) => (json[key] ?? '').toString();
    bool _boolFlag(String key) {
      final raw = (json[key] ?? '').toString().trim().toUpperCase();
      if (raw.isEmpty) return false;
      return raw == 'Y' || raw == 'YES' || raw == 'TRUE' || raw == '1';
    }

    return JobCardPackageModel(
      packageId: _stringFor('packageId'),
      packageCode: _stringFor('packageCode'),
      packageNameAr: _stringFor('packageNameAr'),
      packageNameEn: _stringFor('packageNameEn'),
      packageShortName: _stringFor('packageShortName'),
      linePrice: _doubleFor(json['linePrice']),
      totalPrice: _doubleFor(json['totalPrice']),
      totalTax: _doubleFor(json['totalTax']),
      totalCost: _doubleFor(json['totalCost']),
      totalDiscount: _doubleFor(json['totalDiscount']),
      totalListPrice: _doubleFor(json['totalListPrice']),
      isEmergency: _boolFlag('isEmergency'),
      isCustomPackage: _boolFlag('customPackageFlag'),
    );
  }

  JobCardPackageEntity toEntity() {
    return JobCardPackageEntity(
      packageId: packageId,
      packageCode: packageCode,
      packageNameAr: packageNameAr,
      packageNameEn: packageNameEn,
      packageShortName: packageShortName,
      linePrice: linePrice,
      totalPrice: totalPrice,
      totalTax: totalTax,
      totalCost: totalCost,
      totalDiscount: totalDiscount,
      totalListPrice: totalListPrice,
      isEmergency: isEmergency,
      isCustomPackage: isCustomPackage,
    );
  }
}
