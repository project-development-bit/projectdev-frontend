import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/auth/domain/usecases/forget_password_resend_code_usecase.dart';
import 'package:cointiply_app/features/auth/domain/usecases/verify_code_forgot_password_usecase.dart';
import 'package:cointiply_app/features/user_profile/domain/usecases/verify_email_change_usecase.dart';
import 'package:cointiply_app/features/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/resend_code_request.dart';
import '../../data/models/verify_code_request.dart';
import '../../domain/usecases/resend_code_usecase.dart';
import '../../domain/usecases/verify_code_usecase.dart';
import '../../data/repositories/auth_repo_impl.dart';
import 'package:flutter_riverpod/legacy.dart';

// =============================================================================
// VERIFICATION STATE CLASSES
// =============================================================================

/// Verification state for email verification
@immutable
sealed class VerificationState {
  const VerificationState();
}

/// Initial verification state
class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

/// Verification operation in progress
class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

/// Verification successful
class VerificationSuccess extends VerificationState {
  const VerificationSuccess({required this.message});

  final String message;
}

/// Verification error occurred
class VerificationError extends VerificationState {
  const VerificationError({required this.message, this.isNetworkError = false});

  final String message;
  final bool isNetworkError;
}

/// Resend code successful
class ResendCodeSuccess extends VerificationState {
  const ResendCodeSuccess({required this.message});

  final String message;
}

// =============================================================================
// VERIFICATION STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing email verification operations
class VerificationNotifier extends StateNotifier<VerificationState> {
  final ResendCodeUseCase _resendCodeUseCase;
  final VerifyCodeUseCase _verifyCodeUseCase;
  final ForgetPasswordResendCodeUsecase _forgetPasswordResendCodeUsecase;
  final VerifyCodeForgotPasswordUsecase _verifyCodeForgotPasswordUsecase;
  final VerifyEmailChangeUsecase _verifyEmailChangeUsecase;

  VerificationNotifier(
      this._resendCodeUseCase,
      this._verifyCodeUseCase,
      this._forgetPasswordResendCodeUsecase,
      this._verifyCodeForgotPasswordUsecase,
      this._verifyEmailChangeUsecase)
      : super(const VerificationInitial());

  /// Verify email with the provided code
  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      state = const VerificationLoading();

      // Create request with email and code
      final request = VerifyCodeRequest(email: email, code: code);

      // Call use case to verify code
      final result = await _verifyCodeUseCase(request);

