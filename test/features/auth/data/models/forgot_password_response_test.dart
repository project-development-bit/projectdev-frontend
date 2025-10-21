import 'package:flutter_test/flutter_test.dart';
import 'package:cointiply_app/features/auth/data/models/forgot_password_response.dart';

void main() {
  group('ForgotPasswordData', () {
    const testEmail = 'test@example.com';
    const testSecurityCode = 1234;
    
    test('should create instance with required parameters', () {
      // Arrange & Act
      const data = ForgotPasswordData(
        email: testEmail,
        securityCode: testSecurityCode,
      );
      
      // Assert
      expect(data.email, testEmail);
      expect(data.securityCode, testSecurityCode);
    });

    test('should convert to JSON correctly', () {
      // Arrange
      const data = ForgotPasswordData(
        email: testEmail,
        securityCode: testSecurityCode,
      );
      
      // Act
      final json = data.toJson();
      
      // Assert
      expect(json['email'], testEmail);
      expect(json['securityCode'], testSecurityCode);
      expect(json.keys.length, 2);
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'email': testEmail,
        'securityCode': testSecurityCode,
      };
      
      // Act
      final data = ForgotPasswordData.fromJson(json);
      
      // Assert
      expect(data.email, testEmail);
      expect(data.securityCode, testSecurityCode);
    });

    test('should implement equality correctly', () {
      // Arrange
      const data1 = ForgotPasswordData(email: testEmail, securityCode: testSecurityCode);
      const data2 = ForgotPasswordData(email: testEmail, securityCode: testSecurityCode);
      const data3 = ForgotPasswordData(email: 'different@example.com', securityCode: testSecurityCode);
      
      // Assert
      expect(data1, equals(data2));
      expect(data1, isNot(equals(data3)));
    });

    test('should implement hashCode correctly', () {
      // Arrange
      const data1 = ForgotPasswordData(email: testEmail, securityCode: testSecurityCode);
      const data2 = ForgotPasswordData(email: testEmail, securityCode: testSecurityCode);
      
      // Assert
      expect(data1.hashCode, equals(data2.hashCode));
    });
  });

  group('ForgotPasswordResponse', () {
    const testSuccess = true;
    const testMessage = 'Reset password is completed!';
    const testData = ForgotPasswordData(
      email: 'test@example.com',
      securityCode: 1234,
    );
    
    test('should create instance with required parameters', () {
      // Arrange & Act
      const response = ForgotPasswordResponse(
        success: testSuccess,
        message: testMessage,
        data: testData,
      );
      
      // Assert
      expect(response.success, testSuccess);
      expect(response.message, testMessage);
      expect(response.data, testData);
    });

    test('should convert to JSON correctly', () {
      // Arrange
      const response = ForgotPasswordResponse(
        success: testSuccess,
        message: testMessage,
        data: testData,
      );
      
      // Act
      final json = response.toJson();
      
      // Assert
      expect(json['success'], testSuccess);
      expect(json['message'], testMessage);
      expect(json['data'], isA<Map<String, dynamic>>());
      expect(json['data']['email'], testData.email);
      expect(json['data']['securityCode'], testData.securityCode);
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'success': testSuccess,
        'message': testMessage,
        'data': {
          'email': testData.email,
          'securityCode': testData.securityCode,
        },
      };
      
      // Act
      final response = ForgotPasswordResponse.fromJson(json);
      
      // Assert
      expect(response.success, testSuccess);
      expect(response.message, testMessage);
      expect(response.data.email, testData.email);
      expect(response.data.securityCode, testData.securityCode);
    });

    test('should create from API response JSON structure', () {
      // Arrange - This matches the expected API response format
      final json = {
        'success': true,
        'message': 'Reset password is completed!',
        'data': {
          'email': 'saizayarhtet7@gmail.com',
          'securityCode': 2912,
        },
      };
      
      // Act
      final response = ForgotPasswordResponse.fromJson(json);
      
      // Assert
      expect(response.success, true);
      expect(response.message, 'Reset password is completed!');
      expect(response.data.email, 'saizayarhtet7@gmail.com');
      expect(response.data.securityCode, 2912);
    });

    test('should implement equality correctly', () {
      // Arrange
      const response1 = ForgotPasswordResponse(success: testSuccess, message: testMessage, data: testData);
      const response2 = ForgotPasswordResponse(success: testSuccess, message: testMessage, data: testData);
      const response3 = ForgotPasswordResponse(success: false, message: testMessage, data: testData);
      
      // Assert
      expect(response1, equals(response2));
      expect(response1, isNot(equals(response3)));
    });

    test('should implement hashCode correctly', () {
      // Arrange
      const response1 = ForgotPasswordResponse(success: testSuccess, message: testMessage, data: testData);
      const response2 = ForgotPasswordResponse(success: testSuccess, message: testMessage, data: testData);
      
      // Assert
      expect(response1.hashCode, equals(response2.hashCode));
    });

    test('should have correct toString representation', () {
      // Arrange
      const response = ForgotPasswordResponse(success: testSuccess, message: testMessage, data: testData);
      
      // Act
      final stringRepresentation = response.toString();
      
      // Assert
      expect(stringRepresentation, contains('ForgotPasswordResponse'));
      expect(stringRepresentation, contains(testSuccess.toString()));
      expect(stringRepresentation, contains(testMessage));
    });
  });
}