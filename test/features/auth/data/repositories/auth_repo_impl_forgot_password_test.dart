import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/services/secure_storage_service.dart';
import 'package:cointiply_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:cointiply_app/features/auth/data/datasources/remote/auth_remote.dart';
import 'package:cointiply_app/features/auth/data/models/forgot_password_request.dart';
import 'package:cointiply_app/features/auth/data/models/forgot_password_response.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  group('AuthRepositoryImpl - Forgot Password', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDataSource mockRemoteDataSource;
    late MockSecureStorageService mockSecureStorage;

    setUpAll(() {
      registerFallbackValue(const ForgotPasswordRequest(email: ''));
    });

    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockSecureStorage = MockSecureStorageService();
      repository = AuthRepositoryImpl(mockRemoteDataSource, mockSecureStorage);
    });

    const testEmail = 'test@example.com';
    const testRequest = ForgotPasswordRequest(email: testEmail);
    const testResponseData = ForgotPasswordData(
      email: testEmail,
      securityCode: 1234,
    );
    const testResponse = ForgotPasswordResponse(
      success: true,
      message: 'Reset password is completed!',
      data: testResponseData,
    );

    group('forgotPassword', () {
      test('should return ForgotPasswordResponse when remote call is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.forgotPassword(testRequest))
            .thenAnswer((_) async => testResponse);

        // Act
        final result = await repository.forgotPassword(testRequest);

        // Assert
        expect(result, equals(const Right(testResponse)));
        verify(() => mockRemoteDataSource.forgotPassword(testRequest)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return ServerFailure when DioException occurs', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          message: 'Network error',
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
          ),
        );
        
        when(() => mockRemoteDataSource.forgotPassword(testRequest))
            .thenThrow(dioException);

        // Act
        final result = await repository.forgotPassword(testRequest);

        // Assert
        expect(result, isA<Left<Failure, ForgotPasswordResponse>>());
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect((failure as ServerFailure).message, 'Network error');
            expect(failure.statusCode, 500);
          },
          (response) => fail('Should return failure'),
        );
        verify(() => mockRemoteDataSource.forgotPassword(testRequest)).called(1);
      });

      test('should return ServerFailure with ErrorModel when DioException has response data', () async {
        // Arrange
        final errorResponseData = {
          'message': 'User not found',
          'code': 'USER_NOT_FOUND',
        };
        
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          message: 'User not found',
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 404,
            data: errorResponseData,
          ),
        );
        
        when(() => mockRemoteDataSource.forgotPassword(testRequest))
            .thenThrow(dioException);

        // Act
        final result = await repository.forgotPassword(testRequest);

        // Assert
        expect(result, isA<Left<Failure, ForgotPasswordResponse>>());
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect((failure as ServerFailure).message, 'User not found');
            expect(failure.statusCode, 404);
            expect(failure.errorModel, isNotNull);
          },
          (response) => fail('Should return failure'),
        );
      });

      test('should return ServerFailure when generic exception occurs', () async {
        // Arrange
        const exception = 'Unexpected error';
        when(() => mockRemoteDataSource.forgotPassword(testRequest))
            .thenThrow(exception);

        // Act
        final result = await repository.forgotPassword(testRequest);

        // Assert
        expect(result, isA<Left<Failure, ForgotPasswordResponse>>());
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect((failure as ServerFailure).message, exception);
          },
          (response) => fail('Should return failure'),
        );
        verify(() => mockRemoteDataSource.forgotPassword(testRequest)).called(1);
      });

      test('should handle different email formats correctly', () async {
        // Arrange
        const testCases = [
          'user@domain.com',
          'user.name@domain.co.uk',
          'user+tag@domain.org',
          'user123@test-domain.com',
        ];

        for (final email in testCases) {
          final request = ForgotPasswordRequest(email: email);
          final response = ForgotPasswordResponse(
            success: true,
            message: 'Reset password is completed!',
            data: ForgotPasswordData(email: email, securityCode: 1234),
          );

          when(() => mockRemoteDataSource.forgotPassword(request))
              .thenAnswer((_) async => response);

          // Act
          final result = await repository.forgotPassword(request);

          // Assert
          expect(result, equals(Right(response)));
          verify(() => mockRemoteDataSource.forgotPassword(request)).called(1);
        }
      });

      test('should handle API response with different security codes', () async {
        // Arrange
        const securityCodes = [1234, 5678, 9999, 0000];
        
        for (final code in securityCodes) {
          final response = ForgotPasswordResponse(
            success: true,
            message: 'Reset password is completed!',
            data: ForgotPasswordData(email: testEmail, securityCode: code),
          );

          when(() => mockRemoteDataSource.forgotPassword(testRequest))
              .thenAnswer((_) async => response);

          // Act
          final result = await repository.forgotPassword(testRequest);

          // Assert
          expect(result, equals(Right(response)));
          result.fold(
            (failure) => fail('Should return success'),
            (response) {
              expect(response.data.securityCode, code);
            },
          );
        }
      });
    });
  });
}