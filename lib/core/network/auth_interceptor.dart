import 'dart:async';
import 'dart:developer';
import 'dart:developer' as logger show log;
import 'package:cointiply_app/core/config/flavor_manager.dart';
import 'package:cointiply_app/core/services/secure_storage_service.dart';
import 'package:cointiply_app/core/services/platform_recaptcha_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final name = "TokenInterceptor";

class TokenInterceptor extends Interceptor {
  List<Map<dynamic, dynamic>> failedRequests = [];
  bool isRefreshing = false;
  final SecureStorageService tokenService;

  TokenInterceptor(this.tokenService);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.uri.path;
    log('REQUEST => PATH: $path, METHOD: ${options.method}, HEADERS: ${options.headers}',
        name: name);
    final accessToken = await tokenService.getAuthToken() ?? '';
    if (kDebugMode) {
      logger.log("Current Token : $accessToken", name: name);
    }
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $accessToken";
    }

    if (path.contains('upload')) {
      options.headers['Content-Type'] = 'multipart/form-data';
    } else {
      options.headers['Content-Type'] = 'application/json';
    }

    try {
      String platform = "WEB"; // Default to web
      if (PlatformRecaptchaService.isIOS) {
        platform = "ios";
      } else if (PlatformRecaptchaService.isAndroid) {
        platform = "android";
      }
      options.headers['API_REQUEST_FROM'] = platform;
    } catch (_) {
      options.headers['API_REQUEST_FROM'] = "WEB";
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}, IS REFRESHING: ${isRefreshing.toString()}',
      name: name,
    );
    
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      if (!isRefreshing) {
        log("ACCESS TOKEN EXPIRED, GETTING NEW TOKEN PAIR", name: name);
        isRefreshing = true;
        
        // Try to refresh the token
        try {
          await refreshToken(err, handler);
        } catch (e) {
          log("REFRESH TOKEN FAILED: $e", name: name);
          isRefreshing = false;
          failedRequests = [];
          return handler.reject(err);
        }
      } else {
        log("ADDING ERROR REQUEST TO FAILED QUEUE", name: name);
        failedRequests.add({'err': err, 'handler': handler});
      }
    } else {
      return handler.next(err);
    }
  }

  FutureOr refreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    Dio retryDio = Dio(
      BaseOptions(
        baseUrl: FlavorManager.currentConfig.fullApiUrl,
        headers: <String, String>{'Content-Type': 'application/json'},
      ),
    );

    try {
      final refreshToken = await tokenService.getRefreshToken();
      
      // Check if refresh token exists
      if (refreshToken == null || refreshToken.isEmpty) {
        log("NO REFRESH TOKEN AVAILABLE, LOGGING OUT", name: name);
        isRefreshing = false;
        failedRequests = [];

        // Clear all tokens
        await tokenService.clearAllAuthData();

        throw DioException(
          requestOptions: err.requestOptions,
          error: 'No refresh token available',
          type: DioExceptionType.connectionError,
        );
      }

      log("REFRESHING TOKEN WITH: ${refreshToken.substring(0, 20)}...",
          name: name);
      
      final response = await retryDio.post(
        'users/refresh-token',
        data: {"refreshToken": refreshToken},
      );
      
      final parsedResponse = response.data;
      
      // Check if response is successful
      if (response.statusCode == null || response.statusCode! >= 400) {
        log("REFRESH TOKEN INVALID: ${response.statusCode} - ${response.data}",
            name: name);
        isRefreshing = false;
        failedRequests = [];

        // Clear all tokens
        await tokenService.clearAllAuthData();

        throw DioException(
          requestOptions: err.requestOptions,
          response: response,
          error: 'Refresh token expired or invalid',
          type: DioExceptionType.badResponse,
        );
      }

      // Extract tokens from response
      String? newAccessToken;
      String? newRefreshToken;

      // Handle different response structures
      if (parsedResponse is Map<String, dynamic>) {
        // Check if tokens are at root level
        if (parsedResponse.containsKey('accessToken')) {
          newAccessToken = parsedResponse['accessToken'];
          newRefreshToken = parsedResponse['refreshToken'];
        }
        // Check if tokens are in 'data' object
        else if (parsedResponse.containsKey('data') &&
            parsedResponse['data'] is Map) {
          final data = parsedResponse['data'] as Map<String, dynamic>;
          newAccessToken = data['accessToken'] ?? data['access_token'];
          newRefreshToken = data['refreshToken'] ?? data['refresh_token'];
        }
        // Check if tokens are in 'tokens' object
        else if (parsedResponse.containsKey('tokens') &&
            parsedResponse['tokens'] is Map) {
          final tokens = parsedResponse['tokens'] as Map<String, dynamic>;
          newAccessToken = tokens['accessToken'] ?? tokens['access_token'];
          newRefreshToken = tokens['refreshToken'] ?? tokens['refresh_token'];
        }
      }

      if (newAccessToken == null || newAccessToken.isEmpty) {
        log("NO ACCESS TOKEN IN RESPONSE: $parsedResponse", name: name);
        isRefreshing = false;
        failedRequests = [];

        throw DioException(
          requestOptions: err.requestOptions,
          response: response,
          error: 'No access token in refresh response',
          type: DioExceptionType.badResponse,
        );
      }

      // Save new tokens
      await tokenService.saveAuthToken(newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await tokenService.saveRefreshToken(newRefreshToken);
      }

      log("TOKEN REFRESH SUCCESSFUL", name: name);
      log("RETRYING ${failedRequests.length} FAILED REQUEST(s)", name: name);

      // Retry all failed requests
      await retryRequests(newAccessToken);

      isRefreshing = false;
    } on DioException catch (e) {
      log("REFRESH TOKEN DIO ERROR: ${e.response?.statusCode} - ${e.message}",
          name: name);
      isRefreshing = false;
      failedRequests = [];

      // Clear all tokens on refresh failure
      await tokenService.clearAllAuthData();
      
      rethrow;
    } catch (e) {
      log("REFRESH TOKEN UNEXPECTED ERROR: $e", name: name);
      isRefreshing = false;
      failedRequests = [];
      
      // Clear all tokens on any failure
      await tokenService.clearAllAuthData();

      rethrow;
    }
  }

  Future retryRequests(token) async {
    Dio retryDio = Dio(
      BaseOptions(
        baseUrl: FlavorManager.currentConfig.fullApiUrl,
        headers: <String, String>{'Content-Type': 'application/json'},
      ),
    );

    for (var i = 0; i < failedRequests.length; i++) {
      log('RETRYING[$i] => PATH: ${failedRequests[i]['err'].requestOptions.path}');
      RequestOptions requestOptions =
          failedRequests[i]['err'].requestOptions as RequestOptions;
      requestOptions.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      await retryDio.fetch(requestOptions).then(
            failedRequests[i]['handler'].resolve,
            onError: (error) =>
                failedRequests[i]['handler'].reject(error as DioException),
          );
    }
    isRefreshing = false;
    failedRequests = [];
  }
}
