import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/cancel_appointment_use_case.dart';
import 'upcoming_service_action_state.dart';

class UpcomingServiceActionViewModel
    extends StateNotifier<UpcomingServiceActionState> {
  UpcomingServiceActionViewModel(this._cancelAppointmentUseCase)
      : super(const UpcomingServiceActionIdle());

  final CancelAppointmentUseCase _cancelAppointmentUseCase;

  Future<void> cancelAppointment({
    required String bookingId,
    required String statusId,
  }) async {
    state = const UpcomingServiceActionLoading();
    try {
      await _cancelAppointmentUseCase(
        bookingId: bookingId,
        statusId: statusId,
      );
      state = const UpcomingServiceActionSuccess();
    } catch (e) {
      state = UpcomingServiceActionError(e.toString());
    }
  }

  void reset() {
    state = const UpcomingServiceActionIdle();
  }
}
