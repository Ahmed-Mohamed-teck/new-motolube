import '../entity/invoice_entity.dart';

abstract class IInvoiceRepository {
  Future<List<InvoiceEntity>> getCustomerInvoices();
}
