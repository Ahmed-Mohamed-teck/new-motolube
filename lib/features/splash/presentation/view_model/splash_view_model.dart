import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';

import '../../domain/use_case/check_onboarding_use_case.dart';
import 'splash_state.dart';
import '../../provider/splash_provider.dart';

class SplashViewModel extends Notifier<SplashState> {
  late final CheckOnboardingUseCase _checkOnboardingUseCase;

  @override
  SplashState build() {
    _checkOnboardingUseCase = ref.read(checkOnboardingUseCaseProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next is AuthenticatedState) {
        _handleAuthenticated();
      } else if (next is UnauthenticatedState) {
        state = const SplashNavigateState('loginScreen');
      } else if (next is AuthenticationFailedState) {
        state = SplashErrorState(next.message);
      }
    });

    ref.read(authViewModelProvider.notifier).authenticating();

    return const SplashInitial();
  }

  Future<void> _handleAuthenticated() async {
    final route = await _checkOnboardingUseCase();
    state = SplashNavigateState(route);
  }
}
