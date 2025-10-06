import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/flavor_manager.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = FlavorManager.currentConfig;
  
  final dio = Dio(BaseOptions(
    baseUrl: config.fullApiUrl,
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.receiveTimeout,
    sendTimeout: config.sendTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Only add pretty logger for development and staging
  if (config.enableLogging) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  // Add debug interceptor for non-production builds
  if (config.enableDebugFeatures) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 ${options.method.toUpperCase()} ${options.uri}');
        if (options.data != null) {
          print('📤 Request Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        print(
            '❌ ${error.requestOptions.method.toUpperCase()} ${error.requestOptions.uri}');
        print('💥 Error: ${error.message}');
        if (error.response != null) {
          print('📥 Response: ${error.response?.data}');
        }
        handler.next(error);
      },
    ));
  }

  return dio;
});
