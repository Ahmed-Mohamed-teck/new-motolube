import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/get_main_categories_use_case.dart';
import 'main_categories_state.dart';

class MainCategoriesViewModel extends StateNotifier<MainCategoriesState> {
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;

  MainCategoriesViewModel(this._getMainCategoriesUseCase)
      : super(const MainCategoriesInitial());

  Future<void> fetchCategories() async {
    if (state is MainCategoriesLoading) {
      return;
    }
    state = const MainCategoriesLoading();
    try {
      final categories = await _getMainCategoriesUseCase();
      state = MainCategoriesLoaded(categories);
    } catch (e) {
      state = MainCategoriesError(e.toString());
    }
  }
}
