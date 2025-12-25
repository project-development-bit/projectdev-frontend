import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/auth/data/models/resend_code_request.dart';
import 'package:gigafaucet/features/auth/data/models/resend_code_response.dart';
import 'package:gigafaucet/features/auth/domain/repositories/auth_repository.dart';
import 'package:gigafaucet/features/auth/domain/usecases/resend_code_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ResendCodeUseCase', () {
    late ResendCodeUseCase useCase;
    late MockAuthRepository mockRepository;

    setUpAll(() {
      registerFallbackValue(const ResendCodeRequest(email: ''));
    });

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = ResendCodeUseCase(mockRepository);
    });

    test('should return ResendCodeResponse when repository call succeeds',
        () async {
      // Arrange
      const request = ResendCodeRequest(email: 'test@example.com');

      const expectedResponse = ResendCodeResponse(
        success: true,
        message: 'Verification code sent successfully',
        data: ResendCodeData(
          email: 'test@example.com',
          securityCode: 1234,
        ),
      );

      when(() => mockRepository.resendCode(any()))
          .thenAnswer((_) async => const Right(expectedResponse));

      // Act
      final result = await useCase(request);

      // Assert
      expect(result, isA<Right<Failure, ResendCodeResponse>>());

      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (response) {
          expect(response.success, true);
          expect(response.message, 'Verification code sent successfully');
          expect(response.data.email, 'test@example.com');
          expect(response.data.securityCode, 1234);
        },
      );

      verify(() => mockRepository.resendCode(request)).called(1);
    });

    test('should return Failure when repository call fails', () async {
      // Arrange
      const request = ResendCodeRequest(email: 'nonexistent@example.com');

      final expectedFailure = ServerFailure(
        message: 'Email not found',
        statusCode: 404,
      );

      when(() => mockRepository.resendCode(any()))
          .thenAnswer((_) async => Left(expectedFailure));

      // Act
      final result = await useCase(request);

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

      verify(() => mockRepository.resendCode(request)).called(1);
    });

    test('should pass the correct request to repository', () async {
      // Arrange
      const request = ResendCodeRequest(email: 'user@test.com');

      const expectedResponse = ResendCodeResponse(
        success: true,
        message: 'Code sent',
        data: ResendCodeData(
          email: 'user@test.com',
          securityCode: 5678,
        ),
      );

      when(() => mockRepository.resendCode(any()))
          .thenAnswer((_) async => const Right(expectedResponse));

      // Act
      await useCase(request);

      // Assert
      verify(() => mockRepository.resendCode(request)).called(1);
    });

    test('should handle network failures correctly', () async {
      // Arrange
      const request = ResendCodeRequest(email: 'test@example.com');

      final networkFailure = ServerFailure(
        message: 'Network error',
        statusCode: null,
      );

      when(() => mockRepository.resendCode(any()))
          .thenAnswer((_) async => Left(networkFailure));

      // Act
      final result = await useCase(request);

      // Assert
      expect(result, isA<Left<Failure, ResendCodeResponse>>());

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Network error');
        },
        (response) => fail('Expected Left, got Right: $response'),
      );
    });

    test('should handle validation failures correctly', () async {
      // Arrange
      const request = ResendCodeRequest(email: 'invalid-email');

      final validationFailure = ServerFailure(
        message: 'Invalid email format',
        statusCode: 400,
      );

      when(() => mockRepository.resendCode(any()))
          .thenAnswer((_) async => Left(validationFailure));

      // Act
      final result = await useCase(request);

      // Assert
      expect(result, isA<Left<Failure, ResendCodeResponse>>());

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Invalid email format');
          expect((failure as ServerFailure).statusCode, 400);
        },
        (response) => fail('Expected Left, got Right: $response'),
      );
    });
  });
}
