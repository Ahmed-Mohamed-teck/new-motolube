import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';

final localizationProvider = Provider((ref) => S());

final container = ProviderContainer();

final S appLang = container.read(localizationProvider);