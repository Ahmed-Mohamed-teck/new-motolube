import '../../../../core/storage/secure_store.dart';
import '../../domain/entity/auth_session.dart';
import '../../domain/entity/stored_auth.dart';
import '../../domain/entity/user_type.dart';
import '../../domain/repository/i_auth_local_repository.dart';

class AuthLocalRepositoryImpl implements IAuthLocalRepository {
  final SecureStore _secureStore;
  AuthLocalRepositoryImpl(this._secureStore);

  @override
  Future<void> saveAuthSession(AuthSession session) {
    return _secureStore.saveAuth(
      jwtToken: session.jwtToken,
      firebaseToken: session.firebaseToken,
      tokenType: session.tokenType,
      expiresIn: session.expiresIn,
      oracleId: session.oracleId,
      userName: session.userName,
      userMobileNumber: session.userMobileNumber,
      userEmail: session.userEmail,
      userType: session.userType.value,
    );
  }

  @override
  Future<StoredAuth?> getStoredAuth() async {
    final jwt = await _secureStore.readToken();
    if (jwt == null) return null;
    final fcm = await _secureStore.readFcmToken() ?? '';
    final phone = await _secureStore.phoneNumber() ?? '';
    final oracleId = await _secureStore.oracleId() ?? '';
    final typeString = await _secureStore.userType();
    final userType = UserType.fromValue(
      int.tryParse(typeString ?? '') ?? UserType.customer.value,
    );
    return StoredAuth(
      jwtToken: jwt,
      firebaseToken: fcm,
      phoneNumber: phone,
      oracleId: oracleId,
      userType: userType,
    );
  }

  @override
  Future<void> clear() {
    return _secureStore.clear();
  }
}
