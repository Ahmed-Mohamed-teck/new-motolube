import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/force_update_result.dart';
import '../../domain/use_case/check_force_update_use_case.dart';
import '../../provider/force_update_provider.dart';
import 'force_update_state.dart';

class ForceUpdateViewModel extends Notifier<ForceUpdateState> {
  late final CheckForceUpdateUseCase _checkForceUpdateUseCase;
  bool _hasChecked = false;

  @override
  ForceUpdateState build() {
    _checkForceUpdateUseCase = ref.read(checkForceUpdateUseCaseProvider);
    return const ForceUpdateInitial();
  }

  Future<void> check({bool force = false}) async {
    if (_hasChecked && !force) return;
    _hasChecked = true;

    state = const ForceUpdateChecking();
    try {
      final result = await _checkForceUpdateUseCase();
      state = switch (result) {
        ForceUpdateRequired() => ForceUpdateAvailable(result),
        ForceUpdateNotRequired() => const ForceUpdateUnavailable(),
      };
    } catch (error) {
      state = ForceUpdateFailure(error.toString());
    }
  }
}
