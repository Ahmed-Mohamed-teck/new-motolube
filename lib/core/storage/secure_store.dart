import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage] to persist auth tokens and user info.
class SecureStore {
  final FlutterSecureStorage _storage;
  const SecureStore(this._storage);

  Future<void> saveAuth({
    required String jwtToken,
    required String firebaseToken,
    required String tokenType,
    required int expiresIn,
    required String userId,
    required String userName,
    required String userMobileNumber,
    String? userEmail,
  }) async {
    await _storage.write(key: 'jwtToken', value: jwtToken);
    await _storage.write(key: 'firebaseToken', value: firebaseToken);
    await _storage.write(key: 'tokenType', value: tokenType);
    await _storage.write(key: 'expiresIn', value: expiresIn.toString());
    await _storage.write(key: 'userId', value: userId);
    await _storage.write(key: 'userName', value: userName);
    await _storage.write(key: 'userMobileNumber', value: userMobileNumber);
    await _storage.write(key: 'userEmail', value: userEmail ?? '');
  }

  Future<String?> readToken() => _storage.read(key: 'jwtToken');
}
