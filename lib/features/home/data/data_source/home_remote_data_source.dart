import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/main_category_model.dart';
import 'i_home_remote_data_source.dart';

class HomeRemoteDataSource implements IHomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSource(this.dio);

  @override
  Future<List<MainCategoryModel>> getMainCategories() async {
    try {
      final response = await dio.get(getMainCategoriesEndPoint);
      final data = response.data;

      final rawList = _extractList(data);

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
          .map(MainCategoryModel.fromJson)
          .toList();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final reason = e.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch main categories [code: $statusCode]: $reason',
      );
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      final maybeList = data['data'] ?? data['Data'];
      if (maybeList is List) {
        return maybeList;
      }
    }
    return const [];
  }
}
