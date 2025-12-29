class CouponEntity {
  const CouponEntity({
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
}
