import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newmotorlube/main.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background FCM message: ${message.messageId}');
}

class PushNotificationsService {
  PushNotificationsService._();

  static final PushNotificationsService instance = PushNotificationsService._();

  bool _initialized = false;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications',
        importance: Importance.max,
      );

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _initializeLocalNotifications();
    await _initializePushHandlers();
    await _logToken();
  }

  Future<String?> getToken() async {
    try {
      await _waitForApnsTokenIfNeeded();
      return _messaging.getToken();
    } catch (error) {
      debugPrint('Error getting FCM token: $error');
      return null;
    }
  }

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
      'FCM permission status: ${settings.authorizationStatus}; '
      'alert=${settings.alert}; badge=${settings.badge}; sound=${settings.sound}',
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;

        try {
          _handleMessage(RemoteMessage.fromMap(jsonDecode(payload)));
        } catch (error) {
          debugPrint('Error handling notification payload: $error');
        }
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _initializePushHandlers() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) => debugPrint('FCM token refreshed: $token'),
    );
  }

  Future<void> _logToken() async {
    final apnsToken = await _waitForApnsTokenIfNeeded();
    debugPrint('APNs token: ${apnsToken ?? 'null'}');

    final token = await getToken();
    if (token != null) {
      debugPrint('FCM token: $token');
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    debugPrint(
      'FCM foreground message received: id=${message.messageId}, '
      'data=${message.data}, notification=${message.notification != null}',
    );

    final notification = message.notification;
    if (_isApplePlatform && notification != null) {
      return;
    }

    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;
    if (title == null && body == null) return;

    await _localNotifications.show(
      id: message.messageId.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.toMap()),
    );
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    debugPrint(
      'FCM notification opened: id=${message.messageId}, data=${message.data}',
    );

    final route = message.data['route'];
    if (route is! String || route.isEmpty) return;

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      debugPrint('Navigator is not ready for notification route: $route');
      return;
    }

    Object? arguments;
    if (route == 'chatScreen') {
      arguments = message.data['bookingId'] ?? message.data['booking_id'];
    }

    navigator.pushNamed(route, arguments: arguments);
  }

  Future<String?> _waitForApnsTokenIfNeeded() async {
    if (defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      return null;
    }

    for (var attempt = 0; attempt < 10; attempt++) {
      final token = await _messaging.getAPNSToken();
      if (token != null) return token;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }

    return null;
  }

  bool get _isApplePlatform =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}
