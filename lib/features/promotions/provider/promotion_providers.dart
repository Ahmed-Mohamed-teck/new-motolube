// Remote Data Source
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/general_providers.dart';
import '../data/data_source/i_promotion_remote_data_source.dart';
import '../data/data_source/promotion_remote_data_source.dart';
import '../data/repository/promotion_repository_impl.dart';
import '../domain/entity/promotion_entity.dart';
import '../domain/repository/i_promotion_repository.dart';
import '../domain/use_case/add_promotion_use_case.dart';
import '../domain/use_case/fetch_promotions_use_case.dart';
import '../domain/use_case/delete_promotion_use_case.dart';
import '../presentation/view_model/promotion_list_notifier.dart';

final promotionRemoteDataSourceProvider = Provider<IPromotionRemoteDataSource>(
      (ref) => PromotionRemoteDataSourceImpl(
    ref.read(firebaseFirestoreProvider),
    ref.read(firebaseStorageProvider),
  ),
);

// Repository
final promotionRepositoryProvider = Provider<IPromotionRepository>(
      (ref) => PromotionRepositoryImpl(ref.read(promotionRemoteDataSourceProvider)),
);

final addPromotionUseCaseProvider = Provider<AddPromotionUseCase>(
      (ref) => AddPromotionUseCase(ref.read(promotionRepositoryProvider)),
);

final fetchPromotionsUseCaseProvider = Provider<FetchPromotionsUseCase>(
      (ref) => FetchPromotionsUseCase(ref.read(promotionRepositoryProvider)),
);

final deletePromotionUseCaseProvider = Provider<DeletePromotionUseCase>(
      (ref) => DeletePromotionUseCase(ref.read(promotionRepositoryProvider)),
);

final promotionListProvider = StateNotifierProvider<PromotionListNotifier, AsyncValue<List<PromotionEntity>>>(
      (ref) => PromotionListNotifier(
    fetchUseCase: ref.read(fetchPromotionsUseCaseProvider),
    deleteUseCase: ref.read(deletePromotionUseCaseProvider),
  ),
);
