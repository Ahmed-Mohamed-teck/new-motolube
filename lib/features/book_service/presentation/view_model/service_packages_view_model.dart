import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    } catch (e) {
      state = ServicePackagesError(e.toString());
    }
  }

  void reset() {
    state = const ServicePackagesInitial();
  }
}
