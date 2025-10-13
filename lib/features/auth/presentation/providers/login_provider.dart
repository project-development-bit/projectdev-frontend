import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/login_response.dart';
import '../../data/models/login_request.dart';
import 'auth_providers.dart';

// =============================================================================
// LOGIN STATE CLASSES
// =============================================================================

/// Login state for the application
@immutable
sealed class LoginState {
  const LoginState();
}

/// Initial login state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Login operation in progress
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Login successful
class LoginSuccess extends LoginState {
  const LoginSuccess({required this.user, required this.loginResponse});
  
  final User user;
  final LoginResponse loginResponse;
}

/// Login error occurred
class LoginError extends LoginState {
  const LoginError({required this.message, this.isNetworkError = false});
  
  final String message;
  final bool isNetworkError;
}

// =============================================================================
// LOGIN STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing login operations
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._ref) : super(const LoginInitial());

  final Ref _ref;

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = const LoginLoading();
      
      final loginRequest = LoginRequest(
        email: email,
        password: password,
      );
      
      final authRepository = _ref.read(authRepositoryProvider);
      final result = await authRepository.login(loginRequest);
      
      await result.fold(
        (failure) {
          debugPrint('❌ Login failed: ${failure.message}');
          state = LoginError(
            message: failure.message ?? 'Login failed',
            isNetworkError: failure.toString().contains('network') || 
                           failure.toString().contains('connection'),
          );
        },
        (loginResponse) async {
          debugPrint('✅ Login successful for: $email');
          
          // Store user data in local database
          try {
            await DatabaseService.saveUser(loginResponse.user);
            debugPrint('✅ User data saved to database');
          } catch (dbError) {
            debugPrint('⚠️ Failed to save user to database: $dbError');
            // Don't fail the login process if database save fails
          }
          
          state = LoginSuccess(
            user: loginResponse.user,
            loginResponse: loginResponse,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected login error: $e');
      state = LoginError(
        message: 'An unexpected error occurred during login: $e',
      );
    }
  }

  /// Clear error state
  void clearError() {
    if (state is LoginError) {
      state = const LoginInitial();
    }
  }

  /// Reset to initial state
  void reset() {
    state = const LoginInitial();
  }

  /// Check if login is in progress
  bool get isLoading => state is LoginLoading;

  /// Get current error message (null if no error)
  String? get errorMessage {
    final currentState = state;
    if (currentState is LoginError) {
      return currentState.message;
    }
    return null;
  }

  /// Get current user (null if not logged in successfully)
  User? get currentUser {
    final currentState = state;
    if (currentState is LoginSuccess) {
      return currentState.user;
    }
    return null;
  }

  /// Get current login response (null if not logged in successfully)
  LoginResponse? get currentLoginResponse {
    final currentState = state;
    if (currentState is LoginSuccess) {
      return currentState.loginResponse;
    }
    return null;
  }
}

// =============================================================================
// LOGIN PROVIDERS
// =============================================================================

/// Provider for login state management
final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

/// Provider for checking if login is in progress
final isLoginLoadingProvider = Provider<bool>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  return loginState is LoginLoading;
});

/// Provider for getting login error message
final loginErrorProvider = Provider<String?>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginError) {
    return loginState.message;
  }
  return null;
});

/// Provider for getting current logged in user
final loggedInUserProvider = Provider<User?>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginSuccess) {
    return loginState.user;
  }
  return null;
});

/// Provider for getting current login response
final loginResponseProvider = Provider<LoginResponse?>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginSuccess) {
    return loginState.loginResponse;
  }
  return null;
});