import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/utils/theme/themes.dart';
import 'package:newmotorlube/route_generator.dart';

import 'core/providers/current_locale_provider.dart';
import 'core/providers/general_providers.dart';
import 'core/providers/push_notifications_service.dart';
import 'features/auth/presentation/view_model/auth_state.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/device_registration/provider/device_registration_provider.dart';
import 'generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeSharedPreferences();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ProviderSubscription<AuthState>? _authSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = ref.listenManual<AuthState>(authViewModelProvider, (
      previous,
      next,
    ) {
      if (next is AuthenticatedState) {
        unawaited(_registerDevice(next));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PushNotificationsService.instance.initialize();
      if (!mounted) return;

      _tokenRefreshSubscription = ref
          .read(pushTokenDataSourceProvider)
          .onTokenRefresh
          .listen((token) {
            final authState = ref.read(authViewModelProvider);
            if (authState is AuthenticatedState) {
              unawaited(_registerDevice(authState, fcmToken: token));
            }
          });

      final authState = ref.read(authViewModelProvider);
      if (authState is AuthenticatedState) {
        unawaited(_registerDevice(authState));
      }
    });
  }

  Future<void> _registerDevice(
    AuthenticatedState authState, {
    String? fcmToken,
  }) async {
    try {
      final registered = await ref
          .read(deviceRegistrationViewModelProvider.notifier)
          .register(authState.user, fcmToken: fcmToken);
      if (!registered) {
        debugPrint(
          'Device registration skipped because a user ID, FCM token, or '
          'device ID was unavailable.',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Device registration failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _authSubscription?.close();
    unawaited(_tokenRefreshSubscription?.cancel());
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(currentLocaleProvider);
    final langCode = currentLocale;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      locale: Locale(langCode), // Default locale
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: getThemeData(context),
      initialRoute: 'splashScreen',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
