import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../data/data_source/coupon_remote_data_source.dart';
import '../data/data_source/i_coupon_remote_data_source.dart';
import '../data/repository/coupon_repository.dart';
import '../domain/repository/i_coupon_repository.dart';
import '../domain/use_case/create_coupon_use_case.dart';
import '../domain/use_case/fetch_coupons_use_case.dart';
import '../presentation/view_model/coupon_notifier.dart';
import '../presentation/view_model/coupon_state.dart';

final couponRemoteDataSourceProvider =
    Provider<ICouponRemoteDataSource>((ref) {
  return CouponRemoteDataSource(ref.read(dioProvider));
});

final couponRepositoryProvider = Provider<ICouponRepository>((ref) {
  return CouponRepository(ref.read(couponRemoteDataSourceProvider));
});

final fetchCouponsUseCaseProvider = Provider<FetchCouponsUseCase>((ref) {
  return FetchCouponsUseCase(ref.read(couponRepositoryProvider));
});

final createCouponUseCaseProvider = Provider<CreateCouponUseCase>((ref) {
  return CreateCouponUseCase(ref.read(couponRepositoryProvider));
});

final couponNotifierProvider =
    StateNotifierProvider<CouponNotifier, CouponState>((ref) {
  return CouponNotifier(
    fetchCouponsUseCase: ref.read(fetchCouponsUseCaseProvider),
    createCouponUseCase: ref.read(createCouponUseCaseProvider),
  );
});
