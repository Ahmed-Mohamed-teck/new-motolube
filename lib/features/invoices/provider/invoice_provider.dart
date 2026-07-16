import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../data/data_source/i_invoice_remote_data_source.dart';
import '../data/data_source/invoice_remote_data_source.dart';
import '../data/repository/invoice_repository.dart';
import '../domain/repository/i_invoice_repository.dart';
import '../domain/use_case/get_customer_invoices_use_case.dart';
import '../presentation/view_model/invoices_state.dart';
import '../presentation/view_model/invoices_view_model.dart';

final invoiceRemoteDataSourceProvider = Provider<IInvoiceRemoteDataSource>((
  ref,
) {
  return InvoiceRemoteDataSource(ref.read(dioProvider));
});

final invoiceRepositoryProvider = Provider<IInvoiceRepository>((ref) {
  return InvoiceRepository(
    ref.read(invoiceRemoteDataSourceProvider),
    ref.read(authLocalRepositoryProvider),
  );
});

final getCustomerInvoicesUseCaseProvider = Provider<GetCustomerInvoicesUseCase>(
  (ref) {
    return GetCustomerInvoicesUseCase(ref.read(invoiceRepositoryProvider));
  },
);

final invoicesViewModelProvider =
    StateNotifierProvider.autoDispose<InvoicesViewModel, InvoicesState>((ref) {
      return InvoicesViewModel(ref.read(getCustomerInvoicesUseCaseProvider));
    });
