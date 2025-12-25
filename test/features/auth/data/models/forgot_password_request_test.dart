import 'package:flutter_test/flutter_test.dart';
import 'package:gigafaucet/features/auth/data/models/forgot_password_request.dart';

void main() {
  group('ForgotPasswordRequest', () {
    const testEmail = 'test@example.com';

    test('should create instance with required email', () {
      // Arrange & Act
      const request = ForgotPasswordRequest(email: testEmail);

      // Assert
      expect(request.email, testEmail);
    });

    test('should convert to JSON correctly', () {
      // Arrange
      const request = ForgotPasswordRequest(email: testEmail);

      // Act
      final json = request.toJson();

      // Assert
      expect(json['email'], testEmail);
      expect(json.keys.length, 1);
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {'email': testEmail};

      // Act
      final request = ForgotPasswordRequest.fromJson(json);

      // Assert
      expect(request.email, testEmail);
    });

    test('should implement equality correctly', () {
      // Arrange
      const request1 = ForgotPasswordRequest(email: testEmail);
      const request2 = ForgotPasswordRequest(email: testEmail);
      const request3 = ForgotPasswordRequest(email: 'different@example.com');

      // Assert
      expect(request1, equals(request2));
      expect(request1, isNot(equals(request3)));
    });

    test('should implement hashCode correctly', () {
      // Arrange
      const request1 = ForgotPasswordRequest(email: testEmail);
      const request2 = ForgotPasswordRequest(email: testEmail);

      // Assert
      expect(request1.hashCode, equals(request2.hashCode));
    });

    test('should have correct toString representation', () {
      // Arrange
      const request = ForgotPasswordRequest(email: testEmail);

      // Act
      final stringRepresentation = request.toString();

      // Assert
      expect(stringRepresentation, contains('ForgotPasswordRequest'));
      expect(stringRepresentation, contains(testEmail));
    });
  });
}
