import 'dart:io';

import '../entity/promotion_entity.dart';

abstract class IPromotionRepository {
  Future<void> addPromotion(PromotionEntity promotion);
  Future<String> uploadImage(File imageFile);
  Future<List<PromotionEntity>> fetchPromotions();
  Future<void> deletePromotion(String promotionId);
}
