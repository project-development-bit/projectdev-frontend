import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../data/models/reset_password_request.dart';
import '../../data/models/reset_password_response.dart';
import '../../../../core/error/failures.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider for reset password functionality
final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  (ref) => ResetPasswordNotifier(ref.watch(authRepositoryProvider)),
);

/// State for reset password operations
sealed class ResetPasswordState {}

/// Initial state
class ResetPasswordInitial extends ResetPasswordState {}

/// Loading state when sending reset password request
class ResetPasswordLoading extends ResetPasswordState {}

/// Success state with reset password response
/// Note: We don't store tokens as user should navigate to login
class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponse response;

  ResetPasswordSuccess(this.response);
}

/// Error state with failure message
class ResetPasswordError extends ResetPasswordState {
  final String message;
  final int? statusCode;

  ResetPasswordError(this.message, {this.statusCode});
}

/// Notifier for reset password operations
class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final AuthRepository _authRepository;

  ResetPasswordNotifier(this._authRepository) : super(ResetPasswordInitial());

  /// Reset password with new password
  Future<void> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validate inputs
    final validationError = _validateInputs(email, password, confirmPassword);
    if (validationError != null) {
      state = ResetPasswordError(validationError);
      return;
    }

    state = ResetPasswordLoading();

    final request = ResetPasswordRequest(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    final result = await _authRepository.resetPassword(request);

    result.fold(
      (failure) {
        state = ResetPasswordError(
          _getFailureMessage(failure),
          statusCode: failure is ServerFailure ? failure.statusCode : null,
        );
      },
      (response) {
        // Successfully reset password
        // Note: We don't store tokens since user should login again
        state = ResetPasswordSuccess(response);
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = ResetPasswordInitial();
  }

  /// Validate all inputs
  String? _validateInputs(
      String email, String password, String confirmPassword) {
    if (!_isValidEmail(email)) {
      return 'Please enter a valid email address';
    }

    if (password.isEmpty) {
      return 'Please enter a password';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null; // All validations passed
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Convert failure to user-friendly message
  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      // Check for specific error messages from server
      if (failure.message?.contains('email') == true) {
        return 'Invalid email address';
      }
      if (failure.message?.contains('password') == true) {
        return 'Password requirements not met';
      }
      if (failure.message?.contains('not found') == true) {
        return 'Email not found in our system';
      }
      if (failure.statusCode == 400) {
        return failure.message ?? 'Invalid request. Please check your input';
      }
      if (failure.statusCode == 401) {
        return 'Unauthorized. Please verify your email first';
      }
      if (failure.statusCode == 429) {
        return 'Too many requests. Please wait and try again';
      }
      if (failure.statusCode == 500) {
        return 'Server error. Please try again later';
      }

      return failure.message ?? 'Failed to reset password';
    }

    return 'An unexpected error occurred. Please try again';
  }
}

/// Convenience providers for specific states
final isResetPasswordLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(resetPasswordProvider);
  return state is ResetPasswordLoading;
});

final resetPasswordErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(resetPasswordProvider);
  if (state is ResetPasswordError) {
    return state.message;
  }
  return null;
});

final resetPasswordSuccessProvider = Provider<ResetPasswordResponse?>((ref) {
  final state = ref.watch(resetPasswordProvider);
  if (state is ResetPasswordSuccess) {
    return state.response;
  }
  return null;
});
