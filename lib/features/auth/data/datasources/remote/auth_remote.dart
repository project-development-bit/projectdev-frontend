import 'package:cointiply_app/core/config/api_endpoints.dart';
import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/auth/data/models/register_request.dart';
import 'package:cointiply_app/features/auth/data/models/login_request.dart';
import 'package:cointiply_app/features/auth/data/models/login_response_model.dart';
import 'package:cointiply_app/features/auth/data/models/resend_code_request.dart';
import 'package:cointiply_app/features/auth/data/models/resend_code_response.dart';
import 'package:cointiply_app/features/auth/data/models/verify_code_request.dart';
import 'package:cointiply_app/features/auth/data/models/verify_code_response.dart';
import 'package:cointiply_app/features/auth/data/models/forgot_password_request.dart';
import 'package:cointiply_app/features/auth/data/models/forgot_password_response.dart';
import 'package:cointiply_app/features/auth/data/models/reset_password_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the authentication remote data source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
  ),
);

/// Abstract interface for authentication remote operations
abstract class AuthRemoteDataSource {
  /// Register a new user with the provided request data
  Future<void> register(RegisterRequest request);

  /// Login user with email and password
  Future<LoginResponseModel> login(LoginRequest request);

  /// Send forgot password request
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request);

  /// Reset password with new password
  Future<LoginResponseModel> resetPassword(ResetPasswordRequest request);

  /// Resend verification code to user's email
  Future<ResendCodeResponse> resendCode(ResendCodeRequest request);

  /// Verify email with verification code
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request);
}

