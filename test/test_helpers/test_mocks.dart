import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/core/config/app_flavor.dart';
import 'package:cointiply_app/core/config/app_config.dart';

/// Test providers for testing
class TestProviders {
  /// Test Dio provider for testing network calls
  static final testDioProvider = Provider<Dio>((ref) {
    return Dio(BaseOptions(
      baseUrl: 'https://test-api.example.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));
  });

  /// Test flavor provider that always returns dev flavor
  static final testFlavorProvider = Provider<AppFlavor>((ref) {
    return AppFlavor.dev;
  });

  /// Test config provider with dev configuration
  static final testConfigProvider = Provider<AppConfig>((ref) {
    return AppConfig.dev;
  });

  /// Get all test overrides for replacing real providers
  static List<Override> getAllTestOverrides() {
    return [
      // Add provider overrides here as needed
    ];
  }
}

/// Test data factory for creating test objects
class TestDataFactory {
  /// Creates a test user object
  static Map<String, dynamic> createTestUser({
    String? id,
    String? email,
    String? name,
  }) {
    return {
      'id': id ?? 'test-user-123',
      'email': email ?? 'test@example.com',
      'name': name ?? 'Test User',
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  /// Creates a test login request
  static Map<String, String> createLoginRequest({
    String? email,
    String? password,
  }) {
    return {
      'email': email ?? 'test@example.com',
      'password': password ?? 'password123',
    };
  }

  /// Creates a test API response data
  static Map<String, dynamic> createApiResponseData({
    Map<String, dynamic>? data,
    String? message,
  }) {
    return data ?? {'message': message ?? 'Success'};
  }

  /// Creates a test API error data
  static Map<String, dynamic> createApiErrorData({
    String? message,
  }) {
    return {'error': message ?? 'Bad Request'};
  }
}

/// Test constants for use across tests
class TestConstants {
  // Test API endpoints
  static const String testApiBaseUrl = 'https://test-api.example.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';

  // Test user data
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testName = 'Test User';
  static const String testPhone = '+1234567890';

  // Test validation messages
  static const String emailRequiredMessage = 'Email is required';
  static const String emailInvalidMessage =
      'Please enter a valid email address';
  static const String passwordRequiredMessage = 'Password is required';
  static const String passwordTooShortMessage =
      'Password must be at least 6 characters long';

  // Test timeouts
  static const Duration shortTimeout = Duration(milliseconds: 100);
  static const Duration mediumTimeout = Duration(milliseconds: 500);
  static const Duration longTimeout = Duration(seconds: 2);
}
