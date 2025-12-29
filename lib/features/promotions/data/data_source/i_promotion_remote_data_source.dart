import 'dart:io';
import '../model/promotion_model.dart';

abstract class IPromotionRemoteDataSource {
  Future<void> uploadPromotion(PromotionModel promotion);
  Future<String> uploadImage(File imageFile);
  Future<List<PromotionModel>> fetchPromotions();
  Future<void> deletePromotion(String promotionId);
}
