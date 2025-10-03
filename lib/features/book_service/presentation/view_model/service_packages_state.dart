import '../../domain/entity/service_package_entity.dart';

sealed class ServicePackagesState {
  const ServicePackagesState();
}

class ServicePackagesInitial extends ServicePackagesState {
  const ServicePackagesInitial();
}

class ServicePackagesLoading extends ServicePackagesState {
  const ServicePackagesLoading();
}

class ServicePackagesLoaded extends ServicePackagesState {
  final List<ServicePackageEntity> packages;
  const ServicePackagesLoaded(this.packages);
}

class ServicePackagesEmpty extends ServicePackagesState {
  const ServicePackagesEmpty();
}

class ServicePackagesError extends ServicePackagesState {
  final String message;
  const ServicePackagesError(this.message);
}
