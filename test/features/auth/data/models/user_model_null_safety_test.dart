import 'package:flutter_test/flutter_test.dart';
import 'package:gigafaucet/features/auth/data/models/user_model.dart';
import 'package:gigafaucet/core/enum/user_role.dart';

void main() {
  group('UserModel Null Safety Tests', () {
    test('should handle null values in JSON gracefully', () {
      // Arrange - JSON with null values
      final Map<String, dynamic> jsonWithNulls = {
        'id': null,
        'name': null,
        'email': null,
        'role': null,
        'refresh_token': null,
        'security_code': null,
        'is_banned': null,
        'is_verified': null,
        'risk_score': null,
        'created_at': null,
        'updated_at': null,
      };

      // Act - Should not throw exception
      final userModel = UserModel.fromJson(jsonWithNulls);

      // Assert - Should use all fallback values
      expect(userModel.id, equals(0));
      expect(userModel.name, equals(''));
      expect(userModel.email, equals(''));
      expect(userModel.role, equals(UserRole.normalUser));
      expect(userModel.refreshToken, equals(''));
      expect(userModel.securityCode, equals(''));
      expect(userModel.isBanned, equals(0));
      expect(userModel.isVerified, equals(0));
      expect(userModel.riskScore, equals(0));
      expect(userModel.createdAt, isNotNull);
      expect(userModel.updatedAt, isNotNull);
    });

    test('should handle string ID values', () {
      // Arrange - JSON with string ID
      final Map<String, dynamic> jsonWithStringId = {
        'id': '123',
        'name': 'Test User',
        'email': 'test@example.com',
        'role': 'admin',
        'refresh_token': 'test_refresh_token',
        'security_code': 'SEC123',
        'is_banned': 0,
        'is_verified': 1,
        'risk_score': 50,
        'created_at': '2023-01-01T00:00:00.000000Z',
        'updated_at': '2023-01-01T00:00:00.000000Z',
      };

      // Act
      final userModel = UserModel.fromJson(jsonWithStringId);

      // Assert
      expect(userModel.id, equals(123));
      expect(userModel.name, equals('Test User'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.role, equals(UserRole.admin));
    });

    test('should handle int ID values', () {
      // Arrange - JSON with int ID
      final Map<String, dynamic> jsonWithIntId = {
        'id': 456,
        'name': 'Another User',
        'email': 'another@example.com',
        'role': 'normalUser',
        'refresh_token': 'another_refresh_token',
        'security_code': 'SEC456',
        'is_banned': 0,
        'is_verified': 0,
        'risk_score': 25,
        'created_at': '2023-01-01T00:00:00.000000Z',
        'updated_at': '2023-01-01T00:00:00.000000Z',
      };

      // Act
      final userModel = UserModel.fromJson(jsonWithIntId);

      // Assert
      expect(userModel.id, equals(456));
      expect(userModel.name, equals('Another User'));
      expect(userModel.email, equals('another@example.com'));
      expect(userModel.role, equals(UserRole.normalUser));
    });

    test('should handle invalid date strings gracefully', () {
      // Arrange - JSON with invalid date strings
      final Map<String, dynamic> jsonWithInvalidDates = {
        'id': 789,
        'name': 'Date Test User',
        'email': 'datetest@example.com',
        'role': 'normalUser',
        'refresh_token': 'date_test_token',
        'security_code': 'SEC789',
        'is_banned': 0,
        'is_verified': 1,
        'risk_score': 75,
        'created_at': 'also-invalid',
        'updated_at': 'not-a-date',
      };

      // Act
      final userModel = UserModel.fromJson(jsonWithInvalidDates);

      // Assert - Should use current time as fallback
      expect(userModel.id, equals(789));
      expect(userModel.name, equals('Date Test User'));
      expect(userModel.email, equals('datetest@example.com'));
      expect(userModel.role, equals(UserRole.normalUser));
      expect(userModel.createdAt, isNotNull);
      expect(userModel.updatedAt, isNotNull);
    });

    test('should handle empty JSON object', () {
      // Arrange - Empty JSON
      final Map<String, dynamic> emptyJson = {};

      // Act
      final userModel = UserModel.fromJson(emptyJson);

      // Assert - Should use all fallback values
      expect(userModel.id, equals(0));
      expect(userModel.name, equals(''));
      expect(userModel.email, equals(''));
      expect(userModel.role, equals(UserRole.normalUser));
      expect(userModel.refreshToken, equals(''));
      expect(userModel.securityCode, equals(''));
      expect(userModel.isBanned, equals(0));
      expect(userModel.isVerified, equals(0));
      expect(userModel.riskScore, equals(0));
      expect(userModel.createdAt, isNotNull);
      expect(userModel.updatedAt, isNotNull);
    });

    test('should handle mixed valid and invalid values', () {
      // Arrange - JSON with mixed valid/invalid values
      final Map<String, dynamic> mixedJson = {
        'id': '999', // valid string ID
        'name': 'Mixed User', // valid string
        'email': null, // null email
        'role': '', // empty role (should use fallback)
        'refresh_token': 'valid_token',
        'security_code': null, // null security code
        'is_banned': null, // null boolean
        'is_verified': true, // valid boolean
        'risk_score': '88', // string number
        'created_at': null, // null date
        'updated_at': 'invalid-date', // invalid date
      };

      // Act
      final userModel = UserModel.fromJson(mixedJson);

      // Assert
      expect(userModel.id, equals(999));
      expect(userModel.name, equals('Mixed User'));
      expect(userModel.email, equals('')); // null becomes empty string
      expect(userModel.role,
          equals(UserRole.normalUser)); // empty string uses fallback
      expect(userModel.refreshToken, equals('valid_token'));
      expect(userModel.securityCode, equals('')); // null uses fallback
      expect(userModel.isBanned, equals(0)); // null uses fallback
      expect(userModel.isVerified, equals(1)); // valid boolean converted to int
      expect(userModel.riskScore, equals(88)); // string parsed to int
      expect(userModel.createdAt, isNotNull); // null uses current time
      expect(userModel.updatedAt, isNotNull); // invalid date uses current time
    });
  });
}
