import 'package:flutter/foundation.dart';
import 'package:gigafaucet/core/error/error_model.dart';
import 'package:gigafaucet/features/auth/data/datasources/remote/google_auth_remote.dart';
import 'package:gigafaucet/features/auth/data/models/request/google_login_request.dart';
import 'package:gigafaucet/features/auth/data/models/request/google_register_request.dart';
import 'package:gigafaucet/features/auth/data/models/verify_code_forgot_password_response.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/entities/user.dart' as auth_entities;
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/resend_code_request.dart';
import '../models/resend_code_response.dart';
import '../models/verify_code_request.dart';
import '../models/verify_code_response.dart';
import '../models/verify_2fa_request.dart';
import '../models/verify_2fa_response.dart';
import '../models/verify_login_2fa_request.dart';
import '../models/verify_login_2fa_response.dart';
import '../models/setup_2fa_request.dart';
import '../models/setup_2fa_response.dart';
import '../models/enable_2fa_request.dart';
import '../models/enable_2fa_response.dart';
import '../models/check_2fa_status_response.dart';
import '../models/disable_2fa_request.dart';
import '../models/disable_2fa_response.dart';
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
    ref.watch(googleAuthRemoteProvider),
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

  final GoogleAuthRemote googleAuthRemote;

  /// Creates an instance of [AuthRepositoryImpl]
  const AuthRepositoryImpl(
      this.remoteDataSource, this.secureStorage, this.googleAuthRemote);

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
          errorModel: errorModel));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, auth_entities.User>> whoami() async {
    try {
      final userModel = await remoteDataSource.whoami();
      return Right(userModel.toEntity());
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
      await googleAuthRemote.signOut();
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

  @override
  Future<Either<Failure, Verify2FAResponse>> verify2FA(
      Verify2FARequest request) async {
    try {
      final response = await remoteDataSource.verify2FA(request);

      // Store the authentication tokens if 2FA verification is successful
      if (response.success && response.data != null) {
        await _store2FATokens(response.data!);
      }

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
  Future<Either<Failure, Setup2FAResponse>> setup2FA(
      Setup2FARequest request) async {
    try {
      final response = await remoteDataSource.setup2FA(request);
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
  Future<Either<Failure, Enable2FAResponse>> enable2FA(
      Enable2FARequest request) async {
    try {
      final response = await remoteDataSource.enable2FA(request);
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
    // Only store tokens if they are not null (i.e., not a 2FA required response)
    if (loginResponse.tokens != null && loginResponse.user != null) {
      await secureStorage.saveAuthToken(loginResponse.tokens!.accessToken);
      await secureStorage.saveRefreshToken(loginResponse.tokens!.refreshToken);
      await secureStorage.saveUserId(loginResponse.user!.id.toString());

      // Store additional user info if needed
      // You could also store user role, email, etc.
    }
  }

  /// Store authentication tokens from 2FA verification response
  Future<void> _store2FATokens(Verify2FAData data) async {
    await secureStorage.saveAuthToken(data.tokens.accessToken);
    await secureStorage.saveRefreshToken(data.tokens.refreshToken);
    await secureStorage.saveUserId(data.user.id.toString());

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

  @override
  Future<Either<Failure, Check2FAStatusResponse>> check2FAStatus() async {
    try {
      final response = await remoteDataSource.check2FAStatus();
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'Failed to check 2FA status',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Disable2FAResponse>> disable2FA(
      Disable2FARequest request) async {
    try {
      final response = await remoteDataSource.disable2FA(request);
      return Right(response);
    } on DioException catch (e) {
      // Handle the new error response format
      String errorMessage = 'Failed to disable 2FA';

      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          // New error format: {"type": "error", "status": 401, "message": "...", "code": "..."}
          errorMessage = errorData['message'] ?? errorMessage;
        }
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyLogin2FAResponse>> verifyLogin2FA(
      VerifyLogin2FARequest request) async {
    try {
      final response = await remoteDataSource.verifyLogin2FA(request);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'Failed to verify 2FA code',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResendCodeResponse>> resendCodeForForgotPassword(
      ResendCodeRequest request) async {
    try {
      final response =
          await remoteDataSource.resendCodeForForgotPassword(request);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'Failed to resend verification code',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyCodeForForgotPasswordResponse>>
      verifyCodeForForgotPassword(VerifyCodeRequest request) async {
    try {
      final response =
          await remoteDataSource.verifyCodeForForgotPassword(request);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'Failed to verify code',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> googleSignIn(
      GoogleLoginRequest request) async {
    try {
      // 1. Resolve ID Token (If not already present in request)
      String? accessToken = request.accessToken;

      if (accessToken == null) {
        // Reuse the helper to handle Web vs Native logic automatically
        accessToken = await _getGooglePlatformSpecificIdToken();
        // Guard Clause: Handle cancellation
        if (accessToken == null) {
          debugPrint("Testing Google Sign-In : User cancelled Google sign-in.");
          return Left(ServerFailure(message: 'User cancelled Google sign-in'));
        }
      }

      // 2. Prepare the final request object
      final updatedRequest = request.copyWith(accessToken: accessToken);

      // 3. Perform API Call
      final response = await remoteDataSource.googleLogin(updatedRequest);

      // 4. Success Side Effects (Storage)
      await _storeTokens(response);

      return Right(response);
    } on DioException catch (e) {
      debugPrint("Testing Google Sign-In : Dio Exception: ${e.message}");
      // Handle Dio-specific network errors with cleanup
      await _handleErrorCleanup();
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      // Handle generic errors
      debugPrint("Testing Google Sign-In : Unexpected Error: $e");
      await _handleErrorCleanup();
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> googleRegister(
      GoogleRegisterRequest request) async {
    try {
      // 1. Resolve ID Token (If not already present in request)
      String? accessToken = request.accessToken;

      if (accessToken == null) {
        accessToken = await _getGooglePlatformSpecificIdToken();

        // Guard Clause: Handle cancellation immediately
        if (accessToken == null) {
          debugPrint("Testing Google Sign-In : User cancelled Google sign-up.");
          return Left(ServerFailure(message: 'User cancelled Google sign-up'));
        }
      }

      // 2. Prepare the final request object
      final updatedRequest = request.copyWith(accessToken: accessToken);

      // 3. Perform API Call
      final response = await remoteDataSource.googleRegister(updatedRequest);

      // 4. Success Side Effects (Storage)
      await _storeTokens(response);

      return Right(response);
    } on DioException catch (e) {
      await _handleErrorCleanup();
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      debugPrint("Testing Google Sign-In : Unexpected Error: $e");
      await _handleErrorCleanup();
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getGooglePlatformSpecificIdToken() async {
    try {
      try {
        var token = await _getGooglePlatformSpecificIdToken();
        if (token == null) {
          debugPrint(
              "Testing Google Sign-In : User cancelled ID token retrieval.");
          return Right(null);
        }
        return Right(token);
      } catch (e) {
        debugPrint("Testing Google Sign-In : Error obtaining ID token: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } catch (e) {
      debugPrint("Testing Google Sign-In : Token Retrieval Error: $e");
      rethrow;
    }
  }

  Future<String?> _getGooglePlatformSpecificIdToken() async {
    try {
      return await googleAuthRemote.getGoogleIdToken();
    } catch (e) {
      debugPrint("Testing Google Sign-In : Token Retrieval Error: $e");
      rethrow;
    }
  }

  /// Helper: Centralizes cleanup logic
  Future<void> _handleErrorCleanup() async {
    await googleAuthRemote.signOut();
  }
}
