import '../repository/i_promotion_repository.dart';

class DeletePromotionUseCase {
  DeletePromotionUseCase(this._repository);

  final IPromotionRepository _repository;

  Future<void> call(String promotionId) {
    return _repository.deletePromotion(promotionId);
  }
}
