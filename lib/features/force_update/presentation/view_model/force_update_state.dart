import '../../domain/entity/force_update_result.dart';

sealed class ForceUpdateState {
  const ForceUpdateState();
}

class ForceUpdateInitial extends ForceUpdateState {
  const ForceUpdateInitial();
}

class ForceUpdateChecking extends ForceUpdateState {
  const ForceUpdateChecking();
}

class ForceUpdateAvailable extends ForceUpdateState {
  const ForceUpdateAvailable(this.result);

  final ForceUpdateRequired result;
}

class ForceUpdateUnavailable extends ForceUpdateState {
  const ForceUpdateUnavailable();
}

class ForceUpdateFailure extends ForceUpdateState {
  const ForceUpdateFailure(this.message);

  final String message;
}
