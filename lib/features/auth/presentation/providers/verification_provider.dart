import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/verification_request.dart';

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
  VerificationNotifier() : super(const VerificationInitial());

  /// Verify email with the provided code
  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      state = const VerificationLoading();
      
      final verificationRequest = VerificationRequest(
        email: email,
        code: code,
      );
      
      // For now, we'll simulate the verification
      // TODO: Replace with actual API call when backend is ready
      await _simulateVerification(verificationRequest);
      
      debugPrint('✅ Email verification successful for: $email');
      state = const VerificationSuccess(
        message: 'Email verified successfully! You can now log in.',
      );
    } catch (e) {
      debugPrint('❌ Email verification error: $e');
      state = VerificationError(
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
      
      // For now, we'll simulate the resend
      // TODO: Replace with actual API call when backend is ready
      await _simulateResendCode(email);
      
      debugPrint('✅ Verification code resent to: $email');
      state = const ResendCodeSuccess(
        message: 'Verification code sent successfully! Please check your email.',
      );
    } catch (e) {
      debugPrint('❌ Resend code error: $e');
      state = VerificationError(
        message: 'Failed to resend verification code. Please try again.',
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

  // =============================================================================
  // PRIVATE METHODS (SIMULATION - REPLACE WITH ACTUAL API CALLS)
  // =============================================================================

  /// Simulate email verification (replace with actual API call)
  Future<void> _simulateVerification(VerificationRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simple validation for demo purposes
    if (request.code.length != 4) {
      throw Exception('Invalid code length');
    }
    
    // For demo: accept "1234" as valid code, reject others
    if (request.code != "1234") {
      throw Exception('Invalid verification code');
    }
  }

  /// Simulate resend code (replace with actual API call)
  Future<void> _simulateResendCode(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple email validation
    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Provider for verification state notifier
final verificationNotifierProvider = StateNotifierProvider<VerificationNotifier, VerificationState>(
  (ref) => VerificationNotifier(),
);

/// Provider for checking if verification is loading
final isVerificationLoadingProvider = Provider<bool>((ref) {
  final verificationState = ref.watch(verificationNotifierProvider);
  return verificationState is VerificationLoading;
});