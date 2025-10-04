class ServicePackagesException implements Exception {
  final String message;

  const ServicePackagesException(this.message);

  factory ServicePackagesException.serverError() => const ServicePackagesException(
    'We are having trouble fetching service packages right now. Please try again in a few minutes.',
  );

  factory ServicePackagesException.networkError() =>
      const ServicePackagesException(
        'Please check your connection and try again.',
      );

  factory ServicePackagesException.unexpected() =>
      const ServicePackagesException(
        'Something went wrong while loading service packages. Please try again.',
      );

  @override
  String toString() => message;
}
