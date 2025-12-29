import '../entity/promotion_entity.dart';
import '../repository/i_promotion_repository.dart';

class FetchPromotionsUseCase {
  FetchPromotionsUseCase(this._repository);

  final IPromotionRepository _repository;

  Future<List<PromotionEntity>> call() {
    return _repository.fetchPromotions();
  }
}
