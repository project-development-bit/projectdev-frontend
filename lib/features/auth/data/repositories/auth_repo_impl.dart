import 'package:cointiply_app/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/login_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/resend_code_request.dart';
import '../models/resend_code_response.dart';
import '../models/verify_code_request.dart';
import '../models/verify_code_response.dart';
import '../models/forgot_password_request.dart';
import '../models/forgot_password_response.dart';
import '../models/reset_password_request.dart';
import '../models/login_response_model.dart';
import '../datasources/remote/auth_remote.dart';

/// Provider for the authentication repository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureStorageServiceProvider),
  ),
);

/// Implementation of [AuthRepository]
/// 
/// Handles authentication operations with remote data source and local storage
class AuthRepositoryImpl implements AuthRepository {
  /// Remote data source for API calls
  final AuthRemoteDataSource remoteDataSource;
  
  /// Secure storage service for token management
  final SecureStorageService secureStorage;

  /// Creates an instance of [AuthRepositoryImpl]
  const AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<Either<Failure, void>> register(RegisterRequest request) async {
    try {
      await remoteDataSource.register(request);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      final loginResponseModel = await remoteDataSource.login(request);
      
      // Store tokens in secure storage
      await _storeTokens(loginResponseModel);
      
      return Right(loginResponseModel.toEntity());
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.response?.statusCode,
          errorModel: errorModel
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword(
      ForgotPasswordRequest request) async {
    try {
      final response = await remoteDataSource.forgotPassword(request);
      return Right(response);
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> resetPassword(
      ResetPasswordRequest request) async {
    try {
      final loginResponseModel = await remoteDataSource.resetPassword(request);
      return Right(loginResponseModel.toEntity());
    } on DioException catch (e) {
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear all stored authentication data
      await secureStorage.clearAllAuthData();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final accessToken = await secureStorage.getAuthToken();
      return Right(accessToken != null && accessToken.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse?>> getCurrentUser() async {
    try {
      final accessToken = await secureStorage.getAuthToken();
      final refreshToken = await secureStorage.getRefreshToken();
      final userId = await secureStorage.getUserId();
      
      if (accessToken == null || refreshToken == null || userId == null) {
        return const Right(null);
      }
      
      // For now, we don't store complete user info locally
      // In a real app, you might want to store and retrieve user data
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> refreshToken() async {
    try {
      final refreshToken = await secureStorage.getRefreshToken();
      
      if (refreshToken == null) {
        return Left(ServerFailure(message: 'No refresh token available'));
      }
      
      // TODO: Implement refresh token API call
      // For now, return a failure
      return Left(ServerFailure(message: 'Refresh token not implemented'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResendCodeResponse>> resendCode(
      ResendCodeRequest request) async {
    try {
      final response = await remoteDataSource.resendCode(request);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyCodeResponse>> verifyCode(
      VerifyCodeRequest request) async {
    try {
      final response = await remoteDataSource.verifyCode(request);

      // // Store the authentication tokens if verification is successful
      // if (response.success && response.data != null) {
      //   await _storeVerificationTokens(response.data!);
      // }

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Store authentication tokens in secure storage
  Future<void> _storeTokens(LoginResponseModel loginResponse) async {
    await secureStorage.saveAuthToken(loginResponse.tokens.accessToken);
    await secureStorage.saveRefreshToken(loginResponse.tokens.refreshToken);
    await secureStorage.saveUserId(loginResponse.user.id.toString());
    
    // Store additional user info if needed
    // You could also store user role, email, etc.
  }

  /// Store authentication tokens from verification response
  // Future<void> _storeVerificationTokens(VerifyCodeData data) async {
  //   await secureStorage.saveAuthToken(data.tokens.accessToken);
  //   await secureStorage.saveRefreshToken(data.tokens.refreshToken);
  //   await secureStorage.saveUserId(data.user.id.toString());

  //   // Store additional user info if needed
  //   // You could also store user role, email, etc.
  // }
}