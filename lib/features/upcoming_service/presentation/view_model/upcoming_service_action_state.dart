abstract class UpcomingServiceActionState {
  const UpcomingServiceActionState();
}

class UpcomingServiceActionIdle extends UpcomingServiceActionState {
  const UpcomingServiceActionIdle();
}

class UpcomingServiceActionLoading extends UpcomingServiceActionState {
  const UpcomingServiceActionLoading();
}

class UpcomingServiceActionSuccess extends UpcomingServiceActionState {
  const UpcomingServiceActionSuccess();
}

class UpcomingServiceActionError extends UpcomingServiceActionState {
  final String message;
  const UpcomingServiceActionError(this.message);
}
