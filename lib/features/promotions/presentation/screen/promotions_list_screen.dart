import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widget/internal_app_bar.dart';
import '../../domain/entity/promotion_entity.dart';
import '../../provider/promotion_providers.dart';
import '../view_model/promotion_list_notifier.dart';
import '../../../../generated/l10n.dart';

class PromotionsListScreen extends ConsumerStatefulWidget {
  const PromotionsListScreen({super.key});

  @override
  ConsumerState<PromotionsListScreen> createState() =>
      _PromotionsListScreenState();
}

class _PromotionsListScreenState extends ConsumerState<PromotionsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoaded();
    });
  }

  void _ensureLoaded() {
    final notifier = ref.read(promotionListProvider.notifier);
    notifier.load();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promotionListProvider);
    final notifier = ref.read(promotionListProvider.notifier);

    return Scaffold(
      appBar: InternalAppBar(
        title: S.of(context).promotionsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.load,
          ),
        ],
      ),
      body: _buildBody(state, notifier),
    );
  }

  Widget _buildBody(ViewState state, PromotionListNotifier notifier) {
    if (state is LoadingViewState || state is InitialViewState) {
      return const _PromotionsSkeleton();
    }
    if (state is ErrorViewState) {
      return _ErrorView(
        message: state.errorMessage ?? S.of(context).promotionsLoadErrorFallback,
        onRetry: notifier.load,
      );
    }
    if (state is EmptyViewState) {
      return Center(child: Text(S.of(context).noPromotionsFound));
    }
    if (state is LoadedViewState<List<PromotionEntity>>) {
      final promotions = state.data;
      return RefreshIndicator(
        onRefresh: notifier.load,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final promotion = promotions[index];
            return _PromotionCard(
              promotion: promotion,
              onDelete: () => notifier.delete(promotion.id),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: promotions.length,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _PromotionCard extends StatelessWidget {
  const _PromotionCard({
    required this.promotion,
    required this.onDelete,
  });

  final PromotionEntity promotion;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');
    final dateRange =
        '${formatter.format(promotion.startDate)} - ${formatter.format(promotion.endDate)}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                promotion.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promotion.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    promotion.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateRange,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: S.of(context).deleteTooltip,
            ),
          ],
        ),
      ),
    );
  }
}

class _PromotionsSkeleton extends StatelessWidget {
  const _PromotionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 180,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 140,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 12,
                        width: 120,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(S.of(context).retryButtonLabel),
          ),
        ],
      ),
    );
  }
}
