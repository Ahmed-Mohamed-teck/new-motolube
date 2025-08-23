sealed class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashNavigateState extends SplashState {
  final String route;
  const SplashNavigateState(this.route);
}

class SplashErrorState extends SplashState {
  final String message;
  const SplashErrorState(this.message);
}
