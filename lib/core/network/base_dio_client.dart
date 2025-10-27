// core/network/dio_client.dart
import 'package:cointiply_app/core/config/flavor_manager.dart';
import 'package:cointiply_app/core/network/auth_interceptor.dart';
import 'package:cointiply_app/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClientProvider = Provider<DioClient>(
    (ref) => DioClient(ref.watch(secureStorageServiceProvider)));

class DioClient {
  late final Dio _dio;

  DioClient(SecureStorageService tokenService) {
    // TEMPORARY: Switch URLs for debugging endpoint issues
    // TODO: Remove this after confirming correct endpoint
    final baseUrl = FlavorManager.currentConfig.fullApiUrl;
    debugPrint('🌐 DioClient using base URL: $baseUrl');

    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    _dio.interceptors.add(TokenInterceptor(tokenService));

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Dio get client => _dio;

  /// HTTP GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  /// HTTP POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  /// HTTP PUT
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  /// HTTP DELETE
  Future<Response> delete(String path, {dynamic data}) async {
    return await _dio.delete(path, data: data);
  }
}
