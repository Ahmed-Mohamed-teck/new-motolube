import 'coupon_header_model.dart';
import 'status_info_model.dart';

class CouponHeaderDataModel {
  CouponHeaderDataModel({
    required this.coupons,
    required this.statusInfo,
  });

  final List<CouponHeaderModel> coupons;
  final StatusInfoModel statusInfo;

  factory CouponHeaderDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? const [];
    final coupons = data
        .map((e) => CouponHeaderModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return CouponHeaderDataModel(
      coupons: coupons,
      statusInfo: StatusInfoModel.fromJson(
        Map<String, dynamic>.from(json['statusInfo'] as Map? ?? {}),
      ),
    );
  }
}
