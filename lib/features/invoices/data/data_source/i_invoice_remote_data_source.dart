import '../model/invoice_model.dart';

abstract class IInvoiceRemoteDataSource {
  Future<List<InvoiceModel>> getCustomerInvoices({
    required String oraclePartyId,
  });
}
