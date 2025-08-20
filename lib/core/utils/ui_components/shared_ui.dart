import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/current_locale_provider.dart';

Future<dynamic> buildShowLangBottomSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.ltr, // Set the desired text direction
        child: Consumer(
          builder: (context, ref, child) {
            final appLang = ref.watch(currentLocaleProvider);
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      ref.read(currentLocaleProvider.notifier).updateLocale('ar');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(
                        color: appLang == 'ar' ? Colors.orange : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('العربية'),
                          Image.asset(
                            'assets/images/saudi-arabia-flag-icon.png',
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      ref.read(currentLocaleProvider.notifier).updateLocale('en');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(
                        color: appLang == 'en' ? Colors.orange : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('English'),
                          Image.asset(
                            'assets/images/united-kingdom-flag-icon.png',
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
