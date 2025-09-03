import 'package:flutter/material.dart';
import 'package:newmotorlube/features/promotions/presentation/screen/create_promotion_screen.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/home/presentaion/screen/base_home_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/profile/presentation/screen/profile_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/user_cars/domain/entity/car_entity.dart';
import 'features/user_cars/presentation/screen/add_new_car_screen.dart';
import 'features/user_cars/presentation/screen/user_car_details_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //       builder: (_) => BasePage(currentIndex: 0, key: UniqueKey()));

      case 'splashScreen':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case 'onBoardingScreen':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case 'loginScreen':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case 'baseHomeScreen':
        return MaterialPageRoute(builder: (_) => const BaseHomeScreen());

      case 'userCarDetailsScreen':
        return MaterialPageRoute(builder: (_) =>  UserCarDetailsScreen(
          car: args as CarEntity,
        ));

      case 'createPromotionScreen':
        return MaterialPageRoute(builder: (_) => const CreatePromotionScreen());

      case 'profileScreen':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case 'addNewCarScreen':
        return MaterialPageRoute(builder: (_) => const AddNewCarScreen());



      default:
        _errorRoute('Default');
    }
    return _errorRoute('Main');
  }



  /// Error Widget for invalid navigation
  static Widget _errorWidget(String message) {
    return Scaffold(
      appBar:  AppBar(title: Text('error'),),
      body: Center(
        child: Text(
          message,
        ),
      ),
    );
  }

  static Route<dynamic> _errorRoute(String arg) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar:  AppBar(title: Text('error'),),
        body: Center(
          child: Text(
            '$arg + Error',
          ),
        ),
      );
    });
  }
}
