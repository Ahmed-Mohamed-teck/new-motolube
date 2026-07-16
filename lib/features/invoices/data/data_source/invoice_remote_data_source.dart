import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../../domain/exception/invoice_exception.dart';
import '../model/invoice_model.dart';
import 'i_invoice_remote_data_source.dart';

class InvoiceRemoteDataSource implements IInvoiceRemoteDataSource {
  const InvoiceRemoteDataSource(this._dio);

  static const _successCode = '0001';

  final Dio _dio;

  @override
  Future<List<InvoiceModel>> getCustomerInvoices({
    required String oraclePartyId,
  }) async {
    final response = await _dio.get(getCustomerInvoicesEndPoint(oraclePartyId));
    return _parseInvoices(response.data);
  }

  List<InvoiceModel> _parseInvoices(dynamic data) {
    if (data is List) return _modelsFrom(data);
    if (data is! Map) {
      throw const InvoiceException('Unexpected invoices response.');
    }

    final body = Map<String, dynamic>.from(data);
    _validateStatus(body['statusInfo'] ?? body['StatusInfo']);

    dynamic rawInvoices = body['invoices'] ?? body['Invoices'];
    final nestedData = body['data'] ?? body['Data'];
    if (rawInvoices == null && nestedData is Map) {
      rawInvoices = nestedData['invoices'] ?? nestedData['Invoices'];
    } else if (rawInvoices == null && nestedData is List) {
      rawInvoices = nestedData;
    }

    if (rawInvoices == null) return const <InvoiceModel>[];
    if (rawInvoices is! List) {
      throw const InvoiceException('Unexpected invoices list.');
    }
    return _modelsFrom(rawInvoices);
  }

  void _validateStatus(dynamic rawStatus) {
    if (rawStatus is! Map) return;
    final status = Map<String, dynamic>.from(rawStatus);
    final code =
        (status['infoCode'] ?? status['InfoCode'])?.toString().trim() ?? '';
    if (code.isEmpty || code == _successCode) return;

    final description =
        (status['infoDescriptionEN'] ??
                status['InfoDescriptionEN'] ??
                status['description'])
            ?.toString()
            .trim();
    throw InvoiceException(
      description == null || description.isEmpty
          ? 'Unable to load invoices.'
          : description,
    );
  }

  List<InvoiceModel> _modelsFrom(List<dynamic> rawInvoices) {
    return rawInvoices
        .whereType<Map>()
        .map((item) => InvoiceModel.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }
}
