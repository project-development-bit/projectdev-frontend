import 'package:cointiply_app/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:cointiply_app/features/auth/presentation/providers/reset_password_provider.dart';
import 'package:cointiply_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:cointiply_app/features/auth/domain/entities/login_response.dart';
import 'package:cointiply_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/enum/user_role.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ResetPasswordProvider', () {
    late MockAuthRepository mockAuthRepository;
    late ProviderContainer container;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          resetPasswordProvider.overrideWith(
            (ref) => ResetPasswordNotifier(mockAuthRepository),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testConfirmPassword = 'password123';

    final testUser = UserModel(
      id: 1,
      name: 'Test User',
      email: testEmail,
      role: UserRole.normalUser,
      showOnboarding: 0,
      refreshToken: 'refresh_token',
      twofaEnabled: 0,
      twofaSecret: 'twofa_secret',
      securityPinEnabled: 0,
      avatarUrl: 'http://example.com/avatar.png',
      interestEnable: 1,
      notificationsEnabled: 1,
      showStatsEnabled: 1,
      anonymousInContests: 0,
      securityCode: 'security_code',
      isBanned: 0,
      isVerified: 1,
      riskScore: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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
      message: 'Password was saved successfully!',
      user: testUser,
      tokens: testTokens,
    );

    test('initial state should be ResetPasswordInitial', () {
      // Act
      final state = container.read(resetPasswordProvider);

      // Assert
      expect(state, isA<ResetPasswordInitial>());
    });

    test('should emit loading and success states when reset password succeeds',
        () async {
      // Arrange
      when(() => mockAuthRepository.resetPassword(any()))
          .thenAnswer((_) async => Right(testLoginResponse));

      final notifier = container.read(resetPasswordProvider.notifier);
      final states = <ResetPasswordState>[];

      // Listen to state changes
      container.listen<ResetPasswordState>(
        resetPasswordProvider,
        (previous, next) => states.add(next),
        fireImmediately: true,
      );

      // Act
      await notifier.resetPassword(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(states, [
        isA<ResetPasswordInitial>(),
        isA<ResetPasswordLoading>(),
        isA<ResetPasswordSuccess>(),
      ]);

      final successState = states.last as ResetPasswordSuccess;
      expect(successState.response.user?.email, testEmail);
    });

    test('should emit loading and error states when reset password fails',
        () async {
      // Arrange
      const errorMessage = 'Invalid email or password';
      when(() => mockAuthRepository.resetPassword(any()))
          .thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));

      final notifier = container.read(resetPasswordProvider.notifier);
      final states = <ResetPasswordState>[];

      container.listen<ResetPasswordState>(
        resetPasswordProvider,
        (previous, next) => states.add(next),
        fireImmediately: true,
      );

      // Act
      await notifier.resetPassword(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(states, [
        isA<ResetPasswordInitial>(),
        isA<ResetPasswordLoading>(),
        isA<ResetPasswordError>(),
      ]);

      final errorState = states.last as ResetPasswordError;
      expect(errorState.message, errorMessage);
    });

    test('should validate invalid email format', () async {
      // Arrange
      const invalidEmail = 'invalid-email';
      final notifier = container.read(resetPasswordProvider.notifier);

      // Act
      await notifier.resetPassword(
        email: invalidEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      final state = container.read(resetPasswordProvider);
      expect(state, isA<ResetPasswordError>());
      final errorState = state as ResetPasswordError;
      expect(errorState.message, 'Please enter a valid email address');
    });

    test('should validate password requirements', () async {
      // Arrange
      const shortPassword = '123';
      final notifier = container.read(resetPasswordProvider.notifier);

      // Act
      await notifier.resetPassword(
        email: testEmail,
        password: shortPassword,
        confirmPassword: shortPassword,
      );

      // Assert
      final state = container.read(resetPasswordProvider);
      expect(state, isA<ResetPasswordError>());
      final errorState = state as ResetPasswordError;
      expect(errorState.message, 'Password must be at least 8 characters long');
    });

    test('should validate password confirmation match', () async {
      // Arrange
      const differentConfirmPassword = 'differentpassword';
      final notifier = container.read(resetPasswordProvider.notifier);

      // Act
      await notifier.resetPassword(
        email: testEmail,
        password: testPassword,
        confirmPassword: differentConfirmPassword,
      );

      // Assert
      final state = container.read(resetPasswordProvider);
      expect(state, isA<ResetPasswordError>());
      final errorState = state as ResetPasswordError;
      expect(errorState.message, 'Passwords do not match');
    });

    test('should validate empty fields', () async {
      // Arrange
      final notifier = container.read(resetPasswordProvider.notifier);

      // Act & Assert - Empty email
      await notifier.resetPassword(
        email: '',
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      ResetPasswordState state = container.read(resetPasswordProvider);
      expect(state, isA<ResetPasswordError>());
      ResetPasswordError errorState = state as ResetPasswordError;
      expect(errorState.message, 'Please enter a valid email address');

      // Reset state
      notifier.reset();

      // Act & Assert - Empty password
      await notifier.resetPassword(
        email: testEmail,
        password: '',
        confirmPassword: testConfirmPassword,
      );

      state = container.read(
          resetPasswordProvider as ProviderListenable<ResetPasswordError>);
      expect(state, isA<ResetPasswordError>());
      errorState = state;
      expect(errorState.message, 'Please enter a password');

      // Reset state
      notifier.reset();

      // Act & Assert - Empty confirm password
      await notifier.resetPassword(
        email: testEmail,
        password: testPassword,
        confirmPassword: '',
      );

      state = container.read(
          resetPasswordProvider as ProviderListenable<ResetPasswordError>);
      expect(state, isA<ResetPasswordError>());
      errorState = state;
      expect(errorState.message, 'Please confirm your password');
    });

    test('should reset state to initial', () {
      // Arrange
      final notifier = container.read(resetPasswordProvider.notifier);
      container.read(resetPasswordProvider.notifier).state =
          ResetPasswordError('Some error');

      // Act
      notifier.reset();

      // Assert
      final state = container.read(resetPasswordProvider);
      expect(state, isA<ResetPasswordInitial>());
    });

    test('should handle server-specific error messages', () async {
      // Arrange
      when(() => mockAuthRepository.resetPassword(any()))
          .thenAnswer((_) async => Left(ServerFailure(
                message: 'email not found',
                statusCode: 404,
              )));

      final notifier = container.read(resetPasswordProvider.notifier);

      // Act
      await notifier.resetPassword(
        email: testEmail,
        password: testPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      final state = container.read(resetPasswordProvider);
      expect(state, isA<ResetPasswordError>());
      final errorState = state as ResetPasswordError;
      expect(errorState.message, 'Email not found in our system');
      expect(errorState.statusCode, 404);
    });

    test('should handle different HTTP status codes', () async {
      // Test cases for different status codes
      final testCases = [
        (400, 'Invalid request. Please check your input'),
        (401, 'Unauthorized. Please verify your email first'),
        (429, 'Too many requests. Please wait and try again'),
        (500, 'Server error. Please try again later'),
      ];

      for (final (statusCode, expectedMessage) in testCases) {
        // Arrange
        when(() => mockAuthRepository.resetPassword(any()))
            .thenAnswer((_) async => Left(ServerFailure(
                  message: 'Generic error',
                  statusCode: statusCode,
                )));

        final notifier = container.read(resetPasswordProvider.notifier);

        // Act
        await notifier.resetPassword(
          email: testEmail,
          password: testPassword,
          confirmPassword: testConfirmPassword,
        );

        // Assert
        final state = container.read(resetPasswordProvider);
        expect(state, isA<ResetPasswordError>());
        final errorState = state as ResetPasswordError;
        expect(errorState.message, expectedMessage);
        expect(errorState.statusCode, statusCode);

        // Reset for next test
        notifier.reset();
      }
    });

    group('Convenience Providers', () {
      test('isResetPasswordLoadingProvider should return correct loading state',
          () {
        // Arrange
        container.read(resetPasswordProvider.notifier).state =
            ResetPasswordLoading();

        // Act
        final isLoading = container.read(isResetPasswordLoadingProvider);

        // Assert
        expect(isLoading, isTrue);
      });

      test('resetPasswordErrorProvider should return error message', () {
        // Arrange
        const errorMessage = 'Test error';
        container.read(resetPasswordProvider.notifier).state =
            ResetPasswordError(errorMessage);

        // Act
        final error = container.read(resetPasswordErrorProvider);

        // Assert
        expect(error, errorMessage);
      });

      test('resetPasswordSuccessProvider should return success response', () {
        // Arrange
        container.read(resetPasswordProvider.notifier).state =
            ResetPasswordSuccess(testLoginResponse);

        // Act
        final response = container.read(resetPasswordSuccessProvider);

        // Assert
        expect(response, equals(testLoginResponse));
      });
    });
  });
}
