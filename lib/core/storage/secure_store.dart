import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/model/verify_otp_response.dart';

/// Wrapper around [FlutterSecureStorage] to persist auth tokens and user info.
class SecureStore {
  final FlutterSecureStorage _storage;
  const SecureStore(this._storage);

  Future<void> saveAuth(VerifyOtpResponse response) async {
    await _storage.write(key: 'jwtToken', value: response.tokens.jwtToken);
    await _storage.write(key: 'firebaseToken', value: response.tokens.firebaseToken);
    await _storage.write(key: 'tokenType', value: response.tokens.tokenType);
    await _storage.write(key: 'expiresIn', value: response.tokens.expiresIn.toString());
    await _storage.write(key: 'userId', value: response.user.id);
    await _storage.write(key: 'userName', value: response.user.name ?? '');
    await _storage.write(key: 'userMobileNumber', value: response.user.mobileNumber);
    await _storage.write(key: 'userEmail', value: response.user.email ?? '');
  }

  Future<String?> readToken() => _storage.read(key: 'jwtToken');
}
