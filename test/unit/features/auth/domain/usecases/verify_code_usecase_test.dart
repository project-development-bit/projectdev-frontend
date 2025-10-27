import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/auth/data/models/verify_code_request.dart';
import 'package:cointiply_app/features/auth/data/models/verify_code_response.dart';
import 'package:cointiply_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:cointiply_app/features/auth/domain/usecases/verify_code_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('VerifyCodeUseCase', () {
    late VerifyCodeUseCase useCase;
    late MockAuthRepository mockRepository;

    setUpAll(() {
      registerFallbackValue(const VerifyCodeRequest(email: '', code: ''));
    });

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = VerifyCodeUseCase(mockRepository);
    });

    test('should return VerifyCodeResponse when repository call succeeds',
        () async {
      // Arrange
      const request = VerifyCodeRequest(
        email: 'test@example.com',
        code: '1234',
      );

      const expectedResponse = VerifyCodeResponse(
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

      when(() => mockRepository.verifyCode(any()))
          .thenAnswer((_) async => const Right(expectedResponse));

      // Act
      final result = await useCase(request);

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

      verify(() => mockRepository.verifyCode(request)).called(1);
    });

    test('should return Failure when repository call fails', () async {
      // Arrange
      const request = VerifyCodeRequest(
        email: 'test@example.com',
        code: 'invalid',
      );

      final expectedFailure = ServerFailure(
        message: 'Invalid verification code',
        statusCode: 400,
      );

      when(() => mockRepository.verifyCode(any()))
          .thenAnswer((_) async => Left(expectedFailure));

      // Act
      final result = await useCase(request);

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

      verify(() => mockRepository.verifyCode(request)).called(1);
    });

    test('should pass the correct request to repository', () async {
      // Arrange
      const request = VerifyCodeRequest(
        email: 'user@test.com',
        code: '5678',
      );

      const expectedResponse = VerifyCodeResponse(
        success: true,
        message: 'Verified successfully.',
        data: null,
      );

      when(() => mockRepository.verifyCode(any()))
          .thenAnswer((_) async => const Right(expectedResponse));

      // Act
      await useCase(request);

      // Assert
      verify(() => mockRepository.verifyCode(request)).called(1);
    });

    test('should handle network failures correctly', () async {
      // Arrange
      const request = VerifyCodeRequest(
        email: 'test@example.com',
        code: '1234',
      );

      final networkFailure = ServerFailure(
        message: 'Network error',
        statusCode: null,
      );

      when(() => mockRepository.verifyCode(any()))
          .thenAnswer((_) async => Left(networkFailure));

      // Act
      final result = await useCase(request);

      // Assert
      expect(result, isA<Left<Failure, VerifyCodeResponse>>());

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Network error');
        },
        (response) => fail('Expected Left, got Right: $response'),
      );
    });
  });
}
