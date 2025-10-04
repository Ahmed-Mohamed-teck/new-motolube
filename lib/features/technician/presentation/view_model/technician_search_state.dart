import '../../domain/entity/technician_summary_entity.dart';

sealed class TechnicianSearchState {
  const TechnicianSearchState();
}

class TechnicianSearchInitial extends TechnicianSearchState {
  const TechnicianSearchInitial();
}

class TechnicianSearchLoading extends TechnicianSearchState {
  const TechnicianSearchLoading();
}

class TechnicianSearchLoaded extends TechnicianSearchState {
  const TechnicianSearchLoaded(this.technicians);

  final List<TechnicianSummaryEntity> technicians;
}

class TechnicianSearchEmpty extends TechnicianSearchState {
  const TechnicianSearchEmpty();
}

class TechnicianSearchError extends TechnicianSearchState {
  const TechnicianSearchError(this.message);

  final String message;
}
