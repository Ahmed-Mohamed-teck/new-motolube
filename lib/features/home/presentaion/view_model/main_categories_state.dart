import '../../domain/entity/main_category_entity.dart';

sealed class MainCategoriesState {
  const MainCategoriesState();
}

class MainCategoriesInitial extends MainCategoriesState {
  const MainCategoriesInitial();
}

class MainCategoriesLoading extends MainCategoriesState {
  const MainCategoriesLoading();
}

class MainCategoriesLoaded extends MainCategoriesState {
  final List<MainCategoryEntity> categories;

  const MainCategoriesLoaded(this.categories);
}

class MainCategoriesError extends MainCategoriesState {
  final String message;

  const MainCategoriesError(this.message);
}
