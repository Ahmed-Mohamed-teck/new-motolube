import '../../domain/entity/app_info_entity.dart';

class AppInfoModel extends AppInfoEntity {
  const AppInfoModel({
    super.appVersion,
    super.androidStoreUrl,
    super.iosStoreUrl,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) {
    return AppInfoModel(
      appVersion: (json['appVersion'] as String?)?.trim() ?? '',
      androidStoreUrl: (json['androidStoreUrl'] as String?)?.trim(),
      iosStoreUrl: (json['iosStoreUrl'] as String?)?.trim(),
    );
  }
}
