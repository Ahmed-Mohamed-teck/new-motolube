import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_store.dart';

/// Provides a singleton [SecureStore].
final secureStoreProvider = Provider<SecureStore>((ref) {
  return const SecureStore(FlutterSecureStorage());
});