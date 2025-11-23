import '../../domain/entity/custom_package_category_entity.dart';

class CustomPackageCategoryModel extends CustomPackageCategoryEntity {
  CustomPackageCategoryModel({
    required super.id,
    required super.descriptionEn,
    required super.descriptionAr,
  });

  factory CustomPackageCategoryModel.fromJson(Map<String, dynamic> json) {
    String _stringFor(String key) => (json[key] ?? '').toString();
    return CustomPackageCategoryModel(
      id: _stringFor('categoryId'),
      descriptionEn: _stringFor('categoryDescEng'),
      descriptionAr: _stringFor('categoryDescAra'),
    );
  }

  CustomPackageCategoryEntity toEntity() {
    return CustomPackageCategoryEntity(
      id: id,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
    );
  }
}
