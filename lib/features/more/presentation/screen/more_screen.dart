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
    final currentLocale = ref.watch(currentLocaleProvider);
    final authState = ref.watch(authViewModelProvider);
    final showInvoices =
        authState is AuthenticatedState &&
        authState.user.userType == UserType.customer;

    return Scaffold(
      body: ListView(
        children: [
          if (showInvoices)
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(S.of(context).invoicesTitle),
              subtitle: Text(S.of(context).invoicesMenuDescription),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed('customerInvoicesScreen');
              },
            ),
          ListTile(
            title: Text(S.of(context).changeLanguage),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLocale == 'en'
                      ? S.of(context).english
                      : S.of(context).arabic,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap: () => buildShowLangBottomSheet(context, ref),
          ),
        ],
      ),
    );
  }
}
