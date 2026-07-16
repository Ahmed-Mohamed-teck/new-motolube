import '../../../../core/providers/push_notifications_service.dart';
import 'i_push_token_data_source.dart';

class PushTokenDataSourceImpl implements IPushTokenDataSource {
  const PushTokenDataSourceImpl(this._pushNotificationsService);

  final PushNotificationsService _pushNotificationsService;

  @override
  Future<String?> getToken() => _pushNotificationsService.getToken();

  @override
  Stream<String> get onTokenRefresh => _pushNotificationsService.onTokenRefresh;
}
