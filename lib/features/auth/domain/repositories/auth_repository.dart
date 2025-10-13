import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/login_response.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';

/// Authentication repository interface
/// 
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Register a new user
  Future<Either<Failure, void>> register(RegisterRequest request);
  
  /// Login user with credentials
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
  
  /// Logout current user
  Future<Either<Failure, void>> logout();
  
  /// Check if user is currently authenticated
  Future<Either<Failure, bool>> isAuthenticated();
  
  /// Get current user information
  Future<Either<Failure, LoginResponse?>> getCurrentUser();
  
  /// Refresh authentication token
  Future<Either<Failure, LoginResponse>> refreshToken();
}