import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/end_point.dart';
import '../../../../core/widget/error_widget.dart';
import '../../../../core/widget/internal_app_bar.dart';
import '../../../../core/widget/login_prompt_card.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../domain/entity/invoice_entity.dart';
import '../../provider/invoice_provider.dart';
import '../view_model/invoices_state.dart';
import '../widget/invoice_card.dart';

class CustomerInvoicesScreen extends ConsumerStatefulWidget {
  const CustomerInvoicesScreen({super.key});

  @override
  ConsumerState<CustomerInvoicesScreen> createState() =>
      _CustomerInvoicesScreenState();
}

class _CustomerInvoicesScreenState
    extends ConsumerState<CustomerInvoicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadIfAuthenticated());
  }

  void _loadIfAuthenticated() {
    if (ref.read(authViewModelProvider) is AuthenticatedState) {
      ref.read(invoicesViewModelProvider.notifier).load();
    }
  }

  Future<void> _loadInvoices() {
    if (ref.read(authViewModelProvider) is! AuthenticatedState) {
      return Future.value();
    }
    return ref.read(invoicesViewModelProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next is UnauthenticatedState) {
        ref.invalidate(invoicesViewModelProvider);
      } else if (previous is! AuthenticatedState &&
          next is AuthenticatedState) {
        _loadIfAuthenticated();
      }
    });

    final s = S.of(context);
    final authState = ref.watch(authViewModelProvider);
    final invoicesState = ref.watch(invoicesViewModelProvider);

    return Scaffold(
      appBar: InternalAppBar(
        title: s.invoicesTitle,
        actions: [
          IconButton(
            onPressed: authState is AuthenticatedState ? _loadInvoices : null,
            tooltip: s.invoiceRefreshTooltip,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _buildBody(authState, invoicesState),
    );
  }

  Widget _buildBody(AuthState authState, InvoicesState invoicesState) {
    final s = S.of(context);
    if (authState is! AuthenticatedState) {
      return LoginPromptCard(
        message: s.invoicesSignInMessage,
        buttonText: s.login,
        centered: true,
        onLogin: () => navigatorKey.currentState?.pushNamed('loginScreen'),
      );
    }

    if (invoicesState is InvoicesInitial || invoicesState is InvoicesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (invoicesState is InvoicesLoaded) {
      return RefreshIndicator(
        onRefresh: _loadInvoices,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: invoicesState.invoices.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final invoice = invoicesState.invoices[index];
            return InvoiceCard(
              invoice: invoice,
              onOpenDocument: () => _openDocument(invoice),
            );
          },
        ),
      );
    }

    if (invoicesState is InvoicesEmpty) {
      return RefreshIndicator(
        onRefresh: _loadInvoices,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.58,
              child: _InvoicesEmptyState(onRefresh: _loadInvoices),
            ),
          ],
        ),
      );
    }

    if (invoicesState is InvoicesError) {
      return ErrorStateWidget(onRetry: _loadInvoices);
    }

    return const SizedBox.shrink();
  }

  Future<void> _openDocument(InvoiceEntity invoice) async {
    final s = S.of(context);
    if (!invoice.hasDocument) {
      _showMessage(s.invoiceFileUnavailableMessage);
      return;
    }

    try {
      final launched = await launchUrl(
        invoiceDocumentUri(invoice.documentFileName),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        _showMessage(s.invoiceOpenFailedMessage);
      }
    } catch (_) {
      if (mounted) _showMessage(s.invoiceOpenFailedMessage);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _InvoicesEmptyState extends StatelessWidget {
  const _InvoicesEmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            s.invoicesEmptyTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            s.invoicesEmptyDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(s.invoiceRefreshButton),
          ),
        ],
      ),
    );
  }
}
