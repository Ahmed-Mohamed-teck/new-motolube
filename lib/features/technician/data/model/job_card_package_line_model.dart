import '../../domain/entity/job_card_package_line_entity.dart';

class JobCardPackageLineModel extends JobCardPackageLineEntity {
  JobCardPackageLineModel({
    required super.lineNumber,
    required super.lineId,
    required super.itemCode,
    required super.itemDescription,
    required super.itemType,
    required super.categoryDescription,
    required super.packageLineId,
    required super.packageId,
    required super.itemCategoryId,
    required super.inventoryItemId,
    required super.quantity,
    required super.priceWithoutDiscount,
    required super.priceWithDiscount,
    required super.discountPercentage,
    required super.discountAmount,
    required super.extendedPrice,
    required super.conditionItemCode,
    required super.conditionPrice,
    required super.fromPriceList,
    required super.fixedItemPrice,
    required super.srLineId,
  });

  factory JobCardPackageLineModel.fromJson(Map<String, dynamic> json) {
    int _intFor(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    double _doubleFor(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    String _stringFor(String key) => (json[key] ?? '').toString();

    return JobCardPackageLineModel(
      lineNumber: _stringFor('ln'),
      lineId: _stringFor('lineId'),
      itemCode: _stringFor('itemCode'),
      itemDescription: _stringFor('itemDescription'),
      itemType: _stringFor('itemType'),
      categoryDescription: _stringFor('categoryDescEn'),
      packageLineId: _stringFor('packageLineId'),
      packageId: _stringFor('packageId'),
      itemCategoryId: _stringFor('itemCategoryId'),
      inventoryItemId: _stringFor('inventoryItemId'),
      quantity: _intFor(json['quantity']),
      priceWithoutDiscount: _doubleFor(json['itemPriceNoDiscount']),
      priceWithDiscount: _doubleFor(json['itemPriceWithDiscount']),
      discountPercentage: _doubleFor(json['discount']),
      discountAmount: _doubleFor(json['discountAmt']),
      extendedPrice: _doubleFor(json['extendedPrice']),
      conditionItemCode: _stringFor('condItemCode'),
      conditionPrice: _stringFor('condPrice'),
      fromPriceList: _doubleFor(json['fromPriceList']),
      fixedItemPrice: _doubleFor(json['fixedItemPrice']),
      srLineId: _stringFor('srLineId'),
    );
  }

  JobCardPackageLineEntity toEntity() {
    return JobCardPackageLineEntity(
      lineNumber: lineNumber,
      itemCode: itemCode,
      itemDescription: itemDescription,
      lineId: lineId.isNotEmpty ? lineId : packageLineId,
      itemType: itemType,
      categoryDescription: categoryDescription,
      packageLineId: packageLineId,
      packageId: packageId,
      itemCategoryId: itemCategoryId,
      inventoryItemId: inventoryItemId,
      quantity: quantity,
      priceWithoutDiscount: priceWithoutDiscount,
      priceWithDiscount: priceWithDiscount,
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      extendedPrice: extendedPrice,
      conditionItemCode: conditionItemCode,
      conditionPrice: conditionPrice,
      fromPriceList: fromPriceList,
      fixedItemPrice: fixedItemPrice,
      srLineId: srLineId,
    );
  }
}
