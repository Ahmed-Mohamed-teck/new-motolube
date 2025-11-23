import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/upcoming_service_model.dart';
import 'i_upcoming_service_remote_data_source.dart';

class UpcomingServiceRemoteDataSourceImpl
    implements IUpcomingServiceRemoteDataSource {
  final Dio dio;

  UpcomingServiceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<UpcomingServiceModel>> getUpcomingServices({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  }) async {
    try {
      final res = await dio.get(
        getCustomerAppointmentsEndPoint,
        queryParameters: {
          'CustomerId': userId,
          'FromDate': fromDate,
          'ToDate': toDate,
          'Status_Id': '7',
        },
      );

      final data = res.data;
      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        final maybeList =
            data['data'] ?? data['result'] ?? data['appointments'] ?? data['Data'];
        if (maybeList is List) {
          rawList = maybeList;
        } else {
          rawList = const [];
        }
      } else {
        rawList = const [];
      }

      return rawList
          .map((item) {
            if (item is Map<String, dynamic>) {
              return item;
            }
            if (item is Map) {
              return Map<String, dynamic>.from(item as Map);
            }
            return null;
          })
          .whereType<Map<String, dynamic>>()
          .map(UpcomingServiceModel.fromJson)
          .toList();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final reason = e.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch upcoming services [code: $statusCode]: $reason',
      );
    }
  }
}
