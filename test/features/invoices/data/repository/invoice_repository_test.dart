import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/auth/domain/entity/auth_session.dart';
import 'package:newmotorlube/features/auth/domain/entity/stored_auth.dart';
import 'package:newmotorlube/features/auth/domain/entity/user_type.dart';
import 'package:newmotorlube/features/auth/domain/repository/i_auth_local_repository.dart';
import 'package:newmotorlube/features/invoices/data/data_source/i_invoice_remote_data_source.dart';
import 'package:newmotorlube/features/invoices/data/model/invoice_model.dart';
import 'package:newmotorlube/features/invoices/data/repository/invoice_repository.dart';

void main() {
  test('uses the stored Oracle ID to request invoices', () async {
    final remote = _FakeInvoiceRemoteDataSource();
    final auth = _FakeAuthLocalRepository(_storedAuth(' 761369 '));
    final repository = InvoiceRepository(remote, auth);

    await repository.getCustomerInvoices();

    expect(remote.oraclePartyId, '761369');
    expect(remote.callCount, 1);
  });

  test('does not call the API when the stored Oracle ID is missing', () async {
    final remote = _FakeInvoiceRemoteDataSource();
    final auth = _FakeAuthLocalRepository(_storedAuth(''));
    final repository = InvoiceRepository(remote, auth);

    final result = await repository.getCustomerInvoices();

    expect(result, isEmpty);
    expect(remote.callCount, 0);
  });
}

StoredAuth _storedAuth(String oracleId) {
  return StoredAuth(
    jwtToken: 'token',
    firebaseToken: 'firebase-token',
    fireBaseId: 'firebase-id',
    phoneNumber: '0500000000',
    oracleId: oracleId,
    userType: UserType.customer,
  );
}

class _FakeInvoiceRemoteDataSource implements IInvoiceRemoteDataSource {
  int callCount = 0;
  String? oraclePartyId;

  @override
  Future<List<InvoiceModel>> getCustomerInvoices({
    required String oraclePartyId,
  }) async {
    callCount++;
    this.oraclePartyId = oraclePartyId;
    return const <InvoiceModel>[];
  }
}

class _FakeAuthLocalRepository implements IAuthLocalRepository {
  _FakeAuthLocalRepository(this.storedAuth);

  final StoredAuth? storedAuth;

  @override
  Future<void> clear() async {}

  @override
  Future<StoredAuth?> getStoredAuth() async => storedAuth;

  @override
  Future<void> saveAuthSession(AuthSession session) async {}
}
