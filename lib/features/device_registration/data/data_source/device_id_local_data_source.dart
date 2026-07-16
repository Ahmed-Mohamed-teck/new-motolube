import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'i_device_id_local_data_source.dart';

class DeviceIdLocalDataSourceImpl implements IDeviceIdLocalDataSource {
  DeviceIdLocalDataSourceImpl(this._preferences);

  static const _deviceIdPreferenceKey = 'notificationDeviceId';

  final SharedPreferencesWithCache _preferences;
  Future<String>? _deviceIdFuture;

  @override
  Future<String> getOrCreateDeviceId() {
    return _deviceIdFuture ??= _loadOrCreateDeviceId();
  }

  Future<String> _loadOrCreateDeviceId() async {
    final storedDeviceId = _preferences.getString(_deviceIdPreferenceKey);
    if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
      return storedDeviceId;
    }

    const uuid = Uuid();
    final deviceId = uuid.v4();
    await _preferences.setString(_deviceIdPreferenceKey, deviceId);
    return deviceId;
  }
}
