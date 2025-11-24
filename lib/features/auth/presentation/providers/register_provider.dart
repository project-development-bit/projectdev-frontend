import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enum/user_role.dart';
import '../../../../core/providers/turnstile_provider.dart';
import '../../data/models/register_request.dart';
import 'auth_providers.dart';

// =============================================================================
// REGISTER STATE CLASSES
// =============================================================================

/// Register state for the application
@immutable
sealed class RegisterState {
  const RegisterState();
}

/// Initial register state
class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

/// Registration operation in progress
class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

/// Registration successful
class RegisterSuccess extends RegisterState {
  const RegisterSuccess({required this.message, required this.email});

  final String message;
  final String email;
}

/// Registration error occurred
class RegisterError extends RegisterState {
  const RegisterError({required this.message, this.isNetworkError = false});

  final String message;
  final bool isNetworkError;
}

// =============================================================================
// REGISTER STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing registration operations
class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(this._ref) : super(const RegisterInitial());

  final Ref _ref;

  /// Register a new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required int countryID,
    required UserRole role,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🔄 Starting registration process for: $email');
    debugPrint('🔄 Current state before registration: ${state.runtimeType}');

    // Ensure we start with loading state
    state = const RegisterLoading();
    debugPrint('🔄 State set to RegisterLoading');

    try {
      // Get Turnstile token (replaces reCAPTCHA)
      String? turnstileToken;

      debugPrint('🔐 Checking Turnstile verification...');
      final turnstileState = _ref.read(turnstileNotifierProvider);

      if (turnstileState is TurnstileSuccess) {
        turnstileToken = turnstileState.token;
        debugPrint('✅ Turnstile token obtained successfully');
      } else {
        debugPrint('❌ Turnstile verification incomplete');
        state = const RegisterError(
          message:
              'Security verification required. Please complete the verification and try again.',
        );
        onError?.call(
            'Security verification required. Please complete the verification and try again.');
        return;
      }

      final registerRequest = RegisterRequest(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        countryID: countryID,
        role: role,
        recaptchaToken:
            turnstileToken, // Using recaptchaToken field for Turnstile token
      );

      debugPrint('📤 Sending registration request with Turnstile token');

      final registerUseCase = _ref.read(registerUseCaseProvider);

      // Add timeout to prevent infinite loading
      final result = await registerUseCase(registerRequest).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Registration timeout: Please check your internet connection and try again');
        },
      );

      result.fold(
        (failure) {
          debugPrint('❌ Registration failed: ${failure.message}');
          state = RegisterError(
            message: failure.message ?? 'Registration failed',
            isNetworkError: failure.toString().contains('network') ||
                failure.toString().contains('connection'),
          );
          onError?.call(failure.message ?? 'Registration failed');
          debugPrint('🔄 State set to RegisterError');
        },
        (_) {
          debugPrint('✅ Registration successful for: $email');
          state = RegisterSuccess(
            message:
                'Registration successful! Please log in with your credentials.',
            email: email,
          );
          debugPrint('🔄 State set to RegisterSuccess');
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected registration error: $e');
      state = RegisterError(
        message: e.toString().contains('timeout')
            ? 'Registration timeout: Please check your connection and try again'
            : 'An unexpected error occurred during registration. Please try again.',
      );
      onError?.call(e.toString());
      debugPrint('🔄 State set to RegisterError (catch block)');
    }

    debugPrint(
        '🔄 Registration process completed. Final state: ${state.runtimeType}');
  }

  /// Clear error state
  void clearError() {
    if (state is RegisterError) {
      state = const RegisterInitial();
    }
  }

  /// Reset to initial state
  void reset() {
    state = const RegisterInitial();
  }

  /// Check if registration is in progress
  bool get isLoading => state is RegisterLoading;

  /// Get current error message (null if no error)
  String? get errorMessage {
    final currentState = state;
    if (currentState is RegisterError) {
      return currentState.message;
    }
    return null;
  }

  /// Get success message (null if not successful)
  String? get successMessage {
    final currentState = state;
    if (currentState is RegisterSuccess) {
      return currentState.message;
    }
    return null;
  }

  /// Get registered email (null if not successful)
  String? get registeredEmail {
    final currentState = state;
    if (currentState is RegisterSuccess) {
      return currentState.email;
    }
    return null;
  }
}

// =============================================================================
// REGISTER PROVIDERS
// =============================================================================

/// Provider for register state management
final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(ref);
});

/// Provider for checking if registration is in progress
final isRegisterLoadingProvider = Provider<bool>((ref) {
  final registerState = ref.watch(registerNotifierProvider);
  return registerState is RegisterLoading;
});

/// Provider for getting registration error message
final registerErrorProvider = Provider<String?>((ref) {
  final registerState = ref.watch(registerNotifierProvider);
  if (registerState is RegisterError) {
    return registerState.message;
  }
  return null;
});

/// Provider for getting registration success message
final registerSuccessProvider = Provider<String?>((ref) {
  final registerState = ref.watch(registerNotifierProvider);
  if (registerState is RegisterSuccess) {
    return registerState.message;
  }
  return null;
});

/// Provider for getting registered email
final registeredEmailProvider = Provider<String?>((ref) {
  final registerState = ref.watch(registerNotifierProvider);
  if (registerState is RegisterSuccess) {
    return registerState.email;
  }
  return null;
});
