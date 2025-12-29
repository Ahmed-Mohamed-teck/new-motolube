import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/coupon_model.dart';
import 'i_coupon_remote_data_source.dart';

class CouponRemoteDataSource implements ICouponRemoteDataSource {
  CouponRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<CouponModel>> fetchCoupons() async {
    final response = await _dio.get(getCouponsEndPoint);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => CouponModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    throw const FormatException('Unexpected response');
  }

  @override
  Future<CouponModel> createCoupon({
    required String appUserId,
    required String companyName,
    required DateTime fromDate,
    required DateTime toDate,
    required double discountRate,
    required int couponCounts,
    required String domain,
  }) async {
    final url = addCouponEndPoint(
      appUserId: appUserId,
      companyName: companyName,
      fromDate: fromDate.toString(),
      toDate: toDate.toString(),
      discountRate: discountRate.toString(),
      couponCounts: couponCounts.toString(),
      domain: domain,
    );
    final response = await _dio.get(url);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final list = data['data'] as List<dynamic>? ?? [];
      if (list.isNotEmpty) {
        return CouponModel.fromJson(Map<String, dynamic>.from(list.first as Map));
      }
    }
    throw const FormatException('Unexpected response');
  }
}
