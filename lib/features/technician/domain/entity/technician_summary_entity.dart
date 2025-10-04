class TechnicianSummaryEntity {
  final String techId;
  final String techNameAr;
  final String techNameEn;
  final String techPhotoUrl;
  final String organizationId;
  final String branchId;
  final int calculatedDistance;
  final double? rating;

  const TechnicianSummaryEntity({
    required this.techId,
    required this.techNameAr,
    required this.techNameEn,
    required this.techPhotoUrl,
    required this.organizationId,
    required this.branchId,
    required this.calculatedDistance,
    this.rating,
  });
}
