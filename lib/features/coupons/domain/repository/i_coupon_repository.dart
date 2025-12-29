import '../entity/coupon_entity.dart';

abstract class ICouponRepository {
  Future<List<CouponEntity>> fetchCoupons();
  Future<CouponEntity> createCoupon({
    required String appUserId,
    required String companyName,
    required DateTime fromDate,
    required DateTime toDate,
    required double discountRate,
    required int couponCounts,
    required String domain,
  });
}
