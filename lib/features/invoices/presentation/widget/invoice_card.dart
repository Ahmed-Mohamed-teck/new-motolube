import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entity/invoice_entity.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onOpenDocument,
  });

  final InvoiceEntity invoice;
  final VoidCallback onOpenDocument;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = invoice.transactionDate;
    final formattedDate =
        date == null
            ? s.invoiceValueUnavailable
            : MaterialLocalizations.of(context).formatMediumDate(date);
    final formattedAmount = NumberFormat.currency(
      locale: locale,
      symbol: s.invoiceCurrencySymbol,
      decimalDigits: 2,
    ).format(invoice.totalAmount);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.invoiceNumberLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _fallback(invoice.invoiceNumber, s),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _InvoiceValueRow(
              icon: Icons.build_circle_outlined,
              label: s.invoiceServiceRequestLabel,
              value: _fallback(invoice.serviceRequestNumber, s),
            ),
            const SizedBox(height: 12),
            _InvoiceValueRow(
              icon: Icons.calendar_today_outlined,
              label: s.invoiceDateLabel,
              value: formattedDate,
            ),
            const SizedBox(height: 12),
            _InvoiceValueRow(
              icon: Icons.payments_outlined,
              label: s.invoiceTotalLabel,
              value: formattedAmount,
              valueColor: theme.colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                onPressed: onOpenDocument,
                icon: const Icon(Icons.download_rounded),
                label: Text(s.invoiceOpenPdfButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fallback(String value, S s) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? s.invoiceValueUnavailable : trimmed;
  }
}

class _InvoiceValueRow extends StatelessWidget {
  const _InvoiceValueRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
