import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/login_response.dart';
import '../entities/user.dart' as auth_entities;
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/resend_code_request.dart';
import '../../data/models/resend_code_response.dart';
import '../../data/models/verify_code_request.dart';
import '../../data/models/verify_code_response.dart';
import '../../data/models/forgot_password_request.dart';
import '../../data/models/forgot_password_response.dart';
import '../../data/models/reset_password_request.dart';

/// Authentication repository interface
///
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Register a new user
  Future<Either<Failure, void>> register(RegisterRequest request);

  /// Login user with credentials
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);

  /// Get current user information from server
  Future<Either<Failure, auth_entities.User>> whoami();

  /// Send forgot password request
  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword(
      ForgotPasswordRequest request);

  /// Reset password with new password
  Future<Either<Failure, LoginResponse>> resetPassword(
      ResetPasswordRequest request);

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Check if user is currently authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  /// Get current user information
  Future<Either<Failure, LoginResponse?>> getCurrentUser();

  /// Refresh authentication token
  Future<Either<Failure, LoginResponse>> refreshToken();

  /// Resend verification code to user's email
  Future<Either<Failure, ResendCodeResponse>> resendCode(
      ResendCodeRequest request);

  /// Verify email with verification code
  Future<Either<Failure, VerifyCodeResponse>> verifyCode(
      VerifyCodeRequest request);
}
