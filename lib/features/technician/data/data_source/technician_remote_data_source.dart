import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/technician_summary_model.dart';
import 'i_technician_remote_data_source.dart';

class TechnicianRemoteDataSource implements ITechnicianRemoteDataSource {
  TechnicianRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<TechnicianSummaryModel>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  }) async {
    try {
      final response = await _dio.get(
        searchNearbyTechniciansEndPoint,
        queryParameters: <String, dynamic>{
          'Latitude': latitude.toStringAsFixed(6),
          'Longitude': longitude.toStringAsFixed(6),
          'MaxResults': maxResults.toString(),
          'RadiusKm': radiusKm.toStringAsFixed(2),
          'ServiceId': serviceId,
        },
      );

      final data = response.data;
      final List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        final maybeList =
            data['data'] ??
            data['technicians'] ??
            data['items'] ??
            data['result'] ??
            data['results'];
        if (maybeList is List) {
          rawList = maybeList;
        } else {
          rawList = [data];
        }
      } else {
        rawList = const [];
      }

      return rawList
          .map((raw) {
            if (raw is Map<String, dynamic>) {
              return TechnicianSummaryModel.fromJson(raw);
            }
            if (raw is Map) {
              return TechnicianSummaryModel.fromJson(
                raw.map((key, value) => MapEntry(key.toString(), value)),
              );
            }
            return null;
          })
          .whereType<TechnicianSummaryModel>()
          .toList();
    } on DioException {
      rethrow;
    }
  }
}
