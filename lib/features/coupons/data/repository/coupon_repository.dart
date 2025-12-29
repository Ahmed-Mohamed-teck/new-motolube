import '../../domain/entity/coupon_entity.dart';
import '../../domain/repository/i_coupon_repository.dart';
import '../data_source/i_coupon_remote_data_source.dart';

class CouponRepository implements ICouponRepository {
  CouponRepository(this._remote);

  final ICouponRemoteDataSource _remote;

  @override
  Future<CouponEntity> createCoupon({
    required String appUserId,
    required String companyName,
    required DateTime fromDate,
    required DateTime toDate,
    required double discountRate,
    required int couponCounts,
    required String domain,
  }) {
    return _remote.createCoupon(
      appUserId: appUserId,
      companyName: companyName,
      fromDate: fromDate,
      toDate: toDate,
      discountRate: discountRate,
      couponCounts: couponCounts,
      domain: domain,
    );
  }

  @override
  Future<List<CouponEntity>> fetchCoupons() {
    return _remote.fetchCoupons();
  }
}
