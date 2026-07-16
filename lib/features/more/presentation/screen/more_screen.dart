import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_locale_provider.dart';
import '../../../../core/utils/ui_components/shared_ui.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/domain/entity/user_type.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/provider/auth_provider.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final currentLocale = ref.watch(currentLocaleProvider);
    final authState = ref.watch(authViewModelProvider);
    final showInvoices =
        authState is AuthenticatedState &&
        authState.user.userType == UserType.customer;
    final languageLabel = currentLocale == 'en' ? s.english : s.arabic;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
          children: [
            if (showInvoices) ...[
              _SectionTitle(title: s.moreDocumentsSectionTitle),
              const SizedBox(height: 10),
              _MoreOptionCard(
                icon: Icons.receipt_long_rounded,
                accentColor: const Color(0xFF6C63FF),
                title: s.invoicesTitle,
                description: s.invoicesMenuDescription,
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('customerInvoicesScreen');
                },
              ),
            ],
            const SizedBox(height: 28),
            _SectionTitle(title: s.morePreferencesSectionTitle),
            const SizedBox(height: 10),
            _MoreOptionCard(
              icon: Icons.translate_rounded,
              accentColor: const Color(0xFFFFA000),
              title: s.changeLanguage,
              description: s.moreLanguageDescription,
              trailing: _LanguageBadge(label: languageLabel),
              onTap: () => buildShowLangBottomSheet(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: const Color(0xFF5F6068),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MoreOptionCard extends StatelessWidget {
  const _MoreOptionCard({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.description,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9E9ED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: accentColor, size: 27),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF777982),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageBadge extends StatelessWidget {
  const _LanguageBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA000).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF9A6200),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
