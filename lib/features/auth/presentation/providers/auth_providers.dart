import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/datasources/remote/auth_remote.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

// Note: authRemoteDataSourceProvider is already defined in auth_remote.dart
// Note: secureStorageServiceProvider is already defined in secure_storage_service.dart

// =============================================================================
// REPOSITORY PROVIDERS
// =============================================================================

/// Provider for auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  final secureStorage = ref.read(secureStorageServiceProvider);
  return AuthRepositoryImpl(remoteDataSource, secureStorage);
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

/// Provider for checking authentication status
final checkAuthUseCaseProvider = Provider<AuthRepository>((ref) {
  return ref.read(authRepositoryProvider);
});