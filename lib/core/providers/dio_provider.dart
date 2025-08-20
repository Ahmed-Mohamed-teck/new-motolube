import 'dart:async';



import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'secure_storage_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(milliseconds: 50000),
    receiveTimeout: const Duration(milliseconds: 50000),
  );

  dio.interceptors.add(
    InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await ref.read(secureStoreProvider).readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    }),
  );

  return dio;
});
final dioClientProvider = Provider<DioClient>((ref) {

  final dio = ref.read(dioProvider);

  return DioClient(
    dio,
  );
});

class DioClient with ChangeNotifier {
  //* Dependencies
  final Dio _dio;



  //* Constructor
  DioClient(this._dio);

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool requiredApiAuth = false,
      }) async {
    try {
      if (requiredApiAuth) {
        options ??= Options();
        options.headers ??= {};
        options.headers?['Authorization'] = 'Bearer YOUR_API_TOKEN';
      }
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool requiredApiAuth = false,
      }) async {
    try {
      if (requiredApiAuth) {
        options ??= Options();
        options.headers ??= {};
        options.headers?['Authorization'] = 'Bearer YOUR_API_TOKEN';
      }

      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }





// <---------------------------------------------- Retry Request Implementation
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }


}
