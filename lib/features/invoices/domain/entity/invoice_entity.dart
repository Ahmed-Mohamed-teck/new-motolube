class InvoiceEntity {
  const InvoiceEntity({
    this.lineNumber = '',
    this.serviceRequestNumber = '',
    this.customerTransactionId = '',
    this.invoiceNumber = '',
    this.transactionDate,
    this.transactionClass = '',
    this.soldToCustomerId = '',
    this.userName = '',
    this.totalAmount = 0,
    this.paymentId = '',
    this.documentFileName = '',
  });

  final String lineNumber;
  final String serviceRequestNumber;
  final String customerTransactionId;
  final String invoiceNumber;
  final DateTime? transactionDate;
  final String transactionClass;
  final String soldToCustomerId;
  final String userName;
  final double totalAmount;
  final String paymentId;
  final String documentFileName;

  bool get hasDocument => documentFileName.trim().isNotEmpty;
}
