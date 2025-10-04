import '../../domain/entity/technician_slot_entity.dart';

sealed class TechnicianSlotsState {
  const TechnicianSlotsState();
}

class TechnicianSlotsInitial extends TechnicianSlotsState {
  const TechnicianSlotsInitial();
}

class TechnicianSlotsLoading extends TechnicianSlotsState {
  const TechnicianSlotsLoading(this.technicianId);

  final String technicianId;
}

class TechnicianSlotsLoaded extends TechnicianSlotsState {
  const TechnicianSlotsLoaded({
    required this.technicianId,
    required this.slots,
  });

  final String technicianId;
  final List<TechnicianSlotEntity> slots;
}

class TechnicianSlotsEmpty extends TechnicianSlotsState {
  const TechnicianSlotsEmpty(this.technicianId);

  final String technicianId;
}

class TechnicianSlotsError extends TechnicianSlotsState {
  const TechnicianSlotsError({
    required this.technicianId,
    required this.message,
  });

  final String technicianId;
  final String message;
}
