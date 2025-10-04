import 'dart:async';
import 'dart:io';
import 'dart:ui' show DartPluginRegistrant;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/utils/end_point.dart';

const _prefTokenKey = 'technician_location_token';
const Duration _locationUpdateInterval = Duration(seconds: 5);
const _notificationId = 9811;
const _notificationTitle = 'Technician Tracking';
const _notificationPreparing = 'Preparing location updates…';

class TechnicianLocationService {
  static bool _initialized = false;
  static final FlutterBackgroundService _service = FlutterBackgroundService();
  static bool _serviceReady = false;
  static bool _serviceStatusListenerAttached = false;
  static final List<Completer<void>> _serviceReadyWaiters = <Completer<void>>[];
  static Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }

    _attachServiceStatusListener();

    if (_initialized) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: technicianBackgroundService,
        autoStart: false,
        isForegroundMode: true,
        initialNotificationTitle: _notificationTitle,
        initialNotificationContent: _notificationPreparing,
        foregroundServiceNotificationId: _notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: technicianBackgroundService,
        onBackground: (_) => false,
      ),
    );
    _initialized = true;
  }

  static Future<void> startTracking({
    required String technicianId,
    required String authToken,
  }) async {
    if (kIsWeb) {
      return;
    }

    await initialize();
    final hasPermission = await _ensurePermissions();
    if (!hasPermission) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefTokenKey, authToken);
    final serviceReady = await _ensureServiceIsReady();
    if (!serviceReady) {
      if (kDebugMode) {
        debugPrint(
          'TechnicianLocationService: background service not ready - skipping credential sync',
        );
      }
      return;
    }
    _service.invoke('updateCredentials', {
      'technicianId': technicianId,
      'token': authToken,
    });
  }

  static Future<void> stopTracking() async {
    if (kIsWeb) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefTokenKey);
    if (await _service.isRunning()) {
      _service.invoke('stopService');
    }
    _serviceReady = false;
  }

  static Future<bool> _ensurePermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      final notificationGranted = await _ensureNotificationPermission();
      if (!notificationGranted) {
        return false;
      }
    }
    if (Platform.isAndroid) {
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static void _attachServiceStatusListener() {
    if (_serviceStatusListenerAttached) {
      return;
    }
    _serviceStatusListenerAttached = true;
    _service.on('serviceStatus').listen((event) {
      final status = event?['status'] as String?;
      if (status == 'ready') {
        _serviceReady = true;
        if (_serviceReadyWaiters.isNotEmpty) {
          for (final completer in List<Completer<void>>.from(
            _serviceReadyWaiters,
          )) {
            if (!completer.isCompleted) {
              completer.complete();
            }
          }
          _serviceReadyWaiters.clear();
        }
      } else if (status == 'stopped') {
        _serviceReady = false;
        if (_serviceReadyWaiters.isNotEmpty) {
          for (final completer in List<Completer<void>>.from(
            _serviceReadyWaiters,
          )) {
            if (!completer.isCompleted) {
              completer.completeError(
                StateError(
                  'Technician location service stopped before it was ready',
                ),
              );
            }
          }
          _serviceReadyWaiters.clear();
        }
      }
    });
  }

  static Future<bool> _ensureServiceIsReady() async {
    if (_serviceReady) {
      return true;
    }

    final running = await _service.isRunning();
    if (!running) {
      try {
        await _service.startService();
      } on PlatformException catch (error) {
        if (kDebugMode) {
          debugPrint(
            'TechnicianLocationService: unable to start foreground service: ${error.message}',
          );
        }
        return false;
      }
    } else {
      _service.invoke('requestStatus');
    }

    final completer = Completer<void>();
    _serviceReadyWaiters.add(completer);

    try {
      await completer.future.timeout(const Duration(seconds: 5));
      _serviceReadyWaiters.remove(completer);
      return _serviceReady;
    } on TimeoutException {
      _serviceReadyWaiters.remove(completer);
      return await _service.isRunning();
    } catch (_) {
      _serviceReadyWaiters.remove(completer);
      return false;
    }
  }

  static Future<bool> _ensureNotificationPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }
    final status = await permissions.Permission.notification.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }
    final result = await permissions.Permission.notification.request();
    if (result.isGranted || result.isLimited) {
      return true;
    }
    return false;
  }
}

