import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/invoices/domain/entity/invoice_entity.dart';
import 'package:newmotorlube/features/invoices/domain/repository/i_invoice_repository.dart';
import 'package:newmotorlube/features/invoices/domain/use_case/get_customer_invoices_use_case.dart';

void main() {
  test('sorts invoices newest first and leaves missing dates last', () async {
    final useCase = GetCustomerInvoicesUseCase(
      _FakeInvoiceRepository([
        const InvoiceEntity(invoiceNumber: 'old', transactionDate: null),
        InvoiceEntity(
          invoiceNumber: 'middle',
          transactionDate: DateTime(2026, 6),
        ),
        InvoiceEntity(
          invoiceNumber: 'newest',
          transactionDate: DateTime(2026, 7),
        ),
      ]),
    );

    final result = await useCase();

    expect(result.map((invoice) => invoice.invoiceNumber), [
      'newest',
      'middle',
      'old',
    ]);
  });
}

class _FakeInvoiceRepository implements IInvoiceRepository {
  const _FakeInvoiceRepository(this.invoices);

  final List<InvoiceEntity> invoices;

  @override
  Future<List<InvoiceEntity>> getCustomerInvoices() async => invoices;
}
