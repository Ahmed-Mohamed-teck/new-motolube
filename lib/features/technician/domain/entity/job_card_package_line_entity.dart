class JobCardPackageLineEntity {
  final String lineNumber;
  final String lineId;
  final String itemCode;
  final String itemDescription;
  final String itemType;
  final String categoryDescription;
  final String packageLineId;
  final String packageId;
  final String itemCategoryId;
  final String inventoryItemId;
  final int quantity;
  final double priceWithoutDiscount;
  final double priceWithDiscount;
  final double discountPercentage;
  final double discountAmount;
  final double extendedPrice;
  final String conditionItemCode;
  final String conditionPrice;
  final double fromPriceList;
  final double fixedItemPrice;
  final String srLineId;

  const JobCardPackageLineEntity({
    required this.lineNumber,
    required this.lineId,
    required this.itemCode,
    required this.itemDescription,
    required this.itemType,
    required this.categoryDescription,
    required this.packageLineId,
    required this.packageId,
    required this.itemCategoryId,
    required this.inventoryItemId,
    required this.quantity,
    required this.priceWithoutDiscount,
    required this.priceWithDiscount,
    required this.discountPercentage,
    required this.discountAmount,
    required this.extendedPrice,
    required this.conditionItemCode,
    required this.conditionPrice,
    required this.fromPriceList,
    required this.fixedItemPrice,
    required this.srLineId,
  });
}
