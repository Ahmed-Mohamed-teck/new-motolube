import '../../domain/entity/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    super.lineNumber,
    super.serviceRequestNumber,
    super.customerTransactionId,
    super.invoiceNumber,
    super.transactionDate,
    super.transactionClass,
    super.soldToCustomerId,
    super.userName,
    super.totalAmount,
    super.paymentId,
    super.documentFileName,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      lineNumber: _stringFor(json, const ['ln', 'lineNumber']),
      serviceRequestNumber: _stringFor(json, const [
        'srNumber',
        'sr_number',
        'jobCardNumber',
      ]),
      customerTransactionId: _stringFor(json, const [
        'customerTrxId',
        'customer_trx_id',
      ]),
      invoiceNumber: _stringFor(json, const [
        'trxNumber',
        'trx_number',
        'invoiceNumber',
      ]),
      transactionDate: _dateFor(json, const [
        'trxDate',
        'trx_date',
        'transactionDate',
      ]),
      transactionClass: _stringFor(json, const ['trxClass', 'trx_class']),
      soldToCustomerId: _stringFor(json, const [
        'soldToCustomerId',
        'sold_to_customer_id',
      ]),
      userName: _stringFor(json, const ['userName', 'user_name']),
      totalAmount: _doubleFor(
        _valueFor(json, const ['totalAmount', 'total_amount']),
      ),
      paymentId: _stringFor(json, const ['paymentId', 'payment_id']),
      documentFileName: _stringFor(json, const [
        'fileName',
        'file_name',
        'documentFileName',
      ]),
    );
  }
}

dynamic _valueFor(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key)) return json[key];
  }
  return null;
}

String _stringFor(Map<String, dynamic> json, List<String> keys) {
  final value = _valueFor(json, keys);
  return value?.toString().trim() ?? '';
}

DateTime? _dateFor(Map<String, dynamic> json, List<String> keys) {
  final value = _valueFor(json, keys);
  if (value is DateTime) return value;
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : DateTime.tryParse(text);
}

double _doubleFor(dynamic value) {
  if (value is num) return value.toDouble();
  final normalized = value?.toString().replaceAll(',', '').trim() ?? '';
  return double.tryParse(normalized) ?? 0;
}
