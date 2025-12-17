import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/services/secure_storage_service.dart';
import 'package:gigafaucet/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:gigafaucet/features/auth/data/datasources/remote/auth_remote.dart';
import 'package:gigafaucet/features/auth/data/models/login_request.dart';
import 'package:gigafaucet/features/auth/data/models/login_response_model.dart';
import 'package:gigafaucet/features/auth/data/models/user_model.dart';
import 'package:gigafaucet/features/auth/data/models/auth_tokens_model.dart';
import 'package:gigafaucet/features/auth/data/models/resend_code_request.dart';
import 'package:gigafaucet/features/auth/data/models/resend_code_response.dart';
import 'package:gigafaucet/features/auth/data/models/verify_code_request.dart';
import 'package:gigafaucet/features/auth/data/models/verify_code_response.dart';
import 'package:gigafaucet/features/auth/domain/entities/login_response.dart';
import 'package:gigafaucet/core/enum/user_role.dart';
import 'package:gigafaucet/features/user_profile/data/enum/user_level.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl authRepository;
    late MockAuthRemoteDataSource mockRemoteDataSource;
    late MockSecureStorageService mockSecureStorage;

    setUpAll(() {
      registerFallbackValue(const LoginRequest(
          email: '',
          password: '',
          recaptchaToken: null,
          deviceFingerprint: '',
          userAgent: '',
          countryCode: ''));
      registerFallbackValue(const ResendCodeRequest(email: ''));
      registerFallbackValue(const VerifyCodeRequest(email: '', code: ''));
    });

    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockSecureStorage = MockSecureStorageService();
      authRepository =
          AuthRepositoryImpl(mockRemoteDataSource, mockSecureStorage);
    });

    group('login', () {
      late LoginRequest loginRequest;
      late LoginResponseModel loginResponseModel;

      setUp(() {
        loginRequest = const LoginRequest(
          email: 'user8@gmail.com',
          password: '12345678',
          recaptchaToken: 'test_recaptcha_token', // Add test token
          countryCode: 'US',
          userAgent: 'user-agent-string',
          deviceFingerprint: 'device-123',
        );

        loginResponseModel = LoginResponseModel(
          success: true,
          message: 'Login successful.',
          user: UserModel(
            id: 11,
            name: 'User 7',
            email: 'user8@gmail.com',
            role: UserRole.normalUser,
            showOnboarding: 0,
            refreshToken: '',
            securityCode: '',
            isBanned: 0,
            isVerified: 1,
            riskScore: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            twofaSecret: '',
            twofaEnabled: 0,
            securityPinEnabled: 0,
            avatarUrl: '',
            interestEnable: 0,
            notificationsEnabled: 0,
            showStatsEnabled: 0,
            anonymousInContests: 0,
            currentStatus: UserLevel.bronze,
            countryID: 1,
            countryName: 'Thailand',
            coinBalance: 50.0,
            language: 'en',
          ),
          tokens: const AuthTokensModel(
            accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            tokenType: 'Bearer',
            accessTokenExpiresIn: '15m',
            refreshTokenExpiresIn: '7d',
          ),
        );
      });

      test('should return LoginResponse when login is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.login(loginRequest))
            .thenAnswer((_) async => loginResponseModel);
        when(() => mockSecureStorage.saveAuthToken(any()))
            .thenAnswer((_) async {});
        when(() => mockSecureStorage.saveRefreshToken(any()))
            .thenAnswer((_) async {});
        when(() => mockSecureStorage.saveUserId(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await authRepository.login(loginRequest);

        // Assert
        expect(result, isA<Right<Failure, LoginResponse>>());

        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (loginResponse) {
            expect(loginResponse.success, true);
            expect(loginResponse.message, 'Login successful.');
            expect(loginResponse.user?.id, 11);
            expect(loginResponse.user?.email, 'user8@gmail.com');
            expect(loginResponse.user?.role, UserRole.normalUser);
          },
        );

        verify(() => mockRemoteDataSource.login(loginRequest)).called(1);
        verify(() => mockSecureStorage.saveAuthToken(
            loginResponseModel.tokens?.accessToken ?? '')).called(1);
        verify(() => mockSecureStorage.saveRefreshToken(
            loginResponseModel.tokens?.refreshToken ?? '')).called(1);
        verify(() => mockSecureStorage.saveUserId(
            loginResponseModel.user?.id.toString() ?? '')).called(1);
      });

      test('should return ServerFailure when DioException occurs', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 401,
            data: {'message': 'Invalid credentials'},
          ),
          message: 'Invalid credentials',
        );

        when(() => mockRemoteDataSource.login(loginRequest))
            .thenThrow(dioException);

        // Act
        final result = await authRepository.login(loginRequest);

        // Assert
        expect(result, isA<Left<Failure, LoginResponse>>());

        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, 'Invalid credentials');
            expect((failure as ServerFailure).statusCode, 401);
          },
          (loginResponse) => fail('Expected Left, got Right: $loginResponse'),
        );

        verify(() => mockRemoteDataSource.login(loginRequest)).called(1);
        verifyNever(() => mockSecureStorage.saveAuthToken(any()));
        verifyNever(() => mockSecureStorage.saveRefreshToken(any()));
        verifyNever(() => mockSecureStorage.saveUserId(any()));
      });

      test('should return ServerFailure when unexpected error occurs',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.login(loginRequest))
            .thenThrow(Exception('Network error'));

        // Act
        final result = await authRepository.login(loginRequest);

        // Assert
        expect(result, isA<Left<Failure, LoginResponse>>());

        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('Exception: Network error'));
          },
          (loginResponse) => fail('Expected Left, got Right: $loginResponse'),
        );
      });
    });

    group('logout', () {
      test('should clear all auth data when logout is successful', () async {
        // Arrange
        when(() => mockSecureStorage.clearAllAuthData())
            .thenAnswer((_) async {});

        // Act
        final result = await authRepository.logout();

        // Assert
        expect(result, isA<Right<Failure, void>>());
        verify(() => mockSecureStorage.clearAllAuthData()).called(1);
      });

      test('should return ServerFailure when logout fails', () async {
        // Arrange
        when(() => mockSecureStorage.clearAllAuthData())
            .thenThrow(Exception('Storage error'));

        // Act
        final result = await authRepository.logout();

        // Assert
        expect(result, isA<Left<Failure, void>>());

        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('Exception: Storage error'));
          },
          (_) => fail('Expected Left, got Right'),
        );
      });
    });

    group('isAuthenticated', () {
      test('should return true when access token exists', () async {
        // Arrange
        when(() => mockSecureStorage.getAuthToken())
            .thenAnswer((_) async => 'valid_token');

        // Act
        final result = await authRepository.isAuthenticated();

        // Assert
        expect(result, isA<Right<Failure, bool>>());

        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (isAuthenticated) => expect(isAuthenticated, true),
        );
      });

      test('should return false when access token is null', () async {
        // Arrange
        when(() => mockSecureStorage.getAuthToken())
            .thenAnswer((_) async => null);

        // Act
        final result = await authRepository.isAuthenticated();

        // Assert
        expect(result, isA<Right<Failure, bool>>());

        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (isAuthenticated) => expect(isAuthenticated, false),
        );
      });

      test('should return false when access token is empty', () async {
        // Arrange
        when(() => mockSecureStorage.getAuthToken())
            .thenAnswer((_) async => '');

        // Act
        final result = await authRepository.isAuthenticated();

        // Assert
        expect(result, isA<Right<Failure, bool>>());

        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (isAuthenticated) => expect(isAuthenticated, false),
        );
      });
    });

    group('resendCode', () {
      late ResendCodeRequest resendCodeRequest;
      late ResendCodeResponse resendCodeResponse;

      setUp(() {
        resendCodeRequest = const ResendCodeRequest(email: 'test@example.com');
        resendCodeResponse = const ResendCodeResponse(
          success: true,
          message: 'Verification code sent successfully',
          data: ResendCodeData(
            email: 'test@example.com',
            securityCode: 1234,
          ),
        );
      });

      test('should return Right when resend code succeeds', () async {
        // Arrange
        when(() => mockRemoteDataSource.resendCode(any()))
            .thenAnswer((_) async => resendCodeResponse);

        // Act
        final result = await authRepository.resendCode(resendCodeRequest);

        // Assert
        expect(result, isA<Right<Failure, ResendCodeResponse>>());

        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (response) {
            expect(response.success, true);
            expect(response.message, 'Verification code sent successfully');
          },
        );

        verify(() => mockRemoteDataSource.resendCode(resendCodeRequest))
            .called(1);
      });

      test('should return Left when resend code fails with DioException',
          () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Email not found',
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
          ),
        );

        when(() => mockRemoteDataSource.resendCode(any()))
            .thenThrow(dioException);

        // Act
        final result = await authRepository.resendCode(resendCodeRequest);

        // Assert
        expect(result, isA<Left<Failure, ResendCodeResponse>>());

        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, 'Email not found');
            expect((failure as ServerFailure).statusCode, 404);
          },
          (response) => fail('Expected Left, got Right: $response'),
        );
      });

      test('should return Left when resend code fails with generic exception',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.resendCode(any()))
            .thenThrow(Exception('Network error'));

        // Act
        final result = await authRepository.resendCode(resendCodeRequest);

        // Assert
        expect(result, isA<Left<Failure, ResendCodeResponse>>());

        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('Exception: Network error'));
          },
          (response) => fail('Expected Left, got Right: $response'),
        );
      });
    });

    group('verifyCode', () {
      late VerifyCodeRequest verifyCodeRequest;
      late VerifyCodeResponse verifyCodeResponse;

      setUp(() {
        verifyCodeRequest = const VerifyCodeRequest(
          email: 'test@example.com',
          code: '1234',
        );

        verifyCodeResponse = const VerifyCodeResponse(
          success: true,
          message: 'Verified successfully.',
          data: VerifyCodeData(
            user: User(
              id: 23,
              name: 'Test User',
              email: 'test@example.com',
              role: 'NormalUser',
            ),
            tokens: Tokens(
              accessToken: 'access-token-123',
              refreshToken: 'refresh-token-123',
              tokenType: 'Bearer',
              accessTokenExpiresIn: '15m',
              refreshTokenExpiresIn: '7d',
            ),
          ),
        );
      });

      test('should return Right and store tokens when verification succeeds',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.verifyCode(any()))
            .thenAnswer((_) async => verifyCodeResponse);

        when(() => mockSecureStorage.saveAuthToken(any()))
            .thenAnswer((_) async {});
        when(() => mockSecureStorage.saveRefreshToken(any()))
            .thenAnswer((_) async {});
        when(() => mockSecureStorage.saveUserId(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await authRepository.verifyCode(verifyCodeRequest);

        // Assert
        expect(result, isA<Right<Failure, VerifyCodeResponse>>());

        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (response) {
            expect(response.success, true);
            expect(response.message, 'Verified successfully.');
            expect(response.data?.user.id, 23);
            expect(response.data?.tokens.tokenType, 'Bearer');
          },
        );

        verify(() => mockRemoteDataSource.verifyCode(verifyCodeRequest))
            .called(1);
        verify(() => mockSecureStorage.saveAuthToken('access-token-123'))
            .called(1);
        verify(() => mockSecureStorage.saveRefreshToken('refresh-token-123'))
            .called(1);
        verify(() => mockSecureStorage.saveUserId('23')).called(1);
      });

      test(
          'should return Right without storing tokens when verification succeeds but has no data',
          () async {
        // Arrange
        final responseWithoutData = const VerifyCodeResponse(
          success: true,
          message: 'Verified successfully.',
          data: null,
        );

        when(() => mockRemoteDataSource.verifyCode(any()))
            .thenAnswer((_) async => responseWithoutData);

        // Act
        final result = await authRepository.verifyCode(verifyCodeRequest);

        // Assert
        expect(result, isA<Right<Failure, VerifyCodeResponse>>());

        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (response) {
            expect(response.success, true);
            expect(response.data, null);
          },
        );

        verify(() => mockRemoteDataSource.verifyCode(verifyCodeRequest))
            .called(1);
        verifyNever(() => mockSecureStorage.saveAuthToken(any()));
        verifyNever(() => mockSecureStorage.saveRefreshToken(any()));
        verifyNever(() => mockSecureStorage.saveUserId(any()));
      });

      test('should return Left when verification fails with DioException',
          () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Invalid verification code',
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 400,
          ),
        );

        when(() => mockRemoteDataSource.verifyCode(any()))
            .thenThrow(dioException);

        // Act
        final result = await authRepository.verifyCode(verifyCodeRequest);

        // Assert
        expect(result, isA<Left<Failure, VerifyCodeResponse>>());

        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, 'Invalid verification code');
            expect((failure as ServerFailure).statusCode, 400);
          },
          (response) => fail('Expected Left, got Right: $response'),
        );

        verifyNever(() => mockSecureStorage.saveAuthToken(any()));
        verifyNever(() => mockSecureStorage.saveRefreshToken(any()));
        verifyNever(() => mockSecureStorage.saveUserId(any()));
      });

      test('should return Left when verification fails with generic exception',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.verifyCode(any()))
            .thenThrow(Exception('Network error'));

        // Act
        final result = await authRepository.verifyCode(verifyCodeRequest);

        // Assert
        expect(result, isA<Left<Failure, VerifyCodeResponse>>());

        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('Exception: Network error'));
          },
          (response) => fail('Expected Left, got Right: $response'),
        );

        verifyNever(() => mockSecureStorage.saveAuthToken(any()));
        verifyNever(() => mockSecureStorage.saveRefreshToken(any()));
        verifyNever(() => mockSecureStorage.saveUserId(any()));
      });
    });
  });
}
