import '../../domain/entity/technician_appointment_entity.dart';

class TechnicianAppointmentsRequestContext {
  final String userId;
  final String fromDate;
  final String toDate;
  final String statusId;

  const TechnicianAppointmentsRequestContext({
    required this.userId,
    required this.fromDate,
    required this.toDate,
    required this.statusId,
  });

  TechnicianAppointmentsRequestContext copyWith({
    String? userId,
    String? fromDate,
    String? toDate,
    String? statusId,
  }) {
    return TechnicianAppointmentsRequestContext(
      userId: userId ?? this.userId,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      statusId: statusId ?? this.statusId,
    );
  }
}

sealed class TechnicianAppointmentsState {
  final TechnicianAppointmentsRequestContext? context;

  const TechnicianAppointmentsState({this.context});
}

class TechnicianAppointmentsInitial extends TechnicianAppointmentsState {
  const TechnicianAppointmentsInitial() : super(context: null);
}

class TechnicianAppointmentsLoading extends TechnicianAppointmentsState {
  const TechnicianAppointmentsLoading({
    required TechnicianAppointmentsRequestContext context,
  }) : super(context: context);
}

class TechnicianAppointmentsLoaded extends TechnicianAppointmentsState {
  final List<TechnicianAppointmentEntity> appointments;

  const TechnicianAppointmentsLoaded({
    required this.appointments,
    required TechnicianAppointmentsRequestContext context,
  }) : super(context: context);
}

class TechnicianAppointmentsEmpty extends TechnicianAppointmentsState {
  const TechnicianAppointmentsEmpty({
    required TechnicianAppointmentsRequestContext context,
  }) : super(context: context);
}

class TechnicianAppointmentsError extends TechnicianAppointmentsState {
  final String message;

  const TechnicianAppointmentsError({
    required this.message,
    required TechnicianAppointmentsRequestContext context,
  }) : super(context: context);
}
