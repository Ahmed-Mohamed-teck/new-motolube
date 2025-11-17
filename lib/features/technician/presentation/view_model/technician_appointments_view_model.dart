import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/use_case/get_technician_appointments_use_case.dart';
import 'technician_appointments_state.dart';

class TechnicianAppointmentsViewModel
    extends StateNotifier<TechnicianAppointmentsState> {
  TechnicianAppointmentsViewModel(this._getAppointments)
    : super(const TechnicianAppointmentsInitial());

  final GetTechnicianAppointmentsUseCase _getAppointments;

  static const String _defaultStatusId = '12';

  Future<void> loadAppointments({
    required String userId,
    DateTime? fromDate,
    DateTime? toDate,
    String statusId = _defaultStatusId,
  }) async {
    if (userId.trim().isEmpty) {
      state = TechnicianAppointmentsError(
        message: 'Missing technician identifier',
        context: const TechnicianAppointmentsRequestContext(
          userId: '',
          fromDate: '',
          toDate: '',
          statusId: _defaultStatusId,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final startDate = fromDate ?? DateTime(now.year, 1, 1);
    final endDate = toDate ?? DateTime(now.year, 12, 31);
    final formatter = DateFormat('dd-MMM-yyyy');
    final formattedFrom = formatter.format(startDate);
    final formattedTo = formatter.format(endDate);

    final context = TechnicianAppointmentsRequestContext(
      userId: userId,
      fromDate: formattedFrom,
      toDate: formattedTo,
      statusId: statusId,
    );

    state = TechnicianAppointmentsLoading(context: context);

    try {
      final appointments = await _getAppointments(
        userId: userId,
        fromDate: formattedFrom,
        toDate: formattedTo,
        statusId: statusId,
      );
      if (!mounted) return;
      if (appointments.isEmpty) {
        state = TechnicianAppointmentsEmpty(context: context);
      } else {
        state = TechnicianAppointmentsLoaded(
          appointments: appointments,
          context: context,
        );
      }
    } catch (error) {
      if (!mounted) return;
      state = TechnicianAppointmentsError(
        message: error.toString(),
        context: context,
      );
    }
  }

  void reset() {
    state = const TechnicianAppointmentsInitial();
  }
}
