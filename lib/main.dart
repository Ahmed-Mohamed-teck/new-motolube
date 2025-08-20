import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/utils/theme/themes.dart';
import 'package:newmotorlube/route_generator.dart';

import 'core/providers/current_locale_provider.dart';
import 'core/providers/general_providers.dart';
import 'generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeSharedPreferences();

  runApp( ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentLocale = ref.watch(currentLocaleProvider);
        final langCode = currentLocale;
        return MaterialApp(
        title: 'Flutter Demo',

        navigatorKey: navigatorKey,
        locale: Locale(langCode), // Default locale
        localizationsDelegates:  [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: getThemeData(context),
        initialRoute: 'splashScreen',
        onGenerateRoute: RouteGenerator.generateRoute,    );
      },
    );
  }
}



