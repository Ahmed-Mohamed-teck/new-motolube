import '../entity/invoice_entity.dart';
import '../repository/i_invoice_repository.dart';

class GetCustomerInvoicesUseCase {
  const GetCustomerInvoicesUseCase(this._repository);

  final IInvoiceRepository _repository;

  Future<List<InvoiceEntity>> call() async {
    final invoices = await _repository.getCustomerInvoices();
    final sortedInvoices = List<InvoiceEntity>.of(invoices);
    sortedInvoices.sort((first, second) {
      final firstDate = first.transactionDate;
      final secondDate = second.transactionDate;
      if (firstDate == null && secondDate == null) return 0;
      if (firstDate == null) return 1;
      if (secondDate == null) return -1;
      return secondDate.compareTo(firstDate);
    });
    return sortedInvoices;
  }
}