/// Implementation of [AuthRemoteDataSource] that handles HTTP requests
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// HTTP client for making network requests
  final DioClient dioClient;

  /// Creates an instance of [AuthRemoteDataSourceImpl]
  const AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<void> register(RegisterRequest request) async {
    try {
      await dioClient.post(
        registerEndpoints,
        data: request.toJson(),
      );

      // Successful responses (200-299) don't need explicit handling
      // Dio automatically throws for non-2xx responses
    } on DioException catch (e) {
      // Extract server error message from response data
      final serverMessage = _extractServerErrorMessage(e.response?.data);

      // Create new DioException with server message or appropriate fallback
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      // Handle any other unexpected exceptions
      throw Exception('Unexpected error during registration: $e');
    }
  }

  /// Extract error message from server response data
  String? _extractServerErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] as String?;
    }
    return null;
  }

  @override
  Future<LoginResponseModel> login(LoginRequest request) async {
    try {
      final response = await dioClient.post(
        loginEndpoints,
        data: request.toJson(),
      );

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ Login DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      // Check for the specific "Client error" message
      if (e.response?.data?.toString().contains('Client error') == true ||
          e.message?.contains('Client error') == true) {
        debugPrint('🚨 FOUND "CLIENT ERROR" MESSAGE IN LOGIN!');
        debugPrint('🚨 Full response: ${e.response?.data}');
        debugPrint('🚨 Full message: ${e.message}');
        debugPrint('🚨 This error is likely from the API server!');
      }

      // Extract server error message from response data
      final serverMessage = _extractServerErrorMessage(e.response?.data);

      // Create new DioException with server message or appropriate fallback
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      // Handle any other unexpected exceptions
      throw Exception('Unexpected error during login: $e');
    }
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(
      ForgotPasswordRequest request) async {
    try {
      debugPrint('📤 Sending forgot password request to: ${request.email}');
      debugPrint('📤 Request URL: $forgotPasswordEndpoints');
      debugPrint(
          '📤 Base URL from DioClient: ${dioClient.client.options.baseUrl}');
      debugPrint('📤 Request data: ${request.toJson()}');

      final response = await dioClient.post(
        forgotPasswordEndpoints,
        data: request.toJson(),
      );

      debugPrint('📥 Forgot password response: ${response.data}');

      return ForgotPasswordResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ Forgot password DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      
      // Check for the specific "Client error" message
      if (e.response?.data?.toString().contains('Client error') == true ||
          e.message?.contains('Client error') == true) {
        debugPrint('🚨 FOUND "CLIENT ERROR" MESSAGE IN FORGOT PASSWORD!');
        debugPrint('🚨 Full response: ${e.response?.data}');
        debugPrint('🚨 Full message: ${e.message}');
      }

      // Extract server error message from response data
      final serverMessage = _extractServerErrorMessage(e.response?.data);

      // Create new DioException with server message or appropriate fallback
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      // Handle any other unexpected exceptions
      throw Exception('Unexpected error during forgot password request: $e');
    }
  }

  @override
  Future<LoginResponseModel> resetPassword(ResetPasswordRequest request) async {
    try {
      debugPrint('📤 Sending reset password request for: ${request.email}');
      debugPrint('📤 Request URL: $savePasswordEndpoints');
      debugPrint(
          '📤 Base URL from DioClient: ${dioClient.client.options.baseUrl}');
      debugPrint('📤 Request data: ${request.toJson()}');

      final response = await dioClient.post(
        savePasswordEndpoints,
        data: request.toJson(),
      );

      debugPrint('📥 Reset password response: ${response.data}');

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ Reset password DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      
      // Check for the specific "Client error" message
      if (e.response?.data?.toString().contains('Client error') == true ||
          e.message?.contains('Client error') == true) {
        debugPrint('🚨 FOUND "CLIENT ERROR" MESSAGE IN RESET PASSWORD!');
        debugPrint('🚨 Full response: ${e.response?.data}');
        debugPrint('🚨 Full message: ${e.message}');
      }

      // Extract server error message from response data
      final serverMessage = _extractServerErrorMessage(e.response?.data);

      // Create new DioException with server message or appropriate fallback
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      // Handle any other unexpected exceptions
      throw Exception('Unexpected error during reset password request: $e');
    }
  }

  @override
  Future<ResendCodeResponse> resendCode(ResendCodeRequest request) async {
    try {
      debugPrint('📤 Resending code to: ${request.email}');
      debugPrint('📤 Request URL: $resendCodeEndpoints');
      debugPrint(
          '📤 Base URL from DioClient: ${dioClient.client.options.baseUrl}');
      debugPrint('📤 Request data: ${request.toJson()}');

      final response = await dioClient.post(
        resendCodeEndpoints,
        data: request.toJson(),
      );

      return ResendCodeResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ Resend code DioException: ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      // Extract server error message from response data
      final serverMessage = _extractServerErrorMessage(e.response?.data);

      // Create new DioException with server message or appropriate fallback
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      // Handle any other unexpected exceptions
      throw Exception('Unexpected error during resend code: $e');
    }
  }

  @override
  Future<VerifyCodeResponse> verifyCode(VerifyCodeRequest request) async {
    try {
      // Option 1: Try with path parameters (current implementation)
      final encodedEmail = Uri.encodeComponent(request.email);
      final encodedCode = Uri.encodeComponent(request.code);
      final url = '$verifyCodeEndpoints/$encodedEmail/$encodedCode';

      debugPrint('🔍 Verifying code with URL: $url');
      debugPrint(
          '🔍 Base URL from DioClient: ${dioClient.client.options.baseUrl}');
      debugPrint(
          '🔍 Full URL will be: ${dioClient.client.options.baseUrl}$url');

      final response = await dioClient.get(url);

      return VerifyCodeResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ Verify code DioException (path params): ${e.message}');
      debugPrint('❌ Request URL: ${e.requestOptions.uri}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      // If path parameter approach fails with 404, try with request body
      if (e.response?.statusCode == 404) {
        debugPrint('🔄 Trying alternative approach with request body...');
        try {
          final response = await dioClient.post(
            verifyCodeEndpoints,
            data: request.toJson(),
          );

          debugPrint('✅ Alternative approach with request body succeeded!');
          return VerifyCodeResponse.fromJson(
              response.data as Map<String, dynamic>);
        } on DioException catch (bodyException) {
          debugPrint(
              '❌ Alternative approach also failed: ${bodyException.message}');

          // Try third approach: different endpoint format
          debugPrint('🔄 Trying third approach with verify-email endpoint...');
          try {
            final response = await dioClient.post(
              'verify-email',
              data: request.toJson(),
            );

            debugPrint(
                '✅ Third approach with verify-email endpoint succeeded!');
            return VerifyCodeResponse.fromJson(
                response.data as Map<String, dynamic>);
          } on DioException catch (thirdException) {
            debugPrint(
                '❌ Third approach also failed: ${thirdException.message}');
            // Continue with original error handling
          }
        }
      }

      // Extract server error message from response data
      final serverMessage = _extractServerErrorMessage(e.response?.data);

      // Create new DioException with server message or appropriate fallback
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage ?? _getFallbackMessage(e),
      );
    } catch (e) {
      // Handle any other unexpected exceptions
      throw Exception('Unexpected error during verification: $e');
    }
  }

  /// Get appropriate fallback message based on status code or original message
  String _getFallbackMessage(DioException exception) {
    final statusCode = exception.response?.statusCode;

    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Invalid credentials';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      default:
        return exception.message ?? 'Authentication failed';
    }
  }
}
