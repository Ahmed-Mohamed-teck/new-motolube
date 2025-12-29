class CouponHeaderModel {
  CouponHeaderModel({
    this.transactionNo = '',
    this.companyName = '',
    this.createdBy = '',
    this.creationDate,
    this.isActive = 'Y',
    this.fromDate,
    this.toDate,
    this.discountRate = 0.0,
    this.couponCounts = 0,
    this.link,
    this.fileName,
    this.linkBackEnd,
    this.appUserId,
    this.domain,
  });

  final String transactionNo;
  final String companyName;
  final String createdBy;
  final DateTime? creationDate;
  final String isActive;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double discountRate;
  final int couponCounts;
  final String? link;
  final String? fileName;
  final String? linkBackEnd;
  final String? appUserId;
  final String? domain;

  factory CouponHeaderModel.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) {
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
      return null;
    }

    return CouponHeaderModel(
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
