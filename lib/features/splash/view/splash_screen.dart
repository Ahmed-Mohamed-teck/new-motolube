
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newmotorlube/core/providers/general_providers.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/current_locale_provider.dart';
import '../../../core/utils/constant.dart';
import '../../../main.dart';
import '../../auth/provider/auth_provider.dart';



class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  bool _hasNavigatedToLogin = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).authenticating();
      sendFcmtoken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    if(authState is AuthenticatedState){
      navigateToHome();
    }else if(authState is UnauthenticatedState){
      if(!_hasNavigatedToLogin){
        _hasNavigatedToLogin = true;
        navigateToLogin();
      }
    }else if(authState is AuthenticationFailedState){
      // show a dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted){
          Future.delayed(Duration(milliseconds: 100),(){
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (context) => AlertDialog(
                title: Text(appLang.errorTitle),
                content: Text(authState.message),

              ),
            );
          });

        }
      });

    }

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
                ))
          ],
        ),
      ),
    );
  }

  void navigateToHome() {
    Future.delayed(const Duration(milliseconds: 100), () {
        if (appPrefsWithCache.getBool(kShowOnBoardingScreen) == null ||
            appPrefsWithCache.getBool(kShowOnBoardingScreen) == false) {
          appPrefsWithCache.setBool(kShowOnBoardingScreen, true);
          navigatorKey.currentState!.pushReplacementNamed('onBoardingScreen');
        } else {
          navigatorKey.currentState!.pushReplacementNamed('baseHomeScreen');
        }

    });
  }

  void navigateToLogin() {
    Future.delayed(const Duration(milliseconds: 100), () {
      navigatorKey.currentState!.pushReplacementNamed('loginScreen');
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
