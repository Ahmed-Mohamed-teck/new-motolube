abstract class ISplashRepository {
  Future<bool> hasSeenOnboarding();
  Future<void> setOnboardingSeen();
}
