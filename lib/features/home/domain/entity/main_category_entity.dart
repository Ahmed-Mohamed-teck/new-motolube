import 'package:flutter/widgets.dart';

class MainCategoryEntity {
  final String id;
  final String titleEn;
  final String titleAr;
  final String? photoUrl;

  const MainCategoryEntity({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    this.photoUrl,
  });

  String titleForLocale(Locale locale) {
    final lang = locale.languageCode.toLowerCase();
    if (lang == 'ar' && titleAr.trim().isNotEmpty) {
      return titleAr;
    }
    if (titleEn.trim().isNotEmpty) {
      return titleEn;
    }
    return titleAr;
  }
}
