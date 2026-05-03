class AppInfoEntity {
  const AppInfoEntity({
    this.appVersion = '',
    this.androidStoreUrl,
    this.iosStoreUrl,
  });

  final String appVersion;
  final String? androidStoreUrl;
  final String? iosStoreUrl;
}
