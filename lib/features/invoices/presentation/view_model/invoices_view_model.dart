import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/get_customer_invoices_use_case.dart';
import 'invoices_state.dart';

class InvoicesViewModel extends StateNotifier<InvoicesState> {
  InvoicesViewModel(this._getCustomerInvoicesUseCase)
    : super(const InvoicesInitial());

  final GetCustomerInvoicesUseCase _getCustomerInvoicesUseCase;

  Future<void> load() async {
    if (state is InvoicesLoading) return;
    state = const InvoicesLoading();
    try {
      final invoices = await _getCustomerInvoicesUseCase();
      state =
          invoices.isEmpty ? const InvoicesEmpty() : InvoicesLoaded(invoices);
    } catch (error) {
      state = InvoicesError(error.toString());
    }
  }
}
