import 'package:dio/dio.dart';

import '../../../../core/utils/end_point.dart';
import '../model/custom_package_category_model.dart';
import '../model/custom_package_item_model.dart';
import '../model/job_card_model.dart';
import '../model/job_card_package_line_model.dart';
import '../model/job_card_package_model.dart';
import '../model/operation_result_model.dart';
import '../model/status_info_model.dart';
import '../model/technician_appointment_model.dart';
import '../model/technician_booking_status_model.dart';
import '../model/technician_slot_model.dart';
import '../model/technician_summary_model.dart';
import 'i_technician_remote_data_source.dart';

class TechnicianRemoteDataSource implements ITechnicianRemoteDataSource {
  TechnicianRemoteDataSource(this._dio);

  final Dio _dio;

  String _buildLegacyMotorLubeUrl(
    String functionName, [
    List<String> parameters = const <String>[],
  ]) {
    final buffer = StringBuffer(
      '$baseUrl/MotorLubeApp/$functionName',
    );
    if (parameters.isNotEmpty) {
      final encodedSegments = parameters
          .map((segment) => Uri.encodeComponent(segment))
          .toList();
      buffer.write('/');
      buffer.write(encodedSegments.join('/'));
    }
    return buffer.toString();
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  List<Map<String, dynamic>> _asMapList(dynamic data) {
    if (data is List) {
      return data
          .map(_asMap)
          .whereType<Map<String, dynamic>>()
          .toList();
    }
    if (data is Map) {
      return data.values
          .map(_asMap)
          .whereType<Map<String, dynamic>>()
          .toList();
    }
    return const [];
  }

  StatusInfoModel _statusInfoFrom(Map<String, dynamic>? data) {
    if (data == null) return const StatusInfoModel(code: '', type: '', description: '');
    return StatusInfoModel.fromDynamic(data);
  }

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

  @override
  Future<List<JobCardPackageModel>> getPackagesOfJobCard({
    required String srNumber,
  }) async {
    final trimmed = srNumber.trim();
    if (trimmed.isEmpty) return const <JobCardPackageModel>[];
    try {
      final url = _buildLegacyMotorLubeUrl('getPackagesOfJobCard', [trimmed]);
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data);
      if (dataMap == null) return const <JobCardPackageModel>[];
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      if (!statusInfo.isSuccess) {
        final message =
            statusInfo.description.trim().isNotEmpty
                ? statusInfo.description.trim()
                : 'Failed to fetch job card packages.';
        throw Exception(message);
      }
      final rawList = _asMapList(
        dataMap['packages'] ?? dataMap['items'] ?? dataMap['data'],
      );
      return rawList.map(JobCardPackageModel.fromJson).toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch SR packages [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<List<JobCardPackageLineModel>> getJobCardPackageLines({
    required String srNumber,
    String? packageId,
  }) async {
    final trimmedSr = srNumber.trim();
    if (trimmedSr.isEmpty) return const <JobCardPackageLineModel>[];
    final params = <String>[trimmedSr];
    final pkgId = packageId?.trim();
    if (pkgId != null && pkgId.isNotEmpty && pkgId != '0') {
      params.add(pkgId);
    }
    try {
      final url = _buildLegacyMotorLubeUrl('getPackagesLinesOfSR', params);
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data);
      if (dataMap == null) return const <JobCardPackageLineModel>[];
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      if (!statusInfo.isSuccess) {
        final message =
            statusInfo.description.trim().isNotEmpty
                ? statusInfo.description.trim()
                : 'Failed to fetch package lines.';
        throw Exception(message);
      }
      final rawList = _asMapList(
        dataMap['packageLines'] ?? dataMap['items'] ?? dataMap['data'],
      );
      return rawList.map(JobCardPackageLineModel.fromJson).toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch package lines [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<OperationResultModel> addPackageToJobCard({
    required String srNumber,
    required String packageId,
    required String userId,
    String campaignLineId = '0',
  }) async {

    final trimmedSr = srNumber.trim();
    if (trimmedSr.isEmpty) {
      throw Exception('Job card number is required.');
    }
    final params = [
      trimmedSr,
      packageId.trim(),
      userId.trim(),
      campaignLineId.trim(),
    ];
    final url = _buildLegacyMotorLubeUrl('addPackageToSR', params);
    try {
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data) ?? const <String, dynamic>{};
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      return OperationResultModel.fromStatusInfo(
        statusInfo,
        defaultSuccessMessage: 'Package added successfully.',
        defaultFailureMessage: 'Failed to add package to SR.',
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to add package [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<OperationResultModel> deletePackageFromJobCard({
    required String packageLineId,
    required String userId,
  }) async {
    final trimmedLineId = packageLineId.trim();
    if (trimmedLineId.isEmpty) {
      throw Exception('Package line ID is required.');
    }
    final trimmedUserId = userId.trim();
    if (trimmedUserId.isEmpty) {
      throw Exception('User identifier is required.');
    }
    final params = [
      trimmedLineId,
      trimmedUserId,
    ];
    final url = _buildLegacyMotorLubeUrl('deletePackageFromSR', params);
    try {
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data) ?? const <String, dynamic>{};
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      return OperationResultModel.fromStatusInfo(
        statusInfo,
        defaultSuccessMessage: 'Package deleted successfully.',
        defaultFailureMessage: 'Failed to delete package.',
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to delete package [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<OperationResultModel> postChecklist({
    required String srNumber,
    required String checklistId,
    required Map<String, dynamic> data,
  }) async {
    final url = _buildLegacyMotorLubeUrl('postCheckList');
    final payload = <String, dynamic>{
      'jobCardNumber': srNumber,
      'id': checklistId,
      'data': data,
    };
    try {
      final response = await _dio.post(url, data: payload);
      final dataMap = _asMap(response.data) ?? const <String, dynamic>{};
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      return OperationResultModel.fromStatusInfo(
        statusInfo,
        defaultSuccessMessage: 'Checklist posted successfully.',
        defaultFailureMessage: 'Failed to submit checklist.',
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to submit checklist [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<List<CustomPackageCategoryModel>> getCustomPackageCategories() async {
    try {
      final url = _buildLegacyMotorLubeUrl('getCustomPackageCategories');
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data);
      if (dataMap == null) return const <CustomPackageCategoryModel>[];
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      if (!statusInfo.isSuccess) {
        final message =
            statusInfo.description.trim().isNotEmpty
                ? statusInfo.description.trim()
                : 'Failed to fetch package categories.';
        throw Exception(message);
      }
      final rawList = _asMapList(
        dataMap['data'] ?? dataMap['categories'] ?? dataMap['items'],
      );
      return rawList.map(CustomPackageCategoryModel.fromJson).toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch package categories [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<List<CustomPackageItemModel>> getCustomPackageItems({
    required String jobCardNumber,
    required String categoryId,
  }) async {
    try {
      final url = _buildLegacyMotorLubeUrl(
        'GetCategoryItems',
        [jobCardNumber, categoryId],
      );
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data);
      if (dataMap == null) return const <CustomPackageItemModel>[];
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      if (!statusInfo.isSuccess) {
        final message =
            statusInfo.description.trim().isNotEmpty
                ? statusInfo.description.trim()
                : 'Failed to fetch category items.';
        throw Exception(message);
      }
      final rawList = _asMapList(
        dataMap['data'] ?? dataMap['items'] ?? dataMap['result'],
      );
      return rawList.map(CustomPackageItemModel.fromJson).toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch category items [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<OperationResultModel> addItemToCustomPackage({
    required String jobCardNumber,
    required String lineId,
    required String categoryId,
    required String inventoryItemId,
    required String qty,
    required String userId,
  }) async {
    final url = _buildLegacyMotorLubeUrl(
      'AddItemToCustomPackageOfSR',
      [jobCardNumber, lineId, categoryId, inventoryItemId, qty, userId],
    );
    try {
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data) ?? const <String, dynamic>{};
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      return OperationResultModel.fromStatusInfo(
        statusInfo,
        defaultSuccessMessage: 'Item added successfully.',
        defaultFailureMessage: 'Failed to add item.',
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to add custom package item [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<OperationResultModel> deleteCustomPackageItem({
    required String srLineId,
  }) async {
    final url = _buildLegacyMotorLubeUrl(
      'DeleteItemFromCustomPackageOfSR',
      [srLineId],
    );
    try {
      final response = await _dio.get(url);
      final dataMap = _asMap(response.data) ?? const <String, dynamic>{};
      final statusInfo = _statusInfoFrom(
        _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
      );
      return OperationResultModel.fromStatusInfo(
        statusInfo,
        defaultSuccessMessage: 'Item deleted successfully.',
        defaultFailureMessage: 'Failed to delete item.',
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to delete custom package item [code: $statusCode]: $message',
      );
    }
  }

  @override
  Future<List<JobCardModel>> completeServiceRequest({
    required String srNumber,
    required String userId,
  }) async {
    final trimmedSr = srNumber.trim();
    if (trimmedSr.isEmpty) {
      throw Exception('Job card number is required.');
    }
    final trimmedUserId = userId.trim();
    if (trimmedUserId.isEmpty) {
      throw Exception('User identifier is required.');
    }

    final url = _buildLegacyMotorLubeUrl(
      'completeJobCard',
      [trimmedSr, trimmedUserId],
    );

    try {
      final response = await _dio.get(url);
      final data = response.data;
      Map<String, dynamic>? dataMap = _asMap(data);
      List<Map<String, dynamic>> rawList = const <Map<String, dynamic>>[];
      var statusInfo = const StatusInfoModel(code: '', type: '', description: '');

      if (dataMap != null) {
        statusInfo = _statusInfoFrom(
          _asMap(dataMap['statusInfo'] ?? dataMap['status'] ?? dataMap['StatusInfo']),
        );
        rawList = _asMapList(
          dataMap['jobCards'] ?? dataMap['items'] ?? dataMap['data'] ?? dataMap['result'],
        );
        if (rawList.isEmpty) {
          final single = _asMap(
            dataMap['jobCard'] ?? dataMap['sr'] ?? dataMap['serviceRequest'],
          );
          if (single != null) {
            rawList = [single];
          }
        }
      } else if (data is List) {
        rawList = _asMapList(data);
      }

      final hasStatusInfo =
          statusInfo.code.isNotEmpty ||
          statusInfo.type.isNotEmpty ||
          statusInfo.description.isNotEmpty;
      if (hasStatusInfo && !statusInfo.isSuccess) {
        final message =
            statusInfo.description.trim().isNotEmpty
                ? statusInfo.description.trim()
                : 'Failed to complete job card.';
        throw Exception(message);
      }

      return rawList.map(JobCardModel.fromJson).toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.message ?? 'Unknown error';
      throw Exception(
        'Failed to complete job card [code: $statusCode]: $message',
      );
    }
  }
}
