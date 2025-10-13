import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/services/secure_storage_service.dart';
import 'package:cointiply_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:cointiply_app/features/auth/data/datasources/remote/auth_remote.dart';
import 'package:cointiply_app/features/auth/data/models/login_request.dart';
import 'package:cointiply_app/features/auth/data/models/login_response_model.dart';
import 'package:cointiply_app/features/auth/data/models/user_model.dart';
import 'package:cointiply_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:cointiply_app/features/auth/domain/entities/login_response.dart';
import 'package:cointiply_app/core/enum/user_role.dart';
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
      registerFallbackValue(const LoginRequest(email: '', password: ''));
    });

    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockSecureStorage = MockSecureStorageService();
      authRepository = AuthRepositoryImpl(mockRemoteDataSource, mockSecureStorage);
    });

    group('login', () {
      late LoginRequest loginRequest;
      late LoginResponseModel loginResponseModel;

      setUp(() {
        loginRequest = const LoginRequest(
          email: 'user8@gmail.com',
          password: '12345678',
        );

        loginResponseModel = LoginResponseModel(
          success: true,
          message: 'Login successful.',
          user: const UserModel(
            id: 11,
            name: 'User 7',
            email: 'user8@gmail.com',
            role: UserRole.normalUser,
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
            expect(loginResponse.user.id, 11);
            expect(loginResponse.user.email, 'user8@gmail.com');
            expect(loginResponse.user.role, UserRole.normalUser);
          },
        );

        verify(() => mockRemoteDataSource.login(loginRequest)).called(1);
        verify(() => mockSecureStorage.saveAuthToken(loginResponseModel.tokens.accessToken)).called(1);
        verify(() => mockSecureStorage.saveRefreshToken(loginResponseModel.tokens.refreshToken)).called(1);
        verify(() => mockSecureStorage.saveUserId(loginResponseModel.user.id.toString())).called(1);
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

      test('should return ServerFailure when unexpected error occurs', () async {
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
  });
}