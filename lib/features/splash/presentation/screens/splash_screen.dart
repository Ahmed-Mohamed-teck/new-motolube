import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newmotorlube/core/providers/general_providers.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/utils/constant.dart';

import '../../../../main.dart';
import '../../provider/splash_provider.dart';
import '../view_model/splash_state.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SplashState>(splashViewModelProvider, (previous, state) {
      if (state is SplashNavigateState) {
        navigatorKey.currentState!.pushReplacementNamed(state.route);
      } else if (state is SplashErrorState) {
        Future.microtask(() {
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (context) => AlertDialog(
              title: Text(appLang.errorTitle),
              content: Text(state.message),
            ),
          );
        });
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 150,
                width: 150,
                child: Image.asset('assets/logo-no-bg.png')),
            const SizedBox(height: 8),
            Text(
              appPrefsWithCache.getString(kAppLanguage) == 'ar'
                  ? 'موتور لوب'
                  : 'Motor Lube',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 30,
              height: 30,
              child: SpinKitCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 30.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
