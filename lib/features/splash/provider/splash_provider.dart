import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/general_providers.dart';
import '../data/repository/splash_repository.dart';
import '../domain/repository/i_splash_repository.dart';
import '../domain/use_case/check_onboarding_use_case.dart';
import '../presentation/view_model/splash_state.dart';
import '../presentation/view_model/splash_view_model.dart';

final splashRepositoryProvider = Provider<ISplashRepository>((ref) {
  return SplashRepositoryImpl(appPrefsWithCache);
});

final checkOnboardingUseCaseProvider = Provider<CheckOnboardingUseCase>((ref) {
  return CheckOnboardingUseCase(ref.read(splashRepositoryProvider));
});

final splashViewModelProvider =
    NotifierProvider<SplashViewModel, SplashState>(() => SplashViewModel());
