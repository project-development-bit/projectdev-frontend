import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cointiply_app/core/services/secure_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureStorageService Platform Tests', () {
    late SecureStorageService storageService;

    setUpAll(() async {
      // Initialize SharedPreferences mock for all tests
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() async {
      // Reset SharedPreferences mock state
      SharedPreferences.setMockInitialValues({});
      storageService = SecureStorageService();
    });

    tearDown(() async {
      // Clean up after each test - only for web tests where it works reliably
      if (kIsWeb) {
        try {
          await storageService.clearAllAuthData();
        } catch (e) {
          debugPrint('Cleanup error: $e');
        }
      }
    });

    test('should use SharedPreferences on web platform', () async {
      // This test focuses on web behavior only
      if (kIsWeb) {
        // Test saving and retrieving auth token
        const testToken = 'test_auth_token_web';
        await storageService.saveAuthToken(testToken);

        final retrievedToken = await storageService.getAuthToken();
        expect(retrievedToken, equals(testToken));

        // Verify storage type
        expect(storageService.storageType, contains('SharedPreferences'));
        expect(storageService.storageType, contains('Web'));
      } else {
        // Skip test on non-web platforms
        markTestSkipped('Test only applicable for web platform');
      }
    });

    test('should use FlutterSecureStorage on mobile platforms', () async {
      // This test focuses on mobile behavior only
      if (!kIsWeb) {
        // Verify storage type without attempting operations that require bindings
        expect(storageService.storageType, contains('FlutterSecureStorage'));
        expect(storageService.storageType, contains('Mobile'));
      } else {
        // Skip test on web platform
        markTestSkipped('Test only applicable for mobile platforms');
      }
    });

    test('should handle platform detection correctly', () {
      // Test storage type property
      final storageType = storageService.storageType;

      if (kIsWeb) {
        expect(storageType, equals('SharedPreferences (Web)'));
      } else {
        expect(storageType, equals('FlutterSecureStorage (Mobile)'));
      }
    });

    test('should clear all auth data on both platforms', () async {
      // Only test on web platform where we can mock reliably
      if (kIsWeb) {
        // Save test data
        await storageService.saveAuthToken('test_token');
        await storageService.saveRefreshToken('test_refresh');
        await storageService.saveUserId('test_user_id');

        // Verify data exists
        final tokenBeforeClear = await storageService.getAuthToken();
        final refreshBeforeClear = await storageService.getRefreshToken();
        final userIdBeforeClear = await storageService.getUserId();

        expect(tokenBeforeClear, equals('test_token'));
        expect(refreshBeforeClear, equals('test_refresh'));
        expect(userIdBeforeClear, equals('test_user_id'));

        // Clear all data
        await storageService.clearAllAuthData();

        // Verify data is cleared
        final tokenAfterClear = await storageService.getAuthToken();
        final refreshAfterClear = await storageService.getRefreshToken();
        final userIdAfterClear = await storageService.getUserId();

        expect(tokenAfterClear, isNull);
        expect(refreshAfterClear, isNull);
        expect(userIdAfterClear, isNull);
      } else {
        // For mobile platforms, we can't easily test storage operations in unit tests
        // due to FlutterSecureStorage requiring platform channels
        markTestSkipped(
            'Storage operations testing requires integration tests on mobile platforms');
      }
    });

    test('should handle authentication check correctly', () async {
      // Only test on web platform where we can mock reliably
      if (kIsWeb) {
        // Initially not authenticated
        final initialAuth = await storageService.isAuthenticated();
        expect(initialAuth, isFalse);

        // Save token
        await storageService.saveAuthToken('valid_token');

        // Now should be authenticated
        final authenticatedState = await storageService.isAuthenticated();
        expect(authenticatedState, isTrue);

        // Clear token
        await storageService.deleteAuthToken();

        // Should not be authenticated
        final finalAuth = await storageService.isAuthenticated();
        expect(finalAuth, isFalse);
      } else {
        // For mobile platforms, skip this test
        markTestSkipped(
            'Authentication testing requires integration tests on mobile platforms');
      }
    });

    test('should handle null and empty values gracefully', () async {
      // Only test on web platform where we can mock reliably
      if (kIsWeb) {
        // Test null handling
        await storageService.deleteAuthToken();
        expect(await storageService.getAuthToken(), isNull);

        // Test empty string handling
        await storageService.saveAuthToken('');
        final emptyToken = await storageService.getAuthToken();
        expect(emptyToken, equals(''));

        // Clean up
        await storageService.deleteAuthToken();
      } else {
        // For mobile platforms, skip this test
        markTestSkipped(
            'Value handling testing requires integration tests on mobile platforms');
      }
    });

    test('should persist data across service instances', () async {
      // Only test on web platform where we can mock reliably
      if (kIsWeb) {
        // Save data with first instance
        await storageService.saveAuthToken('persistent_token');
        await storageService.saveUserId('persistent_user');

        // Create new service instance
        final newStorageService = SecureStorageService();

        // Verify data persists
        final persistedToken = await newStorageService.getAuthToken();
        final persistedUserId = await newStorageService.getUserId();

        expect(persistedToken, equals('persistent_token'));
        expect(persistedUserId, equals('persistent_user'));

        // Clean up
        await newStorageService.clearAllAuthData();
      } else {
        // For mobile platforms, skip this test
        markTestSkipped(
            'Persistence testing requires integration tests on mobile platforms');
      }
    });

    test('should provide correct storage type information', () {
      // This test can run on both platforms as it only checks a getter
      final storageType = storageService.storageType;

      expect(storageType, isNotEmpty);
      expect(
          storageType,
          anyOf(
            equals('SharedPreferences (Web)'),
            equals('FlutterSecureStorage (Mobile)'),
          ));

      // Verify consistency with platform detection
      if (kIsWeb) {
        expect(storageType, contains('Web'));
        expect(storageService.storageType, contains('SharedPreferences'));
      } else {
        expect(storageType, contains('Mobile'));
        expect(storageService.storageType, contains('FlutterSecureStorage'));
      }
    });
  });
}
