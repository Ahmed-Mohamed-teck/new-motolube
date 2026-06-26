import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/home/provider/home_provider.dart' as home;
import 'package:newmotorlube/features/home/presentaion/view_model/main_categories_state.dart';
import 'package:newmotorlube/features/home/presentaion/screen/base_home_screen.dart';

import 'package:newmotorlube/generated/l10n.dart';

import 'home_service_card.dart';

class HomeServiceGrid extends ConsumerWidget {
  const HomeServiceGrid({super.key, required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isAuthenticated) {
      return _buildEmptyState(context);
    }

    final categoriesState = ref.watch(home.mainCategoriesViewModelProvider);

    if (categoriesState is MainCategoriesInitial) {
      Future.microtask(() {
        ref
            .read(home.mainCategoriesViewModelProvider.notifier)
            .fetchCategories();
      });
    }

    if (categoriesState is MainCategoriesLoaded) {
      if (categoriesState.categories.isEmpty) {
        return _buildEmptyState(context);
      }
      return _buildCategoryGrid(context, ref, categoriesState);
    }

    if (categoriesState is MainCategoriesError) {
      return _buildErrorState(context, ref, categoriesState.message);
    }

    return _buildLoadingGrid();
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    WidgetRef ref,
    MainCategoriesLoaded state,
  ) {
    final locale = Localizations.localeOf(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: .75,
      ),
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];
        final title = category.titleForLocale(locale);

        return GestureDetector(
          onTap: () {
            ref.read(home.selectedMainCategoryProvider.notifier).state =
                category;
            ref.read(currentNavBottomIndexProvider.notifier).state = 2;
          },
          child: HomeServiceCard(title: title, photoUrl: category.photoUrl),
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      childAspectRatio: .75,
      padding: const EdgeInsets.all(8.0),
      children: List.generate(
        8,
        (_) => const HomeServiceCard(title: '', isLoading: true),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Text(
        S.of(context).noServicesAvailable,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).unableToLoadServices,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    ref
                        .read(home.mainCategoriesViewModelProvider.notifier)
                        .fetchCategories();
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(S.of(context).retryButtonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
