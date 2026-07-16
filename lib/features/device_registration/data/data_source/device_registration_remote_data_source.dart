import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/device_registration_model.dart';
import 'i_device_registration_remote_data_source.dart';

class DeviceRegistrationRemoteDataSourceImpl
    implements IDeviceRegistrationRemoteDataSource {
  const DeviceRegistrationRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> registerDevice(DeviceRegistrationModel request) async {
    await _dio.post(registerDeviceEndPoint, data: request.toJson());
  }
}
