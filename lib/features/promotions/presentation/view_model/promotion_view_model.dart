import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/promotion_entity.dart';
import '../../domain/repository/i_promotion_repository.dart';
import '../../domain/use_case/add_promotion_use_case.dart';
import '../../provider/promotion_providers.dart';

final promotionViewModelProvider =
AutoDisposeAsyncNotifierProvider<PromotionViewModel, void>(PromotionViewModel.new);

class PromotionViewModel extends  AutoDisposeAsyncNotifier<void> {
   late final AddPromotionUseCase _addPromotionUseCase;
   late final IPromotionRepository _repository;


  @override
  Future<void> build() async {
    // Initial setup if needed
    _addPromotionUseCase = ref.read(addPromotionUseCaseProvider);
    _repository = ref.read(promotionRepositoryProvider);
  }

  Future<String> uploadImage(File file) async {
    return await _repository.uploadImage(file);
  }

  Future<void> savePromotion(PromotionEntity promotion) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _addPromotionUseCase(promotion));
  }
}
