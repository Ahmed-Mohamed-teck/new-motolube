import '../model/technician_slot_model.dart';
import '../model/technician_summary_model.dart';

abstract class ITechnicianRemoteDataSource {
  Future<List<TechnicianSummaryModel>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  });

  Future<List<TechnicianSlotModel>> getAvailableSlots({
    required String technicianId,
    required String date,
  });
}
