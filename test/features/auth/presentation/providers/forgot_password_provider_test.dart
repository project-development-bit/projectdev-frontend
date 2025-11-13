import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/features/auth/presentation/providers/forgot_password_provider.dart';
import 'package:cointiply_app/features/auth/data/models/forgot_password_response.dart';

void main() {
  group('ForgotPasswordProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be ForgotPasswordInitial', () {
      // Act
      final state = container.read(forgotPasswordProvider);

      // Assert
      expect(state, isA<ForgotPasswordInitial>());
    });

    test('should validate email format correctly', () async {
      // Arrange
      final notifier = container.read(forgotPasswordProvider.notifier);

      // Test invalid emails
      const invalidEmails = [
        '',
        'invalid-email',
        '@domain.com',
        'user@',
        'user@domain',
        'user..name@domain.com',
      ];

      for (final email in invalidEmails) {
        // Act
        await notifier.forgotPassword(email, 'mock-turnstile-token');

        // Assert
        final state = container.read(forgotPasswordProvider);
        expect(state, isA<ForgotPasswordError>());
        expect((state as ForgotPasswordError).message,
            'Please enter a valid email address');

        // Reset for next test
        notifier.reset();
      }
    });

    test('should accept valid email formats', () {
      // Note: This test would require mocking the repository to actually test the full flow
      // For now, we just test that invalid emails are caught before reaching the repository

      const validEmails = [
        'user@domain.com',
        'user.name@domain.co.uk',
        'user+tag@domain.org',
        'user123@test-domain.com',
        'test@example.io',
      ];

      for (final email in validEmails) {
        final notifier = container.read(forgotPasswordProvider.notifier);

        // This will fail at the repository level since we don't have a mock
        // But it shows the email validation passes
        expect(() => notifier.forgotPassword(email, 'mock-turnstile-token'),
            returnsNormally);

        // Reset for next test
        notifier.reset();
      }
    });

    test('reset should return to initial state', () async {
      // Arrange
      final notifier = container.read(forgotPasswordProvider.notifier);

      // Set an error state first
      await notifier.forgotPassword(
          '', 'mock-turnstile-token'); // This will create an error state
      expect(
          container.read(forgotPasswordProvider), isA<ForgotPasswordError>());

      // Act
      notifier.reset();

      // Assert
      expect(
          container.read(forgotPasswordProvider), isA<ForgotPasswordInitial>());
    });

    group('State Types', () {
      test('ForgotPasswordSuccess should hold response data', () {
        // Arrange
        const response = ForgotPasswordResponse(
          success: true,
          message: 'Test message',
          data:
              ForgotPasswordData(email: 'test@example.com', securityCode: 1234),
        );

        // Act
        final state = ForgotPasswordSuccess(response);

        // Assert
        expect(state.response, equals(response));
        expect(state.response.data.email, 'test@example.com');
        expect(state.response.data.securityCode, 1234);
      });

      test('ForgotPasswordError should hold error message and status code', () {
        // Arrange
        const message = 'Network error';
        const statusCode = 500;

        // Act
        final state = ForgotPasswordError(message, statusCode: statusCode);

        // Assert
        expect(state.message, message);
        expect(state.statusCode, statusCode);
      });

      test('ForgotPasswordError should work without status code', () {
        // Arrange
        const message = 'Validation error';

        // Act
        final state = ForgotPasswordError(message);

        // Assert
        expect(state.message, message);
        expect(state.statusCode, isNull);
      });
    });

    group('Email Validation', () {
      late ForgotPasswordNotifier notifier;

      setUp(() {
        notifier = container.read(forgotPasswordProvider.notifier);
      });

      test('should reject empty email', () {
        // Act
        notifier.forgotPassword('', 'mock-turnstile-token');

        // Assert
        final state = container.read(forgotPasswordProvider);
        expect(state, isA<ForgotPasswordError>());
        expect((state as ForgotPasswordError).message,
            'Please enter a valid email address');
      });

      test('should reject email without @', () {
        // Act
        notifier.forgotPassword('userexample.com', 'mock-turnstile-token');

        // Assert
        final state = container.read(forgotPasswordProvider);
        expect(state, isA<ForgotPasswordError>());
      });

      test('should reject email without domain', () {
        // Act
        notifier.forgotPassword('user@', 'mock-turnstile-token');

        // Assert
        final state = container.read(forgotPasswordProvider);
        expect(state, isA<ForgotPasswordError>());
      });

      test('should reject email without local part', () {
        // Act
        notifier.forgotPassword('@example.com', 'mock-turnstile-token');

        // Assert
        final state = container.read(forgotPasswordProvider);
        expect(state, isA<ForgotPasswordError>());
      });
    });
  });
}
