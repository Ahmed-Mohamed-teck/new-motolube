import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/general_providers.dart';

class CurrentLocaleProvider extends StateNotifier<String> {
  CurrentLocaleProvider() : super('en'); // Default locale

  Future<void> init() async {
    final savedLocale = appPrefsWithCache.getString('currentLocale') ?? 'en';
    state = savedLocale;
  }

  Future<void> updateLocale(String newLocale) async {
    await appPrefsWithCache.setString('currentLocale', newLocale);
    state = newLocale;
  }
}

final currentLocaleProvider =
StateNotifierProvider<CurrentLocaleProvider, String>((ref) {
  final notifier = CurrentLocaleProvider();
  notifier.init(); // Initialize locale from SharedPreferences
  return notifier;
});