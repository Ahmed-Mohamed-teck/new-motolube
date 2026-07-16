abstract interface class IDeviceIdLocalDataSource {
  Future<String> getOrCreateDeviceId();
}
