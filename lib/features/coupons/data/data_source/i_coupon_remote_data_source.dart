import '../model/coupon_model.dart';

abstract class ICouponRemoteDataSource {
  Future<List<CouponModel>> fetchCoupons();
  Future<CouponModel> createCoupon({
    required String appUserId,
    required String companyName,
    required DateTime fromDate,
    required DateTime toDate,
    required double discountRate,
    required int couponCounts,
    required String domain,
  });
}
