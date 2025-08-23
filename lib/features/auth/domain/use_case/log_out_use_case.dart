import 'package:newmotorlube/core/storage/secure_store.dart';

class LogoutUseCase {
  final SecureStore _secureStore;

  LogoutUseCase(this._secureStore);

  Future<void> call() async {
    await _secureStore.clear();
  }
}