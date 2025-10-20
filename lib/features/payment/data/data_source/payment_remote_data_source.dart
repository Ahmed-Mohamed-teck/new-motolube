import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/payment_initiation_request_model.dart';
import '../model/payment_initiation_response_model.dart';
import 'i_payment_remote_data_source.dart';

class PaymentRemoteDataSource implements IPaymentRemoteDataSource {
  PaymentRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<PaymentInitiationResponseModel> initiatePayment(
    PaymentInitiationRequestModel request,
  ) async {
    try {
      final response = await _dio.post(
        initiatePaymentEndPoint,
        data: request.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return PaymentInitiationResponseModel.fromJson(data);
      }
      if (data is Map) {
        return PaymentInitiationResponseModel.fromJson(
          Map<String, dynamic>.from(data as Map),
        );
      }
      throw const FormatException('Unexpected response format.');
    } on DioException catch (error) {
      final message =
          error.response?.data is Map<String, dynamic>
              ? (error.response!.data['message'] as String?) ??
                  (error.response!.data['error'] as String?)
              : error.message;
      throw Exception(
        message?.isNotEmpty == true
            ? message!
            : 'Failed to initiate payment. Please try again.',
      );
    }
  }
}
