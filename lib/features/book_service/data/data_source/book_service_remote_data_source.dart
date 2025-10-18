import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../../domain/exception/service_packages_exception.dart';
import '../model/create_appointment_response_model.dart';
import '../model/service_package_model.dart';
import 'i_book_service_remote_data_source.dart';

class BookServiceRemoteDataSource implements IBookServiceRemoteDataSource {
  final Dio _dio;

  BookServiceRemoteDataSource(this._dio);

  @override
  Future<List<ServicePackageModel>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
  }) async {
    try {
      final response = await _dio.get(
        getPackagesForVehicleEndPoint(customerId, vehicleId),
      );
      final data = response.data;
      final List<dynamic> rawList = _extractPackages(data);
      return rawList
          .map(
            (item) => ServicePackageModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw ServicePackagesException.networkError();
      }

      if (error.response?.statusCode == 500) {
        throw ServicePackagesException.serverError();
      }

      final message =
          error.response?.statusMessage ??
          error.message ??
          'Failed to fetch service packages.';
      throw ServicePackagesException(message);
    } catch (_) {
      throw ServicePackagesException.unexpected();
    }
  }

  List<dynamic> _extractPackages(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      final possibleList = data['packages'] ?? data['items'] ?? data['data'];
      if (possibleList is List) {
        return possibleList;
      }
    }
    return const [];
  }

  @override
  Future<CreateAppointmentResponseModel> createAppointment({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _dio.post(
        createAppointmentEndPoint,
        data: payload,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return CreateAppointmentResponseModel.fromJson(data);
      }
      if (data is Map) {
        return CreateAppointmentResponseModel.fromJson(
          Map<String, dynamic>.from(data as Map),
        );
      }
      throw Exception('Invalid response format for create appointment.');
    } on DioException catch (error) {
      final responseData = error.response?.data;
      String? message;
      if (responseData is Map<String, dynamic>) {
        message =
            (responseData['infoDescriptionEn'] as String?) ??
            (responseData['infoDescription'] as String?) ??
            (responseData['infoType'] as String?) ??
            (responseData['message'] as String?);
      } else if (responseData is String) {
        message = responseData;
      }
      message ??= error.message;
      throw Exception(
        message ?? 'Failed to create appointment. Please try again.',
      );
    } catch (error) {
      throw Exception(
        error.toString().isNotEmpty
            ? error.toString()
            : 'Failed to create appointment. Please try again.',
      );
    }
  }
}
