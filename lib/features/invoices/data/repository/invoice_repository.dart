import '../../../auth/domain/repository/i_auth_local_repository.dart';
import '../../domain/entity/invoice_entity.dart';
import '../../domain/repository/i_invoice_repository.dart';
import '../data_source/i_invoice_remote_data_source.dart';

class InvoiceRepository implements IInvoiceRepository {
  const InvoiceRepository(this._remoteDataSource, this._authLocalRepository);

  final IInvoiceRemoteDataSource _remoteDataSource;
  final IAuthLocalRepository _authLocalRepository;

  @override
  Future<List<InvoiceEntity>> getCustomerInvoices() async {
    String oraclePartyId;
    try {
      final storedAuth = await _authLocalRepository.getStoredAuth();
      oraclePartyId = storedAuth?.oracleId.trim() ?? '';
    } catch (_) {
      return const <InvoiceEntity>[];
    }

    if (oraclePartyId.isEmpty) return const <InvoiceEntity>[];
    final models = await _remoteDataSource.getCustomerInvoices(
      oraclePartyId: oraclePartyId,
    );
    return List<InvoiceEntity>.from(models);
  }
}
