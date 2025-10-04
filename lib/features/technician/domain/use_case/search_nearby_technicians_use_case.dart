import '../entity/technician_summary_entity.dart';
import '../repository/i_technician_repository.dart';

class SearchNearbyTechniciansUseCase {
  SearchNearbyTechniciansUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<TechnicianSummaryEntity>> call({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  }) {
    return _repository.searchNearby(
      latitude: latitude,
      longitude: longitude,
      maxResults: maxResults,
      radiusKm: radiusKm,
      serviceId: serviceId,
    );
  }
}
