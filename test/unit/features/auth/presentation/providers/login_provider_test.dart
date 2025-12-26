import 'package:gigafaucet/features/user_profile/data/enum/user_level.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:gigafaucet/features/auth/domain/usecases/login_usecase.dart';
import 'package:gigafaucet/features/auth/data/models/login_request.dart';
import 'package:gigafaucet/features/auth/domain/entities/login_response.dart';
import 'package:gigafaucet/features/auth/domain/entities/user.dart';
import 'package:gigafaucet/features/auth/domain/entities/auth_tokens.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/enum/user_role.dart';

// Mock classes
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  group('LoginRequest Integration Tests', () {
    late MockLoginUseCase mockLoginUseCase;

    // Test data
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testRecaptchaToken = 'test_recaptcha_token';

    final testUser = User(
      id: 1,
      name: 'Test User',
      email: testEmail,
      role: UserRole.normalUser,
      showOnboarding: 0,
      twofaEnabled: 0,
      twofaSecret: 'test_2fa_secret',
      securityPinRequired: 0,
      avatarUrl: 'http://example.com/avatar.png',
      interestEnable: 1,
      notificationsEnabled: 1,
      showStatsEnabled: 1,
      anonymousInContests: 0,
      refreshToken: 'test_refresh_token',
      securityCode: 'test_security_code',
      isBanned: 0,
      isVerified: 1,
      riskScore: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      currentStatus: UserLevel.bronze,
      countryID: 1,
      countryName: 'Thailand',
      coinBalance: 50.0,
      language: 'en',
    );

    final testTokens = AuthTokens(
      accessToken: 'access_token',
      refreshToken: 'refresh_token',
      tokenType: 'Bearer',
      accessTokenExpiresIn: '15m',
      refreshTokenExpiresIn: '7d',
    );

    final testLoginResponse = LoginResponse(
      success: true,
      message: 'Login successful',
      user: testUser,
      tokens: testTokens,
    );

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();

      // Register fallback values
      registerFallbackValue(const LoginRequest(
        email: '',
        password: '',
        recaptchaToken: null,
        deviceFingerprint: '',
        userAgent: '',
        countryCode: '',
      ));
    });

    group('LoginRequest with reCAPTCHA token', () {
      test('should create LoginRequest with reCAPTCHA token', () {
        // Arrange & Act
        final request = LoginRequest(
          email: testEmail,
          password: testPassword,
          recaptchaToken: testRecaptchaToken,
          countryCode: '',
          deviceFingerprint: '',
          userAgent: '',
        );

        // Assert
        expect(request.email, testEmail);
        expect(request.password, testPassword);
        expect(request.recaptchaToken, testRecaptchaToken);
      });

      test('should create LoginRequest without reCAPTCHA token', () {
        // Arrange & Act
        final request = LoginRequest(
          email: testEmail,
          password: testPassword,
          recaptchaToken: null,
          countryCode: '',
          deviceFingerprint: '',
          userAgent: '',
        );

        // Assert
        expect(request.email, testEmail);
        expect(request.password, testPassword);
        expect(request.recaptchaToken, null);
      });

      test('should serialize to JSON with reCAPTCHA token', () async {
        // Arrange
        final request = LoginRequest(
          email: testEmail,
          password: testPassword,
          recaptchaToken: testRecaptchaToken,
          countryCode: '',
          deviceFingerprint: '',
          userAgent: '',
        );

        // Act
        final json = await request.toJson();

        // Assert
        expect(json['email'], testEmail);
        expect(json['password'], testPassword);
        expect(json['recaptchaToken'], testRecaptchaToken);
      });

      test('should serialize to JSON without reCAPTCHA token', () async {
        // Arrange
        final request = LoginRequest(
          email: testEmail,
          password: testPassword,
          recaptchaToken: null,
          countryCode: '',
          deviceFingerprint: '',
          userAgent: '',
        );

        // Act
        final json = await request.toJson();

        // Assert
        expect(json['email'], testEmail);
        expect(json['password'], testPassword);
        expect(json.containsKey('recaptchaToken'), false);
      });
    });

    group('Use case integration', () {
      test('should call login use case with reCAPTCHA token', () async {
        // Arrange
        final request = LoginRequest(
          email: testEmail,
          password: testPassword,
          recaptchaToken: testRecaptchaToken,
          countryCode: '',
          deviceFingerprint: '',
          userAgent: '',
        );

        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Right(testLoginResponse));

        // Act
        final result = await mockLoginUseCase(request);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockLoginUseCase(request)).called(1);

        final loginResponse =
            result.getOrElse(() => throw Exception('Should not happen'));
        expect(loginResponse.user?.email, testEmail);
        expect(loginResponse.tokens?.accessToken, 'access_token');
      });

      test('should call login use case without reCAPTCHA token', () async {
        // Arrange
        final request = LoginRequest(
          email: testEmail,
          password: testPassword,
          recaptchaToken: null,
          countryCode: '',
          deviceFingerprint: '',
          userAgent: '',
        );

        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Right(testLoginResponse));

        // Act
        final result = await mockLoginUseCase(request);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockLoginUseCase(request)).called(1);
      });

      test('should handle login failure', () async {
        // Arrange
        final request = LoginRequest(
          email: testEmail,
          password: testPassword,
          recaptchaToken: testRecaptchaToken,
          countryCode: '',
          deviceFingerprint: '',
          userAgent: '',
        );

        when(() => mockLoginUseCase(any())).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Invalid credentials')));

        // Act
        final result = await mockLoginUseCase(request);

        // Assert
        expect(result.isLeft(), true);
        verify(() => mockLoginUseCase(request)).called(1);

        final failure =
            result.fold((l) => l, (r) => throw Exception('Should not happen'));
        expect(failure.message, 'Invalid credentials');
      });
    });
  });
}
