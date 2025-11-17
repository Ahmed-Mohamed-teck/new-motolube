import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/update_appointment_status_use_case.dart';
import 'technician_appointment_update_state.dart';

class TechnicianAppointmentUpdateViewModel
    extends StateNotifier<TechnicianAppointmentUpdateState> {
  TechnicianAppointmentUpdateViewModel(this._updateStatus)
    : super(const TechnicianAppointmentUpdateIdle());

  final UpdateAppointmentStatusUseCase _updateStatus;

  Future<void> update({
    required String bookingId,
    required String statusId,
  }) async {
    state = const TechnicianAppointmentUpdateLoading();
    try {
      await _updateStatus(bookingId: bookingId, statusId: statusId);
      if (!mounted) return;
      state = const TechnicianAppointmentUpdateSuccess();
    } catch (error) {
      if (!mounted) return;
      state = TechnicianAppointmentUpdateError(error.toString());
    }
  }

  void reset() {
    state = const TechnicianAppointmentUpdateIdle();
  }
}
