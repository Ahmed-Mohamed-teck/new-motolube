import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_locale_provider.dart';
import '../../../../core/utils/ui_components/shared_ui.dart';
import '../../../../generated/l10n.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(currentLocaleProvider);

    return Scaffold(
      body: ListView(
        children: [
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
