sealed class ForceUpdateResult {
  const ForceUpdateResult({
    required this.installedVersion,
    required this.requiredVersion,
  });

  final String installedVersion;
  final String requiredVersion;
}

class ForceUpdateRequired extends ForceUpdateResult {
  const ForceUpdateRequired({
    required super.installedVersion,
    required super.requiredVersion,
    required this.storeUrl,
  });

  final String storeUrl;
}

class ForceUpdateNotRequired extends ForceUpdateResult {
  const ForceUpdateNotRequired({
    required super.installedVersion,
    required super.requiredVersion,
  });
}
