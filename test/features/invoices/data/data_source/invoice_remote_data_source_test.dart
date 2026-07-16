import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/core/utils/end_point.dart';
import 'package:newmotorlube/features/invoices/data/data_source/invoice_remote_data_source.dart';
import 'package:newmotorlube/features/invoices/domain/exception/invoice_exception.dart';

void main() {
  test('builds safe invoice document URLs', () {
    expect(
      invoiceDocumentUri('invoice 200.pdf').toString(),
      '$invoiceDocumentsBaseUrl/invoice%20200.pdf',
    );
    expect(
      invoiceDocumentUri('https://example.com/invoice.pdf').toString(),
      'https://example.com/invoice.pdf',
    );
  });

  test('requests customer invoices with the encoded Oracle party ID', () async {
    final dio = Dio();
    RequestOptions? capturedRequest;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          capturedRequest = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'statusInfo': {'infoCode': '0001'},
                'invoices': [
                  {
                    'srNumber': 'SR-1',
                    'trxNumber': 'INV-1',
                    'trxDate': '2026-07-15',
                    'totalAmount': 99.5,
                    'fileName': 'INV-1.pdf',
                  },
                ],
              },
            ),
          );
        },
      ),
    );
    final dataSource = InvoiceRemoteDataSource(dio);

    final invoices = await dataSource.getCustomerInvoices(
      oraclePartyId: 'party/id',
    );

    expect(capturedRequest?.method, 'GET');
    expect(
      capturedRequest?.uri.toString(),
      getCustomerInvoicesEndPoint('party/id'),
    );
    expect(invoices, hasLength(1));
    expect(invoices.single.invoiceNumber, 'INV-1');
  });

  test('turns a failed response status into an invoice exception', () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'statusInfo': {
                  'infoCode': '9999',
                  'infoDescriptionEN': 'Invoice service unavailable',
                },
                'invoices': <dynamic>[],
              },
            ),
          );
        },
      ),
    );
    final dataSource = InvoiceRemoteDataSource(dio);

    expect(
      () => dataSource.getCustomerInvoices(oraclePartyId: '123'),
      throwsA(
        isA<InvoiceException>().having(
          (error) => error.message,
          'message',
          'Invoice service unavailable',
        ),
      ),
    );
  });
}
