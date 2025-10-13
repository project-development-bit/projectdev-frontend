import 'package:cointiply_app/core/config/api_endpoints.dart';
import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/auth/data/datasources/remote/auth_remote.dart';
import 'package:cointiply_app/features/auth/data/models/register_request.dart';
import 'package:cointiply_app/features/auth/data/models/login_request.dart';
import 'package:cointiply_app/features/auth/data/models/login_response_model.dart';
import 'package:cointiply_app/core/enum/user_role.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  group('AuthRemoteDataSourceImpl', () {
    late AuthRemoteDataSourceImpl authRemoteDataSource;
    late MockDioClient mockDioClient;

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(RequestOptions(path: ''));
      registerFallbackValue(<String, dynamic>{});
    });

    setUp(() {
      mockDioClient = MockDioClient();
      authRemoteDataSource = AuthRemoteDataSourceImpl(mockDioClient);
    });

    group('register', () {
      late RegisterRequest registerRequest;

      setUp(() {
        registerRequest = RegisterRequest(
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          role: UserRole.normalUser,
        );
      });

      test('should complete successfully when API returns 200', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 200,
          data: {'message': 'User registered successfully'},
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          returnsNormally,
        );

        verify(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).called(1);
      });

      test('should complete successfully when API returns 201', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 201,
          data: {'message': 'User created successfully'},
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          returnsNormally,
        );

        verify(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).called(1);
      });

      test('should throw DioException when API returns 400 (Bad Request)', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 400,
          data: {'message': 'Invalid email format'},
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          response: response,
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Invalid email format'),
          )),
        );
      });

      test('should throw DioException when API returns 409 (Conflict)', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 409,
          data: {'message': "Duplicate entry 'user10@gmail.com' for key 'users.email'"},
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          response: response,
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals("Duplicate entry 'user10@gmail.com' for key 'users.email'"),
          )),
        );
      });

      test('should throw DioException when API returns 422 (Unprocessable Entity)', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 422,
          data: {'message': 'Password too short'},
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          response: response,
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Password too short'),
          )),
        );
      });

      test('should throw DioException with generic message for other HTTP errors', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 500,
          data: {'message': 'Internal server error'},
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          response: response,
          message: 'Server error',
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Internal server error'),
          )),
        );
      });

      test('should throw Exception for non-DioException errors', () async {
        // Arrange
        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Unexpected error during registration'),
          )),
        );
      });

      test('should handle response without message in error data', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 400,
          data: {'error': 'Some error without message field'},
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          response: response,
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Bad Request'),
          )),
        );
      });

      test('should handle server error response format correctly', () async {
        // Arrange - Server response format as provided by user
        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 409,
          data: {
            "type": "error",
            "status": 409,
            "message": "Duplicate entry 'user10@gmail.com' for key 'users.email'"
          },
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          response: response,
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals("Duplicate entry 'user10@gmail.com' for key 'users.email'"),
          )),
        );
      });

      test('should send correct data to API', () async {
        // Arrange
        final expectedData = {
          "name": "John Doe",
          "email": "john.doe@example.com",
          "password": "password123",
          "confirm_password": "password123",
          "role": "NormalUser",
        };

        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 201,
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: any(named: 'data'),
        )).thenAnswer((_) async => response);

        // Act
        await authRemoteDataSource.register(registerRequest);

        // Assert
        verify(() => mockDioClient.post(
          registerEndpoints,
          data: expectedData,
        )).called(1);
      });

      test('should work with different user roles', () async {
        // Arrange
        final adminRequest = RegisterRequest(
          name: 'Admin User',
          email: 'admin@example.com',
          password: 'adminpass',
          confirmPassword: 'adminpass',
          role: UserRole.admin,
        );

        final expectedData = {
          "name": "Admin User",
          "email": "admin@example.com",
          "password": "adminpass",
          "confirm_password": "adminpass",
          "role": "Admin",
        };

        final response = Response(
          requestOptions: RequestOptions(path: registerEndpoints),
          statusCode: 201,
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: adminRequest.toJson(),
        )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(adminRequest),
          returnsNormally,
        );

        verify(() => mockDioClient.post(
          registerEndpoints,
          data: expectedData,
        )).called(1);
      });

      test('should handle timeout errors', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Connection timeout'),
          )),
        );
      });

      test('should handle network errors', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: registerEndpoints),
          type: DioExceptionType.unknown,
          message: 'Network unreachable',
        );

        when(() => mockDioClient.post(
          registerEndpoints,
          data: registerRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.register(registerRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Network unreachable'),
          )),
        );
      });
    });

    group('login', () {
      late LoginRequest loginRequest;

      setUp(() {
        loginRequest = const LoginRequest(
          email: 'user8@gmail.com',
          password: '12345678',
        );
      });

      test('should return LoginResponseModel when API returns successful login', () async {
        // Arrange
        final mockResponseData = {
          "success": true,
          "message": "Login successful.",
          "data": {
            "user": {
              "id": 11,
              "name": "User 7",
              "email": "user8@gmail.com",
              "role": "NormalUser"
            },
            "tokens": {
              "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
              "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
              "tokenType": "Bearer",
              "accessTokenExpiresIn": "15m",
              "refreshTokenExpiresIn": "7d"
            }
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: loginEndpoints),
          statusCode: 200,
          data: mockResponseData,
        );

        when(() => mockDioClient.post(
          loginEndpoints,
          data: loginRequest.toJson(),
        )).thenAnswer((_) async => response);

        // Act
        final result = await authRemoteDataSource.login(loginRequest);

        // Assert
        expect(result, isA<LoginResponseModel>());
        expect(result.success, true);
        expect(result.message, 'Login successful.');
        expect(result.user.id, 11);
        expect(result.user.name, 'User 7');
        expect(result.user.email, 'user8@gmail.com');
        expect(result.user.role, UserRole.normalUser);
        expect(result.tokens.tokenType, 'Bearer');
        expect(result.tokens.accessTokenExpiresIn, '15m');
        
        verify(() => mockDioClient.post(
          loginEndpoints,
          data: loginRequest.toJson(),
        )).called(1);
      });

      test('should throw DioException when login fails with 401', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: loginEndpoints),
          statusCode: 401,
          data: {'message': 'Invalid credentials'},
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: loginEndpoints),
          response: response,
        );

        when(() => mockDioClient.post(
          loginEndpoints,
          data: loginRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.login(loginRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Invalid credentials'),
          )),
        );
      });

      test('should throw DioException with fallback message when no server message', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: loginEndpoints),
          statusCode: 401,
          data: {'error': 'Authentication failed'},
        );

        final dioException = DioException(
          requestOptions: RequestOptions(path: loginEndpoints),
          response: response,
        );

        when(() => mockDioClient.post(
          loginEndpoints,
          data: loginRequest.toJson(),
        )).thenThrow(dioException);

        // Act & Assert
        expect(
          () async => await authRemoteDataSource.login(loginRequest),
          throwsA(isA<DioException>().having(
            (e) => e.message,
            'message',
            equals('Invalid credentials'),
          )),
        );
      });

      test('should send correct login data to API', () async {
        // Arrange
        final expectedData = {
          'email': 'user8@gmail.com',
          'password': '12345678',
        };

        final mockResponseData = {
          "success": true,
          "message": "Login successful.",
          "data": {
            "user": {"id": 11, "name": "User 7", "email": "user8@gmail.com", "role": "NormalUser"},
            "tokens": {
              "accessToken": "token",
              "refreshToken": "refresh",
              "tokenType": "Bearer",
              "accessTokenExpiresIn": "15m",
              "refreshTokenExpiresIn": "7d"
            }
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: loginEndpoints),
          statusCode: 200,
          data: mockResponseData,
        );

        when(() => mockDioClient.post(
          loginEndpoints,
          data: any(named: 'data'),
        )).thenAnswer((_) async => response);

        // Act
        await authRemoteDataSource.login(loginRequest);

        // Assert
        verify(() => mockDioClient.post(
          loginEndpoints,
          data: expectedData,
        )).called(1);
      });
    });
  });

  group('AuthRemoteDataSource Provider', () {
    test('should create AuthRemoteDataSourceImpl instance', () {
      // This test verifies that the provider exists and has the correct type
      expect(authRemoteDataSourceProvider, isA<Provider<AuthRemoteDataSource>>());
    });
  });
}