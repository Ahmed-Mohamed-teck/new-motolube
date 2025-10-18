import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/get_upcoming_services_use_case.dart';
import 'upcoming_service_state.dart';

class UpcomingServiceViewModel
    extends StateNotifier<UpcomingServiceState> {
  UpcomingServiceViewModel(this._getUpcomingServicesUseCase)
      : super(const UpcomingServiceInitial());

  final GetUpcomingServicesUseCase _getUpcomingServicesUseCase;

  Future<void> fetchUpcomingServices() async {
    if (state is UpcomingServiceLoading) {
      return;
    }
    state = const UpcomingServiceLoading();
    try {
      final services = await _getUpcomingServicesUseCase();
      if (services.isEmpty) {
        state = const UpcomingServiceEmpty();
      } else {
        state = UpcomingServiceLoaded(services);
      }
    } catch (e) {
      state = UpcomingServiceError(e.toString());
    }
  }

  void reset() {
    state = const UpcomingServiceInitial();
  }
}
