import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/entity/app_info_entity.dart';
import '../../domain/entity/force_update_result.dart';
import '../../domain/repository/i_force_update_repository.dart';
import '../data_source/force_update_remote_data_source.dart';

class ForceUpdateRepositoryImpl implements IForceUpdateRepository {
  const ForceUpdateRepositoryImpl(this._remoteDataSource);

  final ForceUpdateRemoteDataSource _remoteDataSource;

  static const _androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.ml.motorlube';
  static const _iosStoreUrl =
      'https://apps.apple.com/eg/app/motorlube/id6503187477';

  @override
  Future<ForceUpdateResult> checkForUpdate() async {
    final appInfo = await _remoteDataSource.getAppInfo();
    final packageInfo = await PackageInfo.fromPlatform();
    final installedVersion = packageInfo.version.trim();
    final requiredVersion = appInfo.appVersion.trim();

    if (requiredVersion.isEmpty ||
        !_isVersionOlder(installedVersion, requiredVersion)) {
      return ForceUpdateNotRequired(
        installedVersion: installedVersion,
        requiredVersion: requiredVersion,
      );
    }

    return ForceUpdateRequired(
      installedVersion: installedVersion,
      requiredVersion: requiredVersion,
      storeUrl: _storeUrl(appInfo),
    );
  }

  String _storeUrl(AppInfoEntity appInfo) {
    if (Platform.isAndroid) {
      return appInfo.androidStoreUrl?.isNotEmpty == true
          ? appInfo.androidStoreUrl!
          : _androidStoreUrl;
    }
    if (Platform.isIOS) {
      return appInfo.iosStoreUrl?.isNotEmpty == true
          ? appInfo.iosStoreUrl!
          : _iosStoreUrl;
    }
    return _iosStoreUrl;
  }

  bool _isVersionOlder(String installed, String required) {
    final installedParts = _versionParts(installed);
    final requiredParts = _versionParts(required);
    final maxLength =
        installedParts.length > requiredParts.length
            ? installedParts.length
            : requiredParts.length;

    for (var index = 0; index < maxLength; index++) {
      final installedPart =
          index < installedParts.length ? installedParts[index] : 0;
      final requiredPart =
          index < requiredParts.length ? requiredParts[index] : 0;

      if (installedPart < requiredPart) return true;
      if (installedPart > requiredPart) return false;
    }

    return false;
  }

  List<int> _versionParts(String version) {
    final normalized = version.split('+').first.trim();
    return normalized
        .split('.')
        .map(
          (part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        )
        .toList();
  }
}
