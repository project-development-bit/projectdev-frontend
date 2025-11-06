import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/entities/user.dart';
import '../../data/models/verify_2fa_request.dart';
import '../../domain/usecases/verify_2fa_usecase.dart';

// =============================================================================
// 2FA STATE CLASSES
// =============================================================================

/// Two-Factor Authentication state for the application
@immutable
sealed class Verify2FAState {
  const Verify2FAState();
}

/// Initial 2FA state
class Verify2FAInitial extends Verify2FAState {
  const Verify2FAInitial();
}

/// 2FA verification operation in progress
class Verify2FALoading extends Verify2FAState {
  const Verify2FALoading();
}

/// 2FA verification successful
class Verify2FASuccess extends Verify2FAState {
  const Verify2FASuccess({required this.user, required this.message});

  final User user;
  final String message;
}

/// 2FA verification error occurred
class Verify2FAError extends Verify2FAState {
  const Verify2FAError({
    required this.message,
    this.isNetworkError = false,
  });

  final String message;
  final bool isNetworkError;
}

// =============================================================================
// 2FA STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing 2FA verification operations
class Verify2FANotifier extends StateNotifier<Verify2FAState> {
  Verify2FANotifier(this._ref) : super(const Verify2FAInitial());

  final Ref _ref;

  /// Verify 2FA code from authenticator app
  Future<void> verify2FA({
    required String email,
    required String twoFactorCode,
    String? sessionToken,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🔄 Starting 2FA verification for: $email');
    debugPrint('🔄 Current state before verification: ${state.runtimeType}');

    // Ensure we start with loading state
    state = const Verify2FALoading();
    debugPrint('🔄 State set to Verify2FALoading');

    try {
      final request = Verify2FARequest(
        email: email,
        twoFactorCode: twoFactorCode,
        sessionToken: sessionToken,
      );

      debugPrint('📤 Sending 2FA verification request');

      final verify2FAUseCase = _ref.read(verify2FAUseCaseProvider);

      // Add timeout to prevent infinite loading
      final result = await verify2FAUseCase(request).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              '2FA verification timeout: Please check your internet connection and try again');
        },
      );

      result.fold(
        (failure) {
          debugPrint('❌ 2FA verification failed: ${failure.message}');
          state = Verify2FAError(
            message: failure.message ?? '2FA verification failed',
            isNetworkError: failure.toString().contains('network') ||
                failure.toString().contains('connection'),
          );
          onError?.call(failure.message ?? '2FA verification failed');
          debugPrint('🔄 State set to Verify2FAError');
        },
        (verify2FAResponse) async {
          if (verify2FAResponse.success && verify2FAResponse.data != null) {
            debugPrint('✅ 2FA verification successful for: $email');
            debugPrint(
                '✅ Access token length: ${verify2FAResponse.data!.tokens.accessToken.length}');
            debugPrint(
                '✅ Refresh token length: ${verify2FAResponse.data!.tokens.refreshToken.length}');

            // Store user data in local database
            try {
              await DatabaseService.saveUser(verify2FAResponse.data!.user);
              debugPrint('✅ User data saved to database');
            } catch (dbError) {
              debugPrint('⚠️ Failed to save user to database: $dbError');
              // Don't fail the verification process if database save fails
            }

            // Ensure state is set after all async operations
            await Future.delayed(const Duration(milliseconds: 50));

            state = Verify2FASuccess(
              user: verify2FAResponse.data!.user.toEntity(),
              message: verify2FAResponse.message,
            );
            onSuccess?.call();
            debugPrint('🔄 State set to Verify2FASuccess');
          } else {
            debugPrint('❌ 2FA verification failed: ${verify2FAResponse.message}');
            state = Verify2FAError(
              message: verify2FAResponse.message,
            );
            onError?.call(verify2FAResponse.message);
            debugPrint('🔄 State set to Verify2FAError');
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected error during 2FA verification: $e');
      state = Verify2FAError(
        message: e.toString().contains('timeout')
            ? 'Request timed out. Please check your connection and try again.'
            : 'An unexpected error occurred. Please try again.',
        isNetworkError: e.toString().contains('timeout'),
      );
      onError?.call(state is Verify2FAError
          ? (state as Verify2FAError).message
          : 'An unexpected error occurred');
      debugPrint('🔄 State set to Verify2FAError (exception)');
    }
  }

  /// Reset state to initial
  void reset() {
    debugPrint('🔄 Resetting 2FA state to initial');
    state = const Verify2FAInitial();
  }

  /// Get error message (null if not in error state)
  String? get errorMessage {
    final currentState = state;
    if (currentState is Verify2FAError) {
      return currentState.message;
    }
    return null;
  }
}

// =============================================================================
// 2FA PROVIDERS
// =============================================================================

/// Provider for 2FA verification state management
final verify2FANotifierProvider =
    StateNotifierProvider<Verify2FANotifier, Verify2FAState>((ref) {
  return Verify2FANotifier(ref);
});

/// Provider for checking if 2FA verification is in progress
final is2FALoadingProvider = Provider<bool>((ref) {
  final verify2FAState = ref.watch(verify2FANotifierProvider);
  return verify2FAState is Verify2FALoading;
});

/// Provider for getting 2FA error message
final verify2FAErrorProvider = Provider<String?>((ref) {
  final verify2FAState = ref.watch(verify2FANotifierProvider);
  if (verify2FAState is Verify2FAError) {
    return verify2FAState.message;
  }
  return null;
});

/// Provider for getting 2FA success message
final verify2FASuccessProvider = Provider<String?>((ref) {
  final verify2FAState = ref.watch(verify2FANotifierProvider);
  if (verify2FAState is Verify2FASuccess) {
    return verify2FAState.message;
  }
  return null;
});
