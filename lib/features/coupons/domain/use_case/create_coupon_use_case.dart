import '../entity/coupon_entity.dart';
import '../repository/i_coupon_repository.dart';

class CreateCouponUseCase {
  CreateCouponUseCase(this._repository);

  final ICouponRepository _repository;

  Future<CouponEntity> call({
    required String appUserId,
    required String companyName,
    required DateTime fromDate,
    required DateTime toDate,
    required double discountRate,
    required int couponCounts,
    required String domain,
  }) {
    return _repository.createCoupon(
      appUserId: appUserId,
      companyName: companyName,
      fromDate: fromDate,
      toDate: toDate,
      discountRate: discountRate,
      couponCounts: couponCounts,
      domain: domain,
    );
  }
}
