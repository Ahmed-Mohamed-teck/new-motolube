import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/create_coupon_use_case.dart';
import '../../domain/use_case/fetch_coupons_use_case.dart';
import 'coupon_state.dart';

class CouponNotifier extends StateNotifier<CouponState> {
  CouponNotifier({
    required FetchCouponsUseCase fetchCouponsUseCase,
    required CreateCouponUseCase createCouponUseCase,
  })  : _fetchCouponsUseCase = fetchCouponsUseCase,
        _createCouponUseCase = createCouponUseCase,
        super(CouponInitial());

  final FetchCouponsUseCase _fetchCouponsUseCase;
  final CreateCouponUseCase _createCouponUseCase;

  Future<void> load() async {
    state = CouponLoading();
    try {
      final coupons = await _fetchCouponsUseCase();
      if (coupons.isEmpty) {
        state = CouponEmpty();
      } else {
        state = CouponLoaded(coupons);
      }
    } catch (e) {
      state = CouponError(e.toString());
    }
  }

  Future<void> create({
    required String appUserId,
    required String companyName,
    required DateTime fromDate,
    required DateTime toDate,
    required double discountRate,
    required int couponCounts,
    String domain = '0',
  }) async {
    state = CouponCreating();
    try {
      await _createCouponUseCase(
        appUserId: appUserId,
        companyName: companyName,
        fromDate: fromDate,
        toDate: toDate,
        discountRate: discountRate,
        couponCounts: couponCounts,
        domain: domain,
      );
      await load();
    } catch (e) {
      state = CouponError(e.toString());
    }
  }
}
