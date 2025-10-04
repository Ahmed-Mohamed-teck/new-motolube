import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/get_technician_available_slots_use_case.dart';
import 'technician_slots_state.dart';

class TechnicianSlotsViewModel extends StateNotifier<TechnicianSlotsState> {
  TechnicianSlotsViewModel(this._getAvailableSlots)
    : super(const TechnicianSlotsInitial());

  final GetTechnicianAvailableSlotsUseCase _getAvailableSlots;

  Future<void> fetch({
    required String technicianId,
    required String date,
  }) async {
    state = TechnicianSlotsLoading(technicianId);
    try {
      final slots = await _getAvailableSlots(
        technicianId: technicianId,
        date: date,
      );
      if (slots.isEmpty) {
        state = TechnicianSlotsEmpty(technicianId);
      } else {
        state = TechnicianSlotsLoaded(technicianId: technicianId, slots: slots);
      }
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 400) {
        state = TechnicianSlotsEmpty(technicianId);
        return;
      }
      state = TechnicianSlotsError(
        technicianId: technicianId,
        message: error.toString(),
      );
    }
  }

  void reset() {
    state = const TechnicianSlotsInitial();
  }
}
