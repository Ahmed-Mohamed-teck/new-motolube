import '../../domain/entity/technician_summary_entity.dart';
import '../../domain/repository/i_technician_repository.dart';
import '../data_source/i_technician_remote_data_source.dart';

class TechnicianRepository implements ITechnicianRepository {
  TechnicianRepository(this._remoteDataSource);

  final ITechnicianRemoteDataSource _remoteDataSource;

  @override
  Future<List<TechnicianSummaryEntity>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  }) async {
    final models = await _remoteDataSource.searchNearby(
      latitude: latitude,
      longitude: longitude,
      maxResults: maxResults,
      radiusKm: radiusKm,
      serviceId: serviceId,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
