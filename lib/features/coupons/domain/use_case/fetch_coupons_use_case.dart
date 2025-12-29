import '../entity/coupon_entity.dart';
import '../repository/i_coupon_repository.dart';

class FetchCouponsUseCase {
  FetchCouponsUseCase(this._repository);

  final ICouponRepository _repository;

  Future<List<CouponEntity>> call() {
    return _repository.fetchCoupons();
  }
}
