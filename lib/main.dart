import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/utils/theme/themes.dart';
import 'package:newmotorlube/route_generator.dart';
import 'features/technician/service/technician_location_service.dart';
import 'features/technician/service/technician_tracking_coordinator.dart';

import 'core/providers/current_locale_provider.dart';
import 'core/providers/general_providers.dart';
import 'core/providers/push_notifications_service.dart';
import 'generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await TechnicianLocationService.initialize();
  await initializeSharedPreferences();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(PushNotificationsService.instance.initialize());
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(currentLocaleProvider);
    final langCode = currentLocale;
    return MaterialApp(
      title: 'Flutter Demo',
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
      builder:
          (context, child) => TechnicianTrackingCoordinator(
            navigatorKey: navigatorKey,
            child: child ?? const SizedBox.shrink(),
          ),
    );
  }
}
