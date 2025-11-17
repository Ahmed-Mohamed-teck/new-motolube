sealed class TechnicianAppointmentUpdateState {
  const TechnicianAppointmentUpdateState();
}

class TechnicianAppointmentUpdateIdle extends TechnicianAppointmentUpdateState {
  const TechnicianAppointmentUpdateIdle();
}

class TechnicianAppointmentUpdateLoading
    extends TechnicianAppointmentUpdateState {
  const TechnicianAppointmentUpdateLoading();
}

class TechnicianAppointmentUpdateSuccess
    extends TechnicianAppointmentUpdateState {
  const TechnicianAppointmentUpdateSuccess();
}

class TechnicianAppointmentUpdateError
    extends TechnicianAppointmentUpdateState {
  const TechnicianAppointmentUpdateError(this.message);

  final String message;
}
