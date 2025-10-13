import 'package:cointiply_app/core/config/api_endpoints.dart';
import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/auth/data/models/register_request.dart';
import 'package:cointiply_app/features/auth/data/models/login_request.dart';
import 'package:cointiply_app/features/auth/data/models/login_response_model.dart';
import 'package:dio/dio.dart';
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
