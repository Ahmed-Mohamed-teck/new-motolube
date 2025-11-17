import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/job_card_model.dart';
import '../model/job_card_package_model.dart';
import '../model/technician_appointment_model.dart';
import '../model/technician_booking_status_model.dart';
import '../model/technician_slot_model.dart';
import '../model/technician_summary_model.dart';
import 'i_technician_remote_data_source.dart';

class TechnicianRemoteDataSource implements ITechnicianRemoteDataSource {
  TechnicianRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<TechnicianSummaryModel>> searchNearby({
    required double latitude,
    required double longitude,
    required int maxResults,
    required double radiusKm,
    required String serviceId,
  }) async {
    try {
      final response = await _dio.get(
        searchNearbyTechniciansEndPoint,
        queryParameters: <String, dynamic>{
          'Latitude': latitude.toStringAsFixed(6),
          'Longitude': longitude.toStringAsFixed(6),
          'MaxResults': maxResults.toString(),
          'RadiusKm': radiusKm.toStringAsFixed(2),
          'ServiceId': serviceId,
        },
      );

      final data = response.data;
      final List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        final maybeList =
            data['data'] ??
            data['technicians'] ??
            data['items'] ??
            data['result'] ??
            data['results'];
        if (maybeList is List) {
          rawList = maybeList;
        } else {
          rawList = [data];
        }
      } else {
        rawList = const [];
      }

      return rawList
          .map((raw) {
            if (raw is Map<String, dynamic>) {
              return TechnicianSummaryModel.fromJson(raw);
            }
            if (raw is Map) {
              return TechnicianSummaryModel.fromJson(
                raw.map((key, value) => MapEntry(key.toString(), value)),
              );
            }
            return null;
          })
          .whereType<TechnicianSummaryModel>()
          .toList();
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const <TechnicianSummaryModel>[];
      }
      rethrow;
    }
  }

  @override
  Future<List<TechnicianSlotModel>> getAvailableSlots({
    required String technicianId,
    required String date,
  }) async {
    try {
      final response = await _dio.get(
        getTechnicianAvailableSlotsEndPoint,
        queryParameters: <String, dynamic>{
          'TechnicianId': technicianId,
          'Date': date,
        },
      );

      final data = response.data;
      final List<dynamic> rawList;

      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        final maybeList =
            data['data'] ??
            data['slots'] ??
            data['items'] ??
            data['result'] ??
            data['results'] ??
            data['availableSlots'];
        if (maybeList is List) {
          rawList = maybeList;
        } else if (maybeList is Map<String, dynamic>) {
          rawList = maybeList.values.toList();
        } else {
          rawList = [data];
        }
      } else {
        rawList = const [];
      }

      return rawList
          .map((raw) => TechnicianSlotModel.fromDynamic(raw))
          .toList();
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const <TechnicianSlotModel>[];
      }
      rethrow;
    }
  }

  @override
  Future<List<TechnicianAppointmentModel>> getAppointments({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  }) async {
    try {
      final response = await _dio.get(
        getTechnicianAppointmentsEndPoint,
        queryParameters: <String, dynamic>{
          'UserId': userId,
          'FromDate': fromDate,
          'ToDate': toDate,
          'Status_Id': statusId,
        },
      );

      final data = response.data;
      final List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        final maybeList =
            data['data'] ??
            data['result'] ??
            data['appointments'] ??
            data['items'] ??
            data['Data'];
        if (maybeList is List) {
          rawList = maybeList;
        } else if (maybeList is Map) {
          rawList = maybeList.values.toList();
        } else {
          rawList = const [];
        }
      } else {
        rawList = const [];
      }

      return rawList
          .map((raw) {
            if (raw is Map<String, dynamic>) {
              return raw;
            }
            if (raw is Map) {
              return Map<String, dynamic>.from(
                raw.map((key, value) => MapEntry(key.toString(), value)),
              );
            }
            return null;
          })
          .whereType<Map<String, dynamic>>()
          .map(TechnicianAppointmentModel.fromJson)
          .toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch technician appointments [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<List<TechnicianBookingStatusModel>> getBookingStatuses() async {
    try {
      final response = await _dio.get(getBookingStatusesEndPoint);
      final data = response.data;
      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        final maybeList =
            data['responseData'] ??
            data['data'] ??
            data['items'] ??
            data['result'];
        if (maybeList is List) {
          rawList = maybeList;
        } else if (maybeList is Map) {
          rawList = maybeList.values.toList();
        } else {
          rawList = const [];
        }
      } else {
        rawList = const [];
      }

      return rawList
          .map((raw) {
            if (raw is Map<String, dynamic>) {
              return TechnicianBookingStatusModel.fromJson(raw);
            }
            if (raw is Map) {
              return TechnicianBookingStatusModel.fromJson(
                raw.map((key, value) => MapEntry(key.toString(), value)),
              );
            }
            return null;
          })
          .whereType<TechnicianBookingStatusModel>()
          .toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch booking statuses [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<void> updateAppointmentStatus({
    required String bookingId,
    required String statusId,
  }) async {
    try {
      await _dio.post(
        updateAppointmentStatusEndPoint,
        data: <String, dynamic>{'bookingId': bookingId, 'status_Id': statusId},
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to update appointment status [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<List<JobCardModel>> createServiceRequest({
    required String fireBaseId,
    required String phoneNumber,
    required String vin,
    required String mileage,
    required String couponNumber,
    required String isEstimation,
    required String bookingId,
  }) async {
    final encodedSegments =
        [
              fireBaseId,
              phoneNumber,
              vin,
              mileage,
              couponNumber,
              isEstimation,
              bookingId,
            ]
            .map(
              (segment) =>
                  Uri.encodeComponent(segment.isEmpty ? 'NA' : segment),
            )
            .toList();

    final url =
        '${createServiceRequestBaseEndPoint}/${encodedSegments.join('/')}';

    try {
      final response = await _dio.get(url);
      final data = response.data;
      final List<dynamic> rawList;
      Map<String, dynamic>? statusInfo;
      if (data is Map<String, dynamic>) {
        final jobCards = data['jobCards'];
        if (jobCards is List) {
          rawList = jobCards;
        } else if (jobCards is Map) {
          rawList = jobCards.values.toList();
        } else {
          rawList = const [];
        }
        final possibleStatus =
            data['statusInfo'] ?? data['status'] ?? data['StatusInfo'];
        if (possibleStatus is Map<String, dynamic>) {
          statusInfo = possibleStatus;
        }
      } else if (data is List) {
        rawList = data;
      } else {
        rawList = const [];
      }

      final infoCode =
          statusInfo != null
              ? (statusInfo['infoCode'] ?? '').toString().trim()
              : '0001';
      final infoType = (statusInfo?['infoType'] ?? '').toString().toLowerCase();
      final infoMessage =
          (statusInfo?['infoDescriptionEN'] ??
                  statusInfo?['infoDescription'] ??
                  statusInfo?['infoDescriptionAR'] ??
                  '')
              .toString()
              .trim();
      final success = infoCode == '0001' || infoType.contains('success');
      if (!success) {
        final message =
            infoMessage.isNotEmpty
                ? infoMessage
                : 'Failed to create service request';
        throw Exception(message);
      }

      return rawList
          .map((raw) {
            if (raw is Map<String, dynamic>) {
              return JobCardModel.fromJson(raw);
            }
            if (raw is Map) {
              return JobCardModel.fromJson(
                raw.map((key, value) => MapEntry(key.toString(), value)),
              );
            }
            return null;
          })
          .whereType<JobCardModel>()
          .toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to create service request [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<List<JobCardPackageModel>> getJobCardPackages({
    required String srNumber,
  }) async {
    if (srNumber.trim().isEmpty) return const <JobCardPackageModel>[];
    try {
      final response = await _dio.get(getPackagesBySrEndPoint(srNumber));
      final data = response.data;
      List<dynamic> rawList = const [];
      Map<String, dynamic>? statusInfo;
      if (data is Map<String, dynamic>) {
        final maybeList = data['packages'] ?? data['items'] ?? data['data'];
        if (maybeList is List) {
          rawList = maybeList;
        } else if (maybeList is Map) {
          rawList = maybeList.values.toList();
        }
        final info = data['statusInfo'] ?? data['status'] ?? data['StatusInfo'];
        if (info is Map<String, dynamic>) {
          statusInfo = Map<String, dynamic>.from(info);
        }
      } else if (data is List) {
        rawList = data;
      }

      final packages =
          rawList
              .map((raw) {
                if (raw is Map<String, dynamic>) return raw;
                if (raw is Map) {
                  return raw.map(
                    (key, value) => MapEntry(key.toString(), value),
                  );
                }
                return null;
              })
              .whereType<Map<String, dynamic>>()
              .map(JobCardPackageModel.fromJson)
              .toList();

      final infoCode =
          statusInfo != null ? (statusInfo['infoCode'] ?? '').toString() : '';
      final infoType =
          statusInfo != null
              ? (statusInfo['infoType'] ?? '').toString().toLowerCase()
              : '';
      final infoDescription =
          (statusInfo?['infoDescriptionEN'] ??
                  statusInfo?['infoDescription'] ??
                  statusInfo?['infoDescriptionAR'] ??
                  '')
              .toString()
              .trim();
      final success =
          infoCode == '0001' ||
          infoType.contains('success') ||
          infoDescription.toLowerCase().contains('success');

      if (!success && packages.isEmpty) {
        final message =
            infoDescription.isNotEmpty
                ? infoDescription
                : 'Failed to fetch job card packages.';
        throw Exception(message);
      }

      return packages;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch job card packages [code: $statusCode]: $message',
      );
    }
  }
}
