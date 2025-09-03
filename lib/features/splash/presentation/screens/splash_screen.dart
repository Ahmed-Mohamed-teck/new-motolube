import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newmotorlube/core/providers/general_providers.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/utils/constant.dart';

import '../../../../main.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../provider/splash_provider.dart';
import '../view_model/splash_state.dart';





class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).authenticating();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.sizeOf(context).height * .4,
            right: 0,
            left: 0,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: SpinKitCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 30.0,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Text(
                    'V 1.0.0',
                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 16,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