      result.fold(
        (failure) {
          debugPrint('❌ Email verification error: ${failure.message}');
          state = VerificationError(
            message: failure.message ??
                'Invalid verification code. Please try again.',
          );
        },
        (response) {
          debugPrint('✅ Email verification successful for: $email');
          state = VerificationSuccess(
            message: response.message,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected verification error: $e');
      state = const VerificationError(
        message: 'Invalid verification code. Please try again.',
      );
    }
  }

  /// Resend verification code
  Future<void> resendCode({
    required String email,
  }) async {
    try {
      state = const VerificationLoading();

      // Create request with email
      final request = ResendCodeRequest(email: email);

      // Call use case to resend code
      final result = await _resendCodeUseCase(request);

      result.fold(
        (failure) {
          debugPrint('❌ Resend code error: ${failure.message}');
          state = VerificationError(
            message: failure.message ??
                'Failed to resend verification code. Please try again.',
          );
        },
        (response) {
          debugPrint('✅ Verification code resent to: $email');
          state = ResendCodeSuccess(
            message: response.message,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected resend code error: $e');
      state = const VerificationError(
        message: 'Failed to resend verification code. Please try again.',
      );
    }
  }

  Future<void> verifyCodeForForgotPassword({
    required String email,
    required String code,
  }) async {
    try {
      state = const VerificationLoading();

      // Create request with email and code
      final request = VerifyCodeRequest(email: email, code: code);

      // Call use case to verify code
      final result = await _verifyCodeForgotPasswordUsecase(request);

      result.fold(
        (failure) {
          debugPrint('❌ Email verification error: ${failure.message}');
          if (failure is ServerFailure && failure.statusCode == 404) {
            state = VerificationError(
              message: 'Invalid verification code. Please try again.',
            );
          } else {
            state = VerificationError(
              message: failure.message ??
                  'Invalid verification code. Please try again.',
            );
          }
        },
        (response) {
          debugPrint('✅ Email verification successful for: $email');
          state = VerificationSuccess(
            message: response.message,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected verification error: $e');
      state = const VerificationError(
        message: 'Invalid verification code. Please try again.',
      );
    }
  }

  Future<void> resendCodeForForgotPassword({
    required String email,
  }) async {
    try {
      state = const VerificationLoading();

      // Create request with email
      final request = ResendCodeRequest(email: email);

      // Call use case to resend code
      final result = await _forgetPasswordResendCodeUsecase(request);

      result.fold(
        (failure) {
          debugPrint('❌ Resend code error: ${failure.message}');
          state = VerificationError(
            message: failure.message ??
                'Failed to resend verification code. Please try again.',
          );
        },
        (response) {
          debugPrint('✅ Verification code resent to: $email');
          state = ResendCodeSuccess(
            message: response.message,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected resend code error: $e');
      state = const VerificationError(
        message: 'Failed to resend verification code. Please try again.',
      );
    }
  }

  Future<void> verifyEmailChange({
    required String email,
    required String code,
  }) async {
    try {
      state = const VerificationLoading();

      final result = await _verifyEmailChangeUsecase(
        VerifyEmailChangeParams(email: email, code: code),
      );

      result.fold(
        (failure) {
          debugPrint('❌ Email change verification error: ${failure.message}');
          state = VerificationError(
            message: failure.message ??
                'Invalid verification code. Please try again.',
          );
        },
        (response) {
          debugPrint('✅ Email change verification successful for: $email');
          state = VerificationSuccess(
            message: response.message,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected email change verification error: $e');
      state = const VerificationError(
        message: 'Invalid verification code. Please try again.',
      );
    }
  }

  /// Clear error state
  void clearError() {
    if (state is VerificationError) {
      state = const VerificationInitial();
    }
  }

  /// Reset to initial state
  void reset() {
    state = const VerificationInitial();
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Provider for ResendCodeUseCase
final resendCodeUseCaseProvider = Provider<ResendCodeUseCase>((ref) {
  return ResendCodeUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for VerifyCodeUseCase
final verifyCodeUseCaseProvider = Provider<VerifyCodeUseCase>((ref) {
  return VerifyCodeUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for ForgetPasswordResendCodeUsecase
final forgetPasswordResendCodeUsecaseProvider =
    Provider<ForgetPasswordResendCodeUsecase>((ref) {
  return ForgetPasswordResendCodeUsecase(ref.watch(authRepositoryProvider));
});

/// Provider for VerifyCodeForgotPasswordUsecase
final verifyCodeForgotPasswordUsecaseProvider =
    Provider<VerifyCodeForgotPasswordUsecase>((ref) {
  return VerifyCodeForgotPasswordUsecase(ref.watch(authRepositoryProvider));
});

/// Provider for verification state notifier
final verificationNotifierProvider =
    StateNotifierProvider.autoDispose<VerificationNotifier, VerificationState>(
        (ref) => VerificationNotifier(
              ref.watch(resendCodeUseCaseProvider),
              ref.watch(verifyCodeUseCaseProvider),
              ref.watch(forgetPasswordResendCodeUsecaseProvider),
              ref.watch(verifyCodeForgotPasswordUsecaseProvider),
              ref.watch(verifyEmailChangeUseCaseProvider),
            ));

/// Provider for checking if verification is loading
final isVerificationLoadingProvider = Provider<bool>((ref) {
  final verificationState = ref.watch(verificationNotifierProvider);
  return verificationState is VerificationLoading;
});
