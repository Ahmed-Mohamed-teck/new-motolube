import 'package:flutter/material.dart';
import 'package:newmotorlube/features/customer_cars/presentation/screen/customer_car_details_screen.dart';
import 'package:newmotorlube/features/promotions/presentation/screen/create_promotion_screen.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/home/presentaion/screen/base_home_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/our_service/presentation/our_presentation_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

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

      case 'ourServicesScreen':
        return MaterialPageRoute(builder: (_) => const OurServicesScreen());

      case 'customerCarDetailsScreen':
        return MaterialPageRoute(builder: (_) => const CustomerCarDetailsScreen());

      case 'createPromotionScreen':
        return MaterialPageRoute(builder: (_) => const CreatePromotionScreen());




      default:
        _errorRoute('Default');
    }
    return _errorRoute('Main');
  }

  /// Returns Widgets for use with persistent_bottom_nav_bar
  static Widget getWidgetFromRoute(String? routeName, Object? args) {
    switch (routeName) {
      // case '/':
      //   return BasePage(currentIndex: 0, key: UniqueKey());

      // case 'login':
      //   return const AuthPage();


      // case 'bookingConfirmation':
      //   if (args is BookingModel) {
      //     return BookingConfirmation(booking: args);
      //   }
      //   return _errorWidget('Invalid arguments for bookingConfirmation');



      default:
        return _errorWidget('Unknown route: $routeName');
    }
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
