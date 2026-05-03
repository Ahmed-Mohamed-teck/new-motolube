import '../entity/force_update_result.dart';

abstract class IForceUpdateRepository {
  Future<ForceUpdateResult> checkForUpdate();
}
