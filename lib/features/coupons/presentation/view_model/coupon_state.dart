import '../../domain/entity/coupon_entity.dart';

abstract class CouponState {}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponError extends CouponState {
  CouponError(this.message);
  final String message;
}

class CouponEmpty extends CouponState {}

class CouponLoaded extends CouponState {
  CouponLoaded(this.coupons);
  final List<CouponEntity> coupons;
}

class CouponCreating extends CouponState {}

class CouponCreated extends CouponState {
  CouponCreated(this.coupon);
  final CouponEntity coupon;
}
