import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/exception/service_packages_exception.dart';
import '../../domain/use_case/get_packages_for_vehicle_use_case.dart';
import 'service_packages_state.dart';

class ServicePackagesViewModel extends StateNotifier<ServicePackagesState> {
  final GetPackagesForVehicleUseCase _getPackagesForVehicleUseCase;

  ServicePackagesViewModel(this._getPackagesForVehicleUseCase)
    : super(const ServicePackagesInitial());

  Future<void> fetchPackages({
    required String customerId,
    required String vehicleId,
  }) async {
    state = const ServicePackagesLoading();
    try {
      final packages = await _getPackagesForVehicleUseCase(
        customerId: customerId,
        vehicleId: vehicleId,
      );
      if (packages.isEmpty) {
        state = const ServicePackagesEmpty();
      } else {
        state = ServicePackagesLoaded(packages);
      }
    } catch (error) {
      final message = _mapErrorToMessage(error);
      state = ServicePackagesError(message);
    }
  }

  void reset() {
    state = const ServicePackagesInitial();
  }

  String _mapErrorToMessage(Object error) {
    if (error is ServicePackagesException) {
      return error.message;
    }
    return 'Unable to load service packages. Please try again.';
  }
}
