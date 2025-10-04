import 'package:collection/collection.dart';

import '../../domain/entity/technician_summary_entity.dart';

class TechnicianSummaryModel extends TechnicianSummaryEntity {
  TechnicianSummaryModel({
    required String techId,
    required String techNameAr,
    required String techNameEn,
    required String techPhotoUrl,
    required String organizationId,
    required String branchId,
    required int calculatedDistance,
    double? rating,
  }) : super(
          techId: techId,
          techNameAr: techNameAr,
          techNameEn: techNameEn,
          techPhotoUrl: techPhotoUrl,
          organizationId: organizationId,
          branchId: branchId,
          calculatedDistance: calculatedDistance,
          rating: rating,
        );

  factory TechnicianSummaryModel.fromJson(Map<String, dynamic> json) {
    return TechnicianSummaryModel(
      techId: json['tech_id'] as String? ?? '',
      techNameAr: json['tech_name_ar'] as String? ?? '',
      techNameEn: json['tech_name_en'] as String? ?? '',
      techPhotoUrl: json['tech_photo_url'] as String? ?? '',
      organizationId: json['organizatioN_ID'] as String? ?? '',
      branchId: json['branch_id'] as String? ?? '',
      calculatedDistance: (json['calculateDistance'] is int
              ? json['calculateDistance'] as int
              : int.tryParse(json['calculateDistance']?.toString() ?? '') ??
                  0) ??
          0,
      rating: (json['rate'] is double
              ? json['rate'] as double
              : double.tryParse(json['rate']?.toString() ?? '')) ??
          null,
    );
  }

  

  TechnicianSummaryEntity toEntity() {
    return TechnicianSummaryEntity(
      techId: techId,
      techNameAr: techNameAr,
      techNameEn: techNameEn,
      techPhotoUrl: techPhotoUrl,
      organizationId: organizationId,
      branchId: branchId,
      calculatedDistance: calculatedDistance,
      rating: rating,
    );
  }
}