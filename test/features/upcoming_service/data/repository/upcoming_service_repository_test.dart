import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:newmotorlube/features/auth/domain/entity/auth_session.dart';
import 'package:newmotorlube/features/auth/domain/entity/stored_auth.dart';
import 'package:newmotorlube/features/auth/domain/entity/user_type.dart';
import 'package:newmotorlube/features/auth/domain/repository/i_auth_local_repository.dart';
import 'package:newmotorlube/features/upcoming_service/data/data_source/i_upcoming_service_remote_data_source.dart';
import 'package:newmotorlube/features/upcoming_service/data/model/upcoming_service_model.dart';
import 'package:newmotorlube/features/upcoming_service/data/repository/upcoming_service_repository.dart';

void main() {
  tearDown(() {
    Intl.defaultLocale = null;
  });

  test('formats filter dates in English for API query params', () async {
    Intl.defaultLocale = 'ar';
    final remote = _FakeUpcomingServiceRemoteDataSource();
    final auth = _FakeAuthLocalRepository(
      const StoredAuth(
        jwtToken: 'token',
        firebaseToken: 'firebase-token',
        fireBaseId: 'firebase-id',
        phoneNumber: '0500000000',
        oracleId: '12345',
        userType: UserType.customer,
      ),
    );
    final repository = UpcomingServiceRepository(remote, auth);

    await repository.getUpcomingServices(
      fromDate: DateTime(2026, 6),
      toDate: DateTime(2026, 6, 30),
      statusId: 7,
    );

    expect(remote.userId, '12345');
    expect(remote.fromDate, '01-Jun-2026');
    expect(remote.toDate, '30-Jun-2026');
    expect(remote.statusId, '7');
  });
}

class _FakeUpcomingServiceRemoteDataSource
    implements IUpcomingServiceRemoteDataSource {
  String? userId;
  String? fromDate;
  String? toDate;
  String? statusId;

  @override
  Future<List<UpcomingServiceModel>> getUpcomingServices({
    required String userId,
    String? fromDate,
    String? toDate,
    String? statusId,
  }) async {
    this.userId = userId;
    this.fromDate = fromDate;
    this.toDate = toDate;
    this.statusId = statusId;
    return const <UpcomingServiceModel>[];
  }

  @override
  Future<void> updateAppointmentStatus({
    required String bookingId,
    required String statusId,
  }) async {}
}

class _FakeAuthLocalRepository implements IAuthLocalRepository {
  _FakeAuthLocalRepository(this._storedAuth);

  final StoredAuth? _storedAuth;

  @override
  Future<void> clear() async {}

  @override
  Future<StoredAuth?> getStoredAuth() async => _storedAuth;

  @override
  Future<void> saveAuthSession(AuthSession session) async {}
}
