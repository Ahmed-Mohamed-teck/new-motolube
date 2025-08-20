/// An abstract class that represent user authentication state.
abstract class AuthState {}

/// A class that represent user not authorized (Guest User) state.
class NotAuthorized extends AuthState {
  NotAuthorized();
}

/// A class that represent sign in authorizing process `Loading of Login`.
class Authorizing extends AuthState {}

/// A class that represent user sign out process `Loading of Logout`.
class AuthorizingLogout extends AuthState {}

/// A class that represent User Authorized (Signed In) state.
class Authorized extends AuthState {}
