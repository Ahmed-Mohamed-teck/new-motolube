import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/promotion_entity.dart';
import '../../domain/use_case/delete_promotion_use_case.dart';
import '../../domain/use_case/fetch_promotions_use_case.dart';

class PromotionListNotifier
    extends StateNotifier<AsyncValue<List<PromotionEntity>>> {
  PromotionListNotifier({
    required FetchPromotionsUseCase fetchUseCase,
    required DeletePromotionUseCase deleteUseCase,
  })  : _fetchUseCase = fetchUseCase,
        _deleteUseCase = deleteUseCase,
        super(const AsyncLoading()) {
    load();
  }

  final FetchPromotionsUseCase _fetchUseCase;
  final DeletePromotionUseCase _deleteUseCase;

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchUseCase);
  }

  Future<void> delete(String promotionId) async {
    final current = state.value ?? [];
    state = AsyncValue.data(
      current.where((p) => p.id != promotionId).toList(),
    );
    try {
      await _deleteUseCase(promotionId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
