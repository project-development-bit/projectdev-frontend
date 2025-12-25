import 'package:flutter_test/flutter_test.dart';
import 'package:gigafaucet/features/auth/data/models/reset_password_request.dart';

void main() {
  group('ResetPasswordRequest', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testConfirmPassword = 'password123';

    test('should create ResetPasswordRequest with required fields', () {
      // Act
      const request = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(request.email, testEmail);
      expect(request.password, testPassword);
      expect(request.confirmPassword, testConfirmPassword);
    });

    test('should convert to JSON correctly', () {
      // Arrange
      const request = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Act
      final json = request.toJson();

      // Assert
      expect(json, {
        'email': testEmail,
        'password': testPassword,
        'confirm_password': testConfirmPassword,
      });
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'email': testEmail,
        'password': testPassword,
        'confirm_password': testConfirmPassword,
      };

      // Act
      final request = ResetPasswordRequest.fromJson(json);

      // Assert
      expect(request.email, testEmail);
      expect(request.password, testPassword);
      expect(request.confirmPassword, testConfirmPassword);
    });

    test('should support equality comparison', () {
      // Arrange
      const request1 = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );
      const request2 = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );
      const request3 = ResetPasswordRequest(
        email: 'different@example.com',
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(request1, equals(request2));
      expect(request1, isNot(equals(request3)));
      expect(request1.hashCode, equals(request2.hashCode));
    });

    test('should support copyWith method', () {
      // Arrange
      const originalRequest = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Act
      final updatedRequest = originalRequest.copyWith(
        email: 'newemail@example.com',
      );

      // Assert
      expect(updatedRequest.email, 'newemail@example.com');
      expect(updatedRequest.password, testPassword);
      expect(updatedRequest.confirmPassword, testConfirmPassword);
    });

    test('should validate password match correctly', () {
      // Arrange
      const matchingRequest = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testPassword,
      );
      const nonMatchingRequest = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: 'differentpassword',
      );

      // Assert
      expect(matchingRequest.isPasswordMatched, isTrue);
      expect(nonMatchingRequest.isPasswordMatched, isFalse);
    });

    test('should validate password requirements', () {
      // Arrange
      const validRequest = ResetPasswordRequest(
        email: testEmail,
        password: 'validpassword',
        confirmPassword: 'validpassword',
      );
      const invalidRequest = ResetPasswordRequest(
        email: testEmail,
        password: 'short',
        confirmPassword: 'short',
      );

      // Assert
      expect(validRequest.isPasswordValid, isTrue);
      expect(invalidRequest.isPasswordValid, isFalse);
    });

    test('should check completeness of fields', () {
      // Arrange
      const completeRequest = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );
      const incompleteRequest = ResetPasswordRequest(
        email: '',
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(completeRequest.isComplete, isTrue);
      expect(incompleteRequest.isComplete, isFalse);
    });

    test('should have secure toString representation', () {
      // Arrange
      const request = ResetPasswordRequest(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Act
      final stringRepresentation = request.toString();

      // Assert
      expect(stringRepresentation, contains(testEmail));
      expect(stringRepresentation, contains('[HIDDEN]'));
      expect(stringRepresentation, isNot(contains(testPassword)));
    });
  });
}
