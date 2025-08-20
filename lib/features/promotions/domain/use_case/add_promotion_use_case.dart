import '../entity/promotion_entity.dart';
import '../repository/i_promotion_repository.dart';

class AddPromotionUseCase {
  final IPromotionRepository repository;

  AddPromotionUseCase(this.repository);

  Future<void> call(PromotionEntity promotion) {
    return repository.addPromotion(promotion);
  }
}
