import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import '../config/flavor_manager.dart';
import '../config/app_flavor.dart';

// =============================================================================
// RECAPTCHA STATE CLASSES
// =============================================================================

/// reCAPTCHA verification state
@immutable
sealed class RecaptchaState {
  const RecaptchaState();
}

/// Initial state - reCAPTCHA not initialized
class RecaptchaInitial extends RecaptchaState {
  const RecaptchaInitial();
}

/// reCAPTCHA is being initialized
class RecaptchaInitializing extends RecaptchaState {
  const RecaptchaInitializing();
}

/// reCAPTCHA ready for verification
class RecaptchaReady extends RecaptchaState {
  const RecaptchaReady();
}

/// reCAPTCHA verification in progress
class RecaptchaVerifying extends RecaptchaState {
  const RecaptchaVerifying();
}

/// reCAPTCHA verification successful
class RecaptchaVerified extends RecaptchaState {
  const RecaptchaVerified({required this.token});
  
  final String token;
}

/// reCAPTCHA verification failed or error occurred
class RecaptchaError extends RecaptchaState {
  const RecaptchaError({required this.message, this.isInitializationError = false});
  
  final String message;
  final bool isInitializationError;
}

/// reCAPTCHA not available (development mode or not configured)
class RecaptchaNotAvailable extends RecaptchaState {
  const RecaptchaNotAvailable({this.reason = 'reCAPTCHA not available'});
  
  final String reason;
}

// =============================================================================
// RECAPTCHA NOTIFIER
// =============================================================================

/// StateNotifier for managing reCAPTCHA verification
class RecaptchaNotifier extends StateNotifier<RecaptchaState> {
  RecaptchaNotifier() : super(const RecaptchaInitial()) {
    _initialize();
  }

  /// Initialize reCAPTCHA based on current environment
  Future<void> _initialize() async {
    final config = FlavorManager.currentConfig;
    
    // Don't initialize reCAPTCHA in development mode
    if (config.flavor == AppFlavor.dev) {
      state = const RecaptchaNotAvailable(reason: 'reCAPTCHA disabled in development mode');
      return;
    }

    // Check if site key is configured
    final siteKey = config.recaptchaSiteKey;
    if (siteKey == null || siteKey.isEmpty) {
      state = const RecaptchaNotAvailable(reason: 'reCAPTCHA site key not configured');
      return;
    }

    state = const RecaptchaInitializing();

    try {
      await GRecaptchaV3.ready(siteKey);
      state = const RecaptchaReady();
    } catch (e) {
      state = RecaptchaError(
        message: 'Failed to initialize reCAPTCHA: $e',
        isInitializationError: true,
      );
    }
  }

  /// Execute reCAPTCHA verification for the given action
  Future<void> verify({String action = 'login'}) async {
    // Only proceed if reCAPTCHA is ready
    if (state is! RecaptchaReady && state is! RecaptchaVerified) {
      // If not ready, try to reinitialize
      if (state is RecaptchaError || state is RecaptchaInitial) {
        await _initialize();
        if (state is! RecaptchaReady) {
          return; // Still not ready
        }
      } else {
        return; // Not available or still initializing
      }
    }

    state = const RecaptchaVerifying();

    try {
      final config = FlavorManager.currentConfig;
      final siteKey = config.recaptchaSiteKey;
      
      if (siteKey == null || siteKey.isEmpty) {
        throw Exception('reCAPTCHA site key not configured');
      }

      final token = await GRecaptchaV3.execute(action);
      
      if (token != null && token.isNotEmpty) {
        state = RecaptchaVerified(token: token);
      } else {
        throw Exception('Failed to get reCAPTCHA token');
      }
    } catch (e) {
      state = RecaptchaError(message: 'reCAPTCHA verification failed: $e');
    }
  }

  /// Reset verification state
  void reset() {
    if (state is RecaptchaVerified || state is RecaptchaError) {
      final config = FlavorManager.currentConfig;
      
      if (config.flavor == AppFlavor.dev) {
        state = const RecaptchaNotAvailable(reason: 'reCAPTCHA disabled in development mode');
      } else if (config.recaptchaSiteKey == null || config.recaptchaSiteKey!.isEmpty) {
        state = const RecaptchaNotAvailable(reason: 'reCAPTCHA site key not configured');
      } else {
        state = const RecaptchaReady();
      }
    }
  }

  /// Check if reCAPTCHA verification is required for current environment
  bool get isRequired {
    final config = FlavorManager.currentConfig;
    return config.flavor != AppFlavor.dev && 
           config.recaptchaSiteKey != null && 
           config.recaptchaSiteKey!.isNotEmpty;
  }

  /// Get current verification token (null if not verified)
  String? get verificationToken {
    final currentState = state;
    if (currentState is RecaptchaVerified) {
      return currentState.token;
    }
    return null;
  }
}

// =============================================================================
// RECAPTCHA PROVIDERS
// =============================================================================

/// Provider for reCAPTCHA state management
final recaptchaNotifierProvider = StateNotifierProvider<RecaptchaNotifier, RecaptchaState>((ref) {
  return RecaptchaNotifier();
});

/// Provider for checking if reCAPTCHA is required
final isRecaptchaRequiredProvider = Provider<bool>((ref) {
  final notifier = ref.read(recaptchaNotifierProvider.notifier);
  return notifier.isRequired;
});

/// Provider for checking if reCAPTCHA is available
final isRecaptchaAvailableProvider = Provider<bool>((ref) {
  final state = ref.watch(recaptchaNotifierProvider);
  return state is! RecaptchaNotAvailable;
});

/// Provider for checking if reCAPTCHA is verified
final isRecaptchaVerifiedProvider = Provider<bool>((ref) {
  final state = ref.watch(recaptchaNotifierProvider);
  return state is RecaptchaVerified;
});

/// Provider for checking if reCAPTCHA is loading (initializing or verifying)
final isRecaptchaLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(recaptchaNotifierProvider);
  return state is RecaptchaInitializing || state is RecaptchaVerifying;
});

/// Provider for getting reCAPTCHA error message
final recaptchaErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(recaptchaNotifierProvider);
  if (state is RecaptchaError) {
    return state.message;
  }
  return null;
});

/// Provider for getting reCAPTCHA verification token
final recaptchaTokenProvider = Provider<String?>((ref) {
  final notifier = ref.read(recaptchaNotifierProvider.notifier);
  return notifier.verificationToken;
});

/// Provider for checking if reCAPTCHA can be verified
final canVerifyRecaptchaProvider = Provider<bool>((ref) {
  final state = ref.watch(recaptchaNotifierProvider);
  return state is RecaptchaReady || state is RecaptchaVerified;
});