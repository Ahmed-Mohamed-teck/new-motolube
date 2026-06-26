import 'package:intl/intl.dart';
import 'package:newmotorlube/features/auth/domain/repository/i_auth_local_repository.dart';

import '../../domain/entity/upcoming_service_entity.dart';
import '../../domain/repository/i_upcoming_service_repository.dart';
import '../data_source/i_upcoming_service_remote_data_source.dart';

class UpcomingServiceRepository implements IUpcomingServiceRepository {
  UpcomingServiceRepository(this._remoteDataSource, this._authLocalRepository);

  final IUpcomingServiceRemoteDataSource _remoteDataSource;
  final IAuthLocalRepository _authLocalRepository;

  static const _defaultUserId = '7744';

  @override
  Future<List<UpcomingServiceEntity>> getUpcomingServices({
    DateTime? fromDate,
    DateTime? toDate,
    int? statusId,
  }) async {
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

    final DateFormat formatter = DateFormat('dd-MMM-yyyy', 'en_US');
    final String? formattedFrom =
        fromDate != null ? formatter.format(fromDate) : null;
    final String? formattedTo =
        toDate != null ? formatter.format(toDate) : null;
    final String? statusText = statusId != null ? statusId.toString() : null;

    final models = await _remoteDataSource.getUpcomingServices(
      userId: userId,
      fromDate: formattedFrom,
      toDate: formattedTo,
      statusId: statusText,
    );

    return List<UpcomingServiceEntity>.from(models);
  }

  @override
  Future<void> updateAppointmentStatus({
    required String bookingId,
    required String statusId,
  }) {
    return _remoteDataSource.updateAppointmentStatus(
      bookingId: bookingId,
      statusId: statusId,
    );
  }
}
