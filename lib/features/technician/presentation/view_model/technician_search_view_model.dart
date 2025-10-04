import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/technician_summary_entity.dart';
import '../../domain/use_case/search_nearby_technicians_use_case.dart';
import 'technician_search_state.dart';

class TechnicianSearchViewModel extends StateNotifier<TechnicianSearchState> {
  TechnicianSearchViewModel(this._searchNearbyTechnicians)
    : super(const TechnicianSearchInitial());

  final SearchNearbyTechniciansUseCase _searchNearbyTechnicians;

  Future<void> search({
    required double latitude,
    required double longitude,
    required String serviceId,
    int maxResults = 20,
    double radiusKm = 25,
  }) async {
    state = const TechnicianSearchLoading();
    try {
      final technicians = await _searchNearbyTechnicians(
        latitude: latitude,
        longitude: longitude,
        maxResults: maxResults,
        radiusKm: radiusKm,
        serviceId: serviceId,
      );
      if (technicians.isEmpty) {
        state = const TechnicianSearchEmpty();
      } else {
        state = TechnicianSearchLoaded(technicians);
      }
    } catch (error) {
      state = TechnicianSearchError(error.toString());
    }
  }

  void reset() {
    state = const TechnicianSearchInitial();
  }

  List<TechnicianSummaryEntity> get currentResults {
    final currentState = state;
    if (currentState is TechnicianSearchLoaded) {
      return currentState.technicians;
    }
    return const [];
  }
}
