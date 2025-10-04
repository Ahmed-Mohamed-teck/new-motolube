import '../entity/technician_slot_entity.dart';
import '../entity/technician_summary_entity.dart';

abstract class ITechnicianRepository {
  Future<List<TechnicianSummaryEntity>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  });

  Future<List<TechnicianSlotEntity>> getAvailableSlots({
    required String technicianId,
    required String date,
  });
}
