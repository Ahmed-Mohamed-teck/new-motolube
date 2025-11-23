import '../../domain/entity/custom_package_item_entity.dart';

class CustomPackageItemModel extends CustomPackageItemEntity {
  CustomPackageItemModel({
    required super.itemCode,
    required super.description,
    required super.itemType,
    required super.inventoryItemId,
  });

  factory CustomPackageItemModel.fromJson(Map<String, dynamic> json) {
    String _stringFor(String key) => (json[key] ?? '').toString();
    return CustomPackageItemModel(
      itemCode: _stringFor('itemCode'),
      description: _stringFor('description'),
      itemType: _stringFor('itemType'),
      inventoryItemId: _stringFor('inventoryItemId'),
    );
  }

  CustomPackageItemEntity toEntity() {
    return CustomPackageItemEntity(
      itemCode: itemCode,
      description: description,
      itemType: itemType,
      inventoryItemId: inventoryItemId,
    );
  }
}
