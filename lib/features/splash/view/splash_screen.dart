
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/general_providers.dart';

import '../../../core/providers/current_locale_provider.dart';
import '../../../core/utils/constant.dart';
import '../../../main.dart';



class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToHome();
      sendFcmtoken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
        final bool showOnboarding =   true;
        if (showOnboarding) {
          navigatorKey.currentState!.pushReplacementNamed('onBoardingScreen');
        } else {
          navigatorKey.currentState!.pushReplacementNamed('/');
        }

    });
  }

  void sendFcmtoken() async {
    return;
    // String? token = await FirebaseMessaging.instance.getToken();
    // var userId = FirebaseAuth.instance.currentUser?.uid;
    // if (token != null && userId != null) {
    //   DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    //   // DocumentSnapshot user = await docRef.get();
    //   // Map<String, dynamic> userData = user.data() as Map<String, dynamic>;
    //   Map<String, dynamic> additionalData = {
    //     'fcmToken': token,
    //     'userId': userId,
    //     'currentLang': AppSharedPrefs.instance!.getString(kAppLanguage),
    //   };
    //   await docRef.set(additionalData, SetOptions(merge: true));
    // }
  }
}
