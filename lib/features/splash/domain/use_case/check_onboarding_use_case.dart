import '../repository/i_splash_repository.dart';

class CheckOnboardingUseCase {
  final ISplashRepository _repository;

  CheckOnboardingUseCase(this._repository);

  Future<String> call() async {
    final hasSeen = await _repository.hasSeenOnboarding();
    if (!hasSeen) {
      await _repository.setOnboardingSeen();
      return 'onBoardingScreen';
    }
    return 'baseHomeScreen';
  }
}
