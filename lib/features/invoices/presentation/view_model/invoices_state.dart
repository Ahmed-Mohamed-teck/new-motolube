import '../../domain/entity/invoice_entity.dart';

sealed class InvoicesState {
  const InvoicesState();
}

class InvoicesInitial extends InvoicesState {
  const InvoicesInitial();
}

class InvoicesLoading extends InvoicesState {
  const InvoicesLoading();
}

class InvoicesLoaded extends InvoicesState {
  const InvoicesLoaded(this.invoices);

  final List<InvoiceEntity> invoices;
}

class InvoicesEmpty extends InvoicesState {
  const InvoicesEmpty();
}

class InvoicesError extends InvoicesState {
  const InvoicesError(this.message);

  final String message;
}
