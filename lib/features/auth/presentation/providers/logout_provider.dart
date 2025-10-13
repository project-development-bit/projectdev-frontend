import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/database_service.dart';
import 'auth_providers.dart';

// =============================================================================
// LOGOUT STATE CLASSES
// =============================================================================

/// Logout state for the application
@immutable
sealed class LogoutState {
  const LogoutState();
}

/// Initial logout state
class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

/// Logout in progress
class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

/// Logout successful
class LogoutSuccess extends LogoutState {
  const LogoutSuccess({this.message = 'Logged out successfully'});
  
  final String message;
}

/// Logout error
class LogoutError extends LogoutState {
  const LogoutError({
    required this.message,
    this.isNetworkError = false,
  });

  final String message;
  final bool isNetworkError;
}

// =============================================================================
// LOGOUT NOTIFIER
// =============================================================================

/// StateNotifier for handling logout operations
class LogoutNotifier extends StateNotifier<LogoutState> {
  LogoutNotifier(this._ref) : super(const LogoutInitial());

  final Ref _ref;

  /// Logout the current user
  Future<void> logout() async {
    try {
      state = const LogoutLoading();
      
      final authRepository = _ref.read(authRepositoryProvider);
      final result = await authRepository.logout();
      
      await result.fold(
        (failure) {
          debugPrint('❌ Logout failed: ${failure.message}');
          state = LogoutError(
            message: failure.message ?? 'Logout failed',
            isNetworkError: failure.toString().contains('network') || 
                           failure.toString().contains('connection'),
          );
        },
        (_) async {
          debugPrint('✅ Logout successful');
          
          // Clear local database
          try {
            await DatabaseService.clearAllUsers();
            debugPrint('✅ User data cleared from database');
          } catch (dbError) {
            debugPrint('⚠️ Failed to clear user data from database: $dbError');
            // Don't fail the logout process if database clear fails
          }
          
          state = const LogoutSuccess();
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected logout error: $e');
      state = LogoutError(
        message: 'An unexpected error occurred during logout: $e',
      );
    }
  }

  /// Reset to initial state
  void resetToInitial() {
    state = const LogoutInitial();
  }

  /// Check if logout is in progress
  bool get isLoading => state is LogoutLoading;

  /// Get current error message (null if no error)
  String? get errorMessage {
    final currentState = state;
    if (currentState is LogoutError) {
      return currentState.message;
    }
    return null;
  }

  /// Check if logout was successful
  bool get wasSuccessful => state is LogoutSuccess;
}

// =============================================================================
// LOGOUT PROVIDERS
// =============================================================================

/// Provider for logout state management
final logoutNotifierProvider = StateNotifierProvider<LogoutNotifier, LogoutState>((ref) {
  return LogoutNotifier(ref);
});

/// Provider for checking if logout is in progress
final isLogoutLoadingProvider = Provider<bool>((ref) {
  final logoutState = ref.watch(logoutNotifierProvider);
  return logoutState is LogoutLoading;
});

/// Provider for getting logout error message
final logoutErrorProvider = Provider<String?>((ref) {
  final logoutState = ref.watch(logoutNotifierProvider);
  if (logoutState is LogoutError) {
    return logoutState.message;
  }
  return null;
});

/// Provider for checking if logout was successful
final logoutSuccessProvider = Provider<bool>((ref) {
  final logoutState = ref.watch(logoutNotifierProvider);
  return logoutState is LogoutSuccess;
});

/// Provider for getting logout success message
final logoutSuccessMessageProvider = Provider<String?>((ref) {
  final logoutState = ref.watch(logoutNotifierProvider);
  if (logoutState is LogoutSuccess) {
    return logoutState.message;
  }
  return null;
});