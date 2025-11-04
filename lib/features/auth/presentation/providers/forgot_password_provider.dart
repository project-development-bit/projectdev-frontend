import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../data/models/forgot_password_request.dart';
import '../../data/models/forgot_password_response.dart';
import '../../../../core/error/failures.dart';

/// Provider for forgot password functionality
final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  (ref) => ForgotPasswordNotifier(ref.watch(authRepositoryProvider)),
);

/// State for forgot password operations
sealed class ForgotPasswordState {}

/// Initial state
class ForgotPasswordInitial extends ForgotPasswordState {}

/// Loading state when sending forgot password request
class ForgotPasswordLoading extends ForgotPasswordState {}

/// Success state with forgot password response
class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponse response;

  ForgotPasswordSuccess(this.response);
}

/// Error state with failure message
class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  final int? statusCode;

  ForgotPasswordError(this.message, {this.statusCode});
}

/// Notifier for forgot password operations
class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordNotifier(this._authRepository) : super(ForgotPasswordInitial());

  /// Send forgot password request with Turnstile token
  Future<void> forgotPassword(String email, String turnstileToken) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      state = ForgotPasswordError('Please enter a valid email address');
      return;
    }

    state = ForgotPasswordLoading();

    final request = ForgotPasswordRequest(
      email: email,
      recaptchaToken: turnstileToken,
    );
    final result = await _authRepository.forgotPassword(request);

    result.fold(
      (failure) {
        state = ForgotPasswordError(
          _getFailureMessage(failure),
          statusCode: failure is ServerFailure ? failure.statusCode : null,
        );
      },
      (response) {
        state = ForgotPasswordSuccess(response);
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = ForgotPasswordInitial();
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Extract error message from failure
  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Server error occurred';
    }
    return 'An unexpected error occurred';
  }
}