@pragma('vm:entry-point')
void technicianBackgroundService(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    await service.setAsForegroundService();
    await service.setForegroundNotificationInfo(
      title: _notificationTitle,
      content: _notificationPreparing,
    );
  }
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  Timer? timer;
  Dio? dio;
  var sendingInProgress = false;
  service.invoke('serviceStatus', {'status': 'ready'});
  String? cachedTechnicianId;
  Dio _ensureDio(String token) {
    final existing = dio;
    if (existing != null) {
      existing.options.headers['Authorization'] = 'Bearer $token';
      return existing;
    }
    final created = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio = created;
    return created;
  }

  Future<String?> _resolveTechnicianId() async {
    try {
      final userId = await secureStorage.read(key: 'userId');
      if (userId != null && userId.trim().isNotEmpty) {
        cachedTechnicianId = userId.trim();
        return cachedTechnicianId;
      }
      final oracleId = await secureStorage.read(key: 'oracleId');
      if (oracleId != null && oracleId.trim().isNotEmpty) {
        cachedTechnicianId = oracleId.trim();
        return cachedTechnicianId;
      }
    } catch (_) {
      // ignore secure storage failures; will retry later
    }
    return cachedTechnicianId;
  }

  Future<void> sendLocation() async {
    if (sendingInProgress) {
      return;
    }
    sendingInProgress = true;
    final technicianId = await _resolveTechnicianId();
    final token = prefs.getString(_prefTokenKey);
    if (technicianId == null || token == null) {
      sendingInProgress = false;
      return;
    }
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      sendingInProgress = false;
      return;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      sendingInProgress = false;
      return;
    }
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      position = await Geolocator.getLastKnownPosition();
    }
    if (position == null) {
      sendingInProgress = false;
      return;
    }
    final client = _ensureDio(token)
      ..options.headers['Content-Type'] = 'application/json';
    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: _notificationTitle,
        content: 'Updating location…',
      );
      await service.setAsForegroundService();
    }
    try {
      await client.post(
        setTechnicianLocationEndPoint,
        data: {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'technicianId': technicianId,
        },
      );
    } catch (_) {
    } finally {
      if (service is AndroidServiceInstance) {
        await service.setForegroundNotificationInfo(
          title: _notificationTitle,
          content:
              'Last update: ${DateTime.now().toLocal().toIso8601String().substring(0, 19)}',
        );
      }
      sendingInProgress = false;
    }
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(_locationUpdateInterval, (_) async {
      await sendLocation();
    });
    unawaited(sendLocation());
  }

  service.on('updateCredentials').listen((event) async {
    final technicianId = event?['technicianId'] as String?;
    final token = event?['token'] as String?;
    if (token != null) {
      await prefs.setString(_prefTokenKey, token);
    }
    if (technicianId != null && cachedTechnicianId == null) {
      cachedTechnicianId = technicianId.trim();
    }
    startTimer();
  });
  service.on('requestStatus').listen((event) async {
    service.invoke('serviceStatus', {'status': 'ready'});
  });
  service.on('stopService').listen((event) async {
    timer?.cancel();
    timer = null;
    dio = null;
    sendingInProgress = false;
    cachedTechnicianId = null;
    service.invoke('serviceStatus', {'status': 'stopped'});
    await service.stopSelf();
  });
  final existingToken = prefs.getString(_prefTokenKey);
  if (existingToken != null) {
    final initialId = await _resolveTechnicianId();
    if (initialId != null) {
      startTimer();
    }
  }
}
