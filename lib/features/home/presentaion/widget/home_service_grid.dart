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

    return SizedBox(
      height: 148,
      child: ListView.separated(
        key: const PageStorageKey<String>('home-services-horizontal-list'),
        scrollDirection: Axis.horizontal,
        primary: false,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
        itemCount: state.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = state.categories[index];
          final title = category.titleForLocale(locale);

          return SizedBox(
            width: 120,
            child: HomeServiceCard(
              key: ValueKey<String>('home-service-${category.id}'),
              title: title,
              photoUrl: category.photoUrl,
              onTap: () {
                ref.read(home.selectedMainCategoryProvider.notifier).state =
                    category;
                ref.read(currentNavBottomIndexProvider.notifier).state = 2;
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder:
            (_, index) => const SizedBox(
              width: 120,
              child: HomeServiceCard(title: '', isLoading: true),
            ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.home_repair_service_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).noServicesAvailable,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String message) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: Card(
        margin: EdgeInsets.zero,
        color: theme.colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      S.of(context).unableToLoadServices,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
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
