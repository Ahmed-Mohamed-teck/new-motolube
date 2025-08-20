import 'dart:io';
import '../../domain/entity/promotion_entity.dart';
import '../../domain/repository/i_promotion_repository.dart';
import '../data_source/i_promotion_remote_data_source.dart';
import '../model/promotion_model.dart';

class PromotionRepositoryImpl implements IPromotionRepository {
  final IPromotionRemoteDataSource remoteDataSource;

  PromotionRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addPromotion(PromotionEntity promotion) async {
    final model = PromotionModel(
      id: promotion.id,
      name: promotion.name,
      description: promotion.description,
      startDate: promotion.startDate,
      endDate: promotion.endDate,
      imageUrl: promotion.imageUrl,
    );
    await remoteDataSource.uploadPromotion(model);
  }

  @override
  Future<String> uploadImage(File imageFile) {
    return remoteDataSource.uploadImage(imageFile);
  }
}





