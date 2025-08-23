import '../entity/auth_session.dart';
import '../entity/stored_auth.dart';

abstract class IAuthLocalRepository {
  Future<void> saveAuthSession(AuthSession session);
  Future<StoredAuth?> getStoredAuth();
  Future<void> clear();
}
