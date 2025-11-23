class CustomPackageCategoryEntity {
  final String id;
  final String descriptionEn;
  final String descriptionAr;

  const CustomPackageCategoryEntity({
    required this.id,
    required this.descriptionEn,
    required this.descriptionAr,
  });

  String get displayName =>
      descriptionEn.trim().isNotEmpty ? descriptionEn : descriptionAr;
}
