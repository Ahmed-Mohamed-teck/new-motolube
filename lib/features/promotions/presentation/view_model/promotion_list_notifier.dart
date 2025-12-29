import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/promotion_entity.dart';
import '../../domain/use_case/delete_promotion_use_case.dart';
import '../../domain/use_case/fetch_promotions_use_case.dart';

abstract class ViewState {}

class InitialViewState implements ViewState {}

class LoadingViewState implements ViewState {}

class ErrorViewState implements ViewState {
  final String? errorMessage;

  ErrorViewState({this.errorMessage});
}

class EmptyViewState implements ViewState {}

class LoadedViewState<T extends Object> implements ViewState {
  final T data;

  LoadedViewState(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadedViewState<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'LoadedViewState(data: $data)';

  LoadedViewState<T> copyWith({
    T? data,
  }) {
    return LoadedViewState<T>(
      data ?? this.data,
    );
  }
}

class PromotionListNotifier extends StateNotifier<ViewState> {
  PromotionListNotifier({
    required FetchPromotionsUseCase fetchUseCase,
    required DeletePromotionUseCase deleteUseCase,
  })  : _fetchUseCase = fetchUseCase,
        _deleteUseCase = deleteUseCase,
        super(InitialViewState()) {
    load();
  }

  final FetchPromotionsUseCase _fetchUseCase;
  final DeletePromotionUseCase _deleteUseCase;


  Future<void> load() async {
    state = InitialViewState();
    try {
      final data = await _fetchUseCase();
      if (data.isEmpty) {
        state = EmptyViewState();
      } else {
        state = LoadedViewState<List<PromotionEntity>>(data);
      }
    } catch (e) {
      state = ErrorViewState(errorMessage: e.toString());
    }
  }

  Future<void> delete(String promotionId) async {
    final currentData = state is LoadedViewState<List<PromotionEntity>>
        ? (state as LoadedViewState<List<PromotionEntity>>).data
        : <PromotionEntity>[];
    final updated = currentData.where((p) => p.id != promotionId).toList();
    state = updated.isEmpty
        ? EmptyViewState()
        : LoadedViewState<List<PromotionEntity>>(updated);
    try {
      await _deleteUseCase(promotionId);
    } catch (e) {
      state = ErrorViewState(errorMessage: e.toString());
    }
  }
}
