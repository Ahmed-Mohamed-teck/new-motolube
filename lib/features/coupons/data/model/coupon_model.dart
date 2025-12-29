import '../../domain/entity/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    super.transactionNo = '',
    super.companyName = '',
    super.createdBy = '',
    super.creationDate,
    super.isActive = 'Y',
    super.fromDate,
    super.toDate,
    super.discountRate = 0.0,
    super.couponCounts = 0,
    super.link,
    super.fileName,
    super.linkBackEnd,
    super.appUserId,
    super.domain,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) {
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
      return null;
    }

    return CouponModel(
      transactionNo: json['transactionNo'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      creationDate: _parseDate(json['creationDate']),
      isActive: json['isActive'] as String? ?? 'Y',
      fromDate: _parseDate(json['fromDate']),
      toDate: _parseDate(json['toDate']),
      discountRate: (json['discountRate'] as num?)?.toDouble() ?? 0.0,
      couponCounts: (json['couponCounts'] as num?)?.toInt() ?? 0,
      link: json['link'] as String?,
      fileName: json['fileName'] as String?,
      linkBackEnd: json['linkBackEnd'] as String?,
      appUserId: json['appUserId'] as String?,
      domain: json['domain'] as String?,
    );
  }
}
