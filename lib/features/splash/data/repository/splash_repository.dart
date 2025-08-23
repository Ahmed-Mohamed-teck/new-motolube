import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constant.dart';
import '../../domain/repository/i_splash_repository.dart';

class SplashRepositoryImpl implements ISplashRepository {
  final SharedPreferencesWithCache _prefs;

  SplashRepositoryImpl(this._prefs);

  @override
  Future<bool> hasSeenOnboarding() async {
    return _prefs.getBool(kShowOnBoardingScreen) ?? false;
  }

  @override
  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(kShowOnBoardingScreen, true);
  }
}
