import '../../domain/entity/main_category_entity.dart';

class MainCategoryModel extends MainCategoryEntity {
  const MainCategoryModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    super.photoUrl,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    final id = (json['categorY_ID'] ?? json['categoryId'] ?? '').toString();
    final titleEn =
        (json['categorY_DESC_ENG'] ?? json['categoryDescEng'] ?? '').toString();
    final titleAr =
        (json['categorY_DESC_ARA'] ?? json['categoryDescAra'] ?? '').toString();
    final rawPhoto =
        (json['photourl'] ?? json['photoUrl'] ?? json['photoURL'])?.toString();

    return MainCategoryModel(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      photoUrl: rawPhoto != null && rawPhoto.trim().isEmpty ? null : rawPhoto,
    );
  }
}
