import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/invoices/data/model/invoice_model.dart';

void main() {
  test('maps the legacy invoice payload to domain-friendly fields', () {
    final invoice = InvoiceModel.fromJson({
      'ln': 1,
      'srNumber': 'SR-100',
      'customerTrxId': 'TRX-ID',
      'trxNumber': 'INV-200',
      'trxDate': '2026-07-15T10:30:00',
      'trxClass': 'INV',
      'soldToCustomerId': 'CUSTOMER-1',
      'userName': 'Customer',
      'totalAmount': '1,250.75',
      'paymentId': 'PAY-300',
      'fileName': 'invoice 200.pdf',
    });

    expect(invoice.lineNumber, '1');
    expect(invoice.serviceRequestNumber, 'SR-100');
    expect(invoice.customerTransactionId, 'TRX-ID');
    expect(invoice.invoiceNumber, 'INV-200');
    expect(invoice.transactionDate, DateTime(2026, 7, 15, 10, 30));
    expect(invoice.totalAmount, 1250.75);
    expect(invoice.documentFileName, 'invoice 200.pdf');
    expect(invoice.hasDocument, isTrue);
  });

  test('uses safe defaults for optional or malformed values', () {
    final invoice = InvoiceModel.fromJson({
      'trxDate': 'not-a-date',
      'totalAmount': 'not-a-number',
    });

    expect(invoice.invoiceNumber, isEmpty);
    expect(invoice.transactionDate, isNull);
    expect(invoice.totalAmount, 0);
    expect(invoice.hasDocument, isFalse);
  });
}
