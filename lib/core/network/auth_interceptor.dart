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
    );
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      if (!isRefreshing) {
        log("ACCESS TOKEN EXPIRED, GETTING NEW TOKEN PAIR");
        isRefreshing = true;
        failedRequests.add({'err': err, 'handler': handler});
        await refreshToken(err, handler);
        return handler.next(err);
      } else {
        log("ADDING ERROR REQUEST TO FAILED QUEUE");
        failedRequests.add({'err': err, 'handler': handler});
        return handler.next(err);
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
      final response = await retryDio.post(
        'users/refresh-token',
        data: {"refreshToken": refreshToken},
      );
      final parsedResponse = response.data;
      if (response.statusCode != null && response.statusCode! >= 400) {
        // Handle logout for invalid refresh tokens
        log("LOGGING OUT: EXPIRED REFRESH TOKEN ${response.data}");

        return handler.reject(err);
      }
      await tokenService.saveAuthToken(parsedResponse['accessToken']);
      isRefreshing = false;
      log("RETRYING ${failedRequests.length} FAILED REQUEST(s)", name: name);
      await retryRequests(parsedResponse['data']['access_token']);
    } on DioException catch (e) {
      log("LOGGING OUT: EXPIRED REFRESH TOKEN $e", name: name);
      return handler.reject(err);
    } catch (e) {
      // Handle cases like 400 Bad Request or other server errors
      log("REFRESH TOKEN FAILED: $e", name: name);
      isRefreshing = false;
      failedRequests = [];
      handler.reject(err); // Pass the original error back
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
