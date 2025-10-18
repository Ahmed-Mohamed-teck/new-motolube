import '../../domain/entity/upcoming_service_entity.dart';

sealed class UpcomingServiceState {
  const UpcomingServiceState();
}

class UpcomingServiceInitial extends UpcomingServiceState {
  const UpcomingServiceInitial();
}

class UpcomingServiceLoading extends UpcomingServiceState {
  const UpcomingServiceLoading();
}

class UpcomingServiceLoaded extends UpcomingServiceState {
  final List<UpcomingServiceEntity> services;
  const UpcomingServiceLoaded(this.services);
}

class UpcomingServiceEmpty extends UpcomingServiceState {
  const UpcomingServiceEmpty();
}

class UpcomingServiceError extends UpcomingServiceState {
  final String message;
  const UpcomingServiceError(this.message);
}
