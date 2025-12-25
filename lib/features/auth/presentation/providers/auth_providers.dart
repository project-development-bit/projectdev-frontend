import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/auth/data/datasources/remote/facebook_service_auth.dart';

import 'package:gigafaucet/features/auth/data/datasources/remote/google_auth_remote.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/datasources/remote/auth_remote.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

// Note: authRemoteDataSourceProvider is already defined in auth_remote.dart
// Note: secureStorageServiceProvider is already defined in secure_storage_service.dart

// =============================================================================
// REPOSITORY PROVIDERS
// =============================================================================

/// Provider for auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  final secureStorage = ref.read(secureStorageServiceProvider);
  final googleAuthService = ref.read(googleAuthRemoteProvider);
  final facebookAuthService = ref.read(facebookAuthServiceProvider);
  return AuthRepositoryImpl(
      remoteDataSource, secureStorage, googleAuthService, facebookAuthService);
});

// =============================================================================
// USE CASE PROVIDERS
// =============================================================================

/// Provider for login use case
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Provider for register use case
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RegisterUseCase(repository);
});

/// Provider for logout use case
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUseCase(repository);
});

/// Provider for get current user use case
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

/// Provider for checking authentication status
final checkAuthUseCaseProvider = Provider<AuthRepository>((ref) {
  return ref.read(authRepositoryProvider);
});
