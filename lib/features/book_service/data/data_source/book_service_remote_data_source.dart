import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/service_package_model.dart';
import 'i_book_service_remote_data_source.dart';

class BookServiceRemoteDataSource implements IBookServiceRemoteDataSource {
  final Dio _dio;

  BookServiceRemoteDataSource(this._dio);

  @override
  Future<List<ServicePackageModel>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
  }) async {
    try {
      final response = await _dio.get(
        getPackagesForVehicleEndPoint(customerId, vehicleId),
      );
      final data = response.data;
      final List<dynamic> rawList = _extractPackages(data);
      return rawList
          .map(
            (item) => ServicePackageModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  List<dynamic> _extractPackages(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      final possibleList = data['packages'] ?? data['items'] ?? data['data'];
      if (possibleList is List) {
        return possibleList;
      }
    }
    return const [];
  }
}
