import 'package:flutter_test/flutter_test.dart';
import 'package:cointiply_app/features/auth/data/models/login_request.dart';

void main() {
  group('LoginRequest', () {
    test('should create LoginRequest with email and password only', () {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      const loginRequest = LoginRequest(
        email: email,
        password: password,
      );

      // Assert
      expect(loginRequest.email, email);
      expect(loginRequest.password, password);
      expect(loginRequest.recaptchaToken, isNull);
    });

    test('should create LoginRequest with email, password, and reCAPTCHA token', () {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const recaptchaToken = 'test_recaptcha_token';

      // Act
      const loginRequest = LoginRequest(
        email: email,
        password: password,
        recaptchaToken: recaptchaToken,
      );

      // Assert
      expect(loginRequest.email, email);
      expect(loginRequest.password, password);
      expect(loginRequest.recaptchaToken, recaptchaToken);
    });

    group('toJson', () {
      test('should convert to JSON without reCAPTCHA token when token is null', () {
        // Arrange
        const loginRequest = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
        );

        // Act
        final json = loginRequest.toJson();

        // Assert
        expect(json, {
          'email': 'test@example.com',
          'password': 'password123',
        });
        expect(json.containsKey('recaptchaToken'), isFalse);
      });

      test('should convert to JSON with reCAPTCHA token when token is provided', () {
        // Arrange
        const loginRequest = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
          recaptchaToken: 'test_recaptcha_token',
        );

        // Act
        final json = loginRequest.toJson();

        // Assert
        expect(json, {
          'email': 'test@example.com',
          'password': 'password123',
          'recaptchaToken': 'test_recaptcha_token',
        });
      });
    });

    group('fromJson', () {
      test('should create LoginRequest from JSON without reCAPTCHA token', () {
        // Arrange
        const json = {
          'email': 'test@example.com',
          'password': 'password123',
        };

        // Act
        final loginRequest = LoginRequest.fromJson(json);

        // Assert
        expect(loginRequest.email, 'test@example.com');
        expect(loginRequest.password, 'password123');
        expect(loginRequest.recaptchaToken, isNull);
      });

      test('should create LoginRequest from JSON with reCAPTCHA token', () {
        // Arrange
        const json = {
          'email': 'test@example.com',
          'password': 'password123',
          'recaptchaToken': 'test_recaptcha_token',
        };

        // Act
        final loginRequest = LoginRequest.fromJson(json);

        // Assert
        expect(loginRequest.email, 'test@example.com');
        expect(loginRequest.password, 'password123');
        expect(loginRequest.recaptchaToken, 'test_recaptcha_token');
      });
    });

    group('copyWith', () {
      test('should create copy with updated email', () {
        // Arrange
        const original = LoginRequest(
          email: 'original@example.com',
          password: 'password123',
          recaptchaToken: 'original_token',
        );

        // Act
        final copy = original.copyWith(email: 'new@example.com');

        // Assert
        expect(copy.email, 'new@example.com');
        expect(copy.password, 'password123');
        expect(copy.recaptchaToken, 'original_token');
      });

      test('should create copy with updated reCAPTCHA token', () {
        // Arrange
        const original = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
        );

        // Act
        final copy = original.copyWith(recaptchaToken: 'new_token');

        // Assert
        expect(copy.email, 'test@example.com');
        expect(copy.password, 'password123');
        expect(copy.recaptchaToken, 'new_token');
      });

      test('should create copy with null reCAPTCHA token', () {
        // Arrange
        const original = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
          recaptchaToken: 'original_token',
        );

        // Act
        final copy = original.copyWith(clearRecaptchaToken: true);

        // Assert
        expect(copy.email, 'test@example.com');
        expect(copy.password, 'password123');
        expect(copy.recaptchaToken, isNull);
      });
    });

    group('props', () {
      test('should include all fields in props for equality comparison', () {
        // Arrange
        const loginRequest1 = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
          recaptchaToken: 'token123',
        );

        const loginRequest2 = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
          recaptchaToken: 'token123',
        );

        const loginRequest3 = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
          recaptchaToken: 'different_token',
        );

        // Assert
        expect(loginRequest1, equals(loginRequest2));
        expect(loginRequest1, isNot(equals(loginRequest3)));
      });
    });

    group('toString', () {
      test('should return string representation without exposing sensitive data', () {
        // Arrange
        const loginRequest = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
          recaptchaToken: 'token123',
        );

        // Act
        final stringRepresentation = loginRequest.toString();

        // Assert
        expect(stringRepresentation, contains('test@example.com'));
        expect(stringRepresentation, contains('hasRecaptcha: true'));
        expect(stringRepresentation, isNot(contains('password123'))); // Should not expose password
        expect(stringRepresentation, isNot(contains('token123'))); // Should not expose token
      });

      test('should show hasRecaptcha: false when token is null', () {
        // Arrange
        const loginRequest = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
        );

        // Act
        final stringRepresentation = loginRequest.toString();

        // Assert
        expect(stringRepresentation, contains('test@example.com'));
        expect(stringRepresentation, contains('hasRecaptcha: false'));
      });
    });
  });
}