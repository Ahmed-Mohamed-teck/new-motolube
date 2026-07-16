class InvoiceException implements Exception {
  const InvoiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
