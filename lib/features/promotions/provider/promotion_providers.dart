// Remote Data Source
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/general_providers.dart';
import '../data/data_source/i_promotion_remote_data_source.dart';
import '../data/data_source/promotion_remote_data_source.dart';
import '../data/repository/promotion_repository_impl.dart';
import '../domain/repository/i_promotion_repository.dart';
import '../domain/use_case/add_promotion_use_case.dart';

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