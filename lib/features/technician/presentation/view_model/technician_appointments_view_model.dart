import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/technician_appointment_entity.dart';
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
    List<int>? statusIds,
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

    final statusIdList =
        (statusIds != null && statusIds.isNotEmpty)
            ? statusIds
            : _parseStatusIds(statusId);

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
      statusId: statusIdList.map((e) => e.toString()).join(','),
    );

    state = TechnicianAppointmentsLoading(context: context);

    try {
      final merged = <String, TechnicianAppointmentEntity>{};
      for (final id in statusIdList) {
        final appointments = await _getAppointments(
          userId: userId,
          fromDate: formattedFrom,
          toDate: formattedTo,
          statusId: id.toString(),
        );
        for (final appointment in appointments) {
          merged[appointment.bookingId] = appointment;
        }
      }
      final combinedAppointments = merged.values.toList();
      if (!mounted) return;
      if (combinedAppointments.isEmpty) {
        state = TechnicianAppointmentsEmpty(context: context);
      } else {
        state = TechnicianAppointmentsLoaded(
          appointments: combinedAppointments,
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

  List<int> _parseStatusIds(String statusId) {
    final parts = statusId.split(',').map((e) => e.trim()).where(
      (element) => element.isNotEmpty,
    );
    final parsed = <int>[];
    for (final part in parts) {
      final value = int.tryParse(part);
      if (value != null) {
        parsed.add(value);
      }
    }
    if (parsed.isEmpty) {
      final fallback = int.tryParse(_defaultStatusId) ?? 0;
      return fallback > 0 ? [fallback] : <int>[12];
    }
    return parsed;
  }
}
