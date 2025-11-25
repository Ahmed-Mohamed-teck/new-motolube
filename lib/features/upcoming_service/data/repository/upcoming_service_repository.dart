import 'package:newmotorlube/features/auth/domain/repository/i_auth_local_repository.dart';

import '../../domain/entity/upcoming_service_entity.dart';
import '../../domain/repository/i_upcoming_service_repository.dart';
import '../data_source/i_upcoming_service_remote_data_source.dart';

class UpcomingServiceRepository implements IUpcomingServiceRepository {
  UpcomingServiceRepository(
    this._remoteDataSource,
    this._authLocalRepository,
  );

  final IUpcomingServiceRemoteDataSource _remoteDataSource;
  final IAuthLocalRepository _authLocalRepository;

  static const _defaultUserId = '7744';

  @override
  Future<List<UpcomingServiceEntity>> getUpcomingServices() async {
    String userId = _defaultUserId;

    try {
      final storedAuth = await _authLocalRepository.getStoredAuth();
      final oracleId = storedAuth?.oracleId;
      if (oracleId != null && oracleId.isNotEmpty) {
        userId = oracleId;
      }
    } catch (_) {
      // Ignore and fallback to default static value
    }

    final models = await _remoteDataSource.getUpcomingServices(
      userId: userId,
    );

    return List<UpcomingServiceEntity>.from(models);
  }
}
