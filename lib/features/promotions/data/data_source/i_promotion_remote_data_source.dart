import 'dart:io';
import '../model/promotion_model.dart';

abstract class IPromotionRemoteDataSource {
  Future<void> uploadPromotion(PromotionModel promotion);
  Future<String> uploadImage(File imageFile);
}