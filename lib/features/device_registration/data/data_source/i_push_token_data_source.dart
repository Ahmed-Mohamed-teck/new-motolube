abstract interface class IPushTokenDataSource {
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
}
