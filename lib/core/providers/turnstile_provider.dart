import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Turnstile state management
@immutable
sealed class TurnstileState {
  const TurnstileState();
}

class TurnstileInitial extends TurnstileState {
  const TurnstileInitial();
}

class TurnstileLoading extends TurnstileState {
  const TurnstileLoading();
}

class TurnstileSuccess extends TurnstileState {
  final String token;
  const TurnstileSuccess(this.token);
}

class TurnstileError extends TurnstileState {
  final String message;
  const TurnstileError(this.message);
}

class TurnstileExpired extends TurnstileState {
  const TurnstileExpired();
}

/// Turnstile notifier
class TurnstileNotifier extends StateNotifier<TurnstileState> {
  TurnstileNotifier() : super(const TurnstileInitial());

  TurnstileController? _controller;
  bool _isInitializing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  /// Initialize the controller with better retry logic
  Future<void> initializeController() async {
    if (_isInitializing || _controller != null) {
      debugPrint('⚠️ Turnstile controller already initializing or initialized');
      return;
    }

    _isInitializing = true;
    _retryCount = 0;

    await _attemptInitialization();
  }

  Future<void> _attemptInitialization() async {
    try {
      debugPrint(
          '🔄 Attempting Turnstile initialization (attempt ${_retryCount + 1}/$_maxRetries)');

      // Wait longer for Turnstile API to be available
      final delay = Duration(milliseconds: 300 * (_retryCount + 1));
      await Future.delayed(delay);

      // Check if running on web
      if (kIsWeb) {
        debugPrint('🌐 Running on web platform');
      }

      _controller = TurnstileController();
      debugPrint('✅ Turnstile controller created successfully');
      _isInitializing = false;
      _retryCount = 0;
    } catch (e) {
      debugPrint('❌ Failed to create Turnstile controller: $e');
      _retryCount++;

      if (_retryCount < _maxRetries) {
        debugPrint('🔄 Retrying in ${300 * _retryCount}ms...');
        await _attemptInitialization();
      } else {
        debugPrint('❌ Max retries reached. Initialization failed.');
        _isInitializing = false;
        state = TurnstileError(
            'Failed to load security verification. Please check:\n'
            '1. Your internet connection\n'
            '2. That the site key is correct\n'
            '3. That your domain is authorized in Cloudflare\n'
            'Then refresh the page.');
      }
    }
  }

  /// Get the controller
  TurnstileController? get controller => _controller;

  /// Check if controller is ready
  bool get isControllerReady => _controller != null && !_isInitializing;

  /// Handle token received
  void onTokenReceived(String token) {
    debugPrint('🔐 Turnstile token received: ${token.substring(0, 20)}...');
    state = TurnstileSuccess(token);
  }

  /// Handle token expired
  void onTokenExpired() {
    debugPrint('⏰ Turnstile token expired');
    state = const TurnstileExpired();
  }

  /// Handle error
  void onTurnstileError(String message) {
    debugPrint('❌ Turnstile error: $message');
    state = TurnstileError(message);
  }

  /// Set loading state
  void setLoading() {
    debugPrint('🔄 Turnstile loading...');
    state = const TurnstileLoading();
  }

  /// Reset state
  void reset() {
    debugPrint('🔄 Turnstile reset');
    state = const TurnstileInitial();
  }

  /// Refresh token
  Future<void> refreshToken() async {
    if (_controller != null) {
      setLoading();
      try {
        await _controller!.refreshToken();
      } catch (e) {
        onTurnstileError('Failed to refresh token: $e');
      }
    }
  }

  /// Check if token is expired
  Future<bool> isExpired() async {
    if (_controller != null) {
      try {
        return await _controller!.isExpired();
      } catch (e) {
        debugPrint('Error checking token expiry: $e');
        return true;
      }
    }
    return true;
  }

  /// Dispose controller
  void disposeController() {
    _controller?.dispose();
    _controller = null;
    _isInitializing = false;
    _retryCount = 0;
  }

  /// Get current token
  String? get token {
    final currentState = state;
    return currentState is TurnstileSuccess ? currentState.token : null;
  }

  /// Check if verified
  bool get isVerified => state is TurnstileSuccess;

  /// Check if loading
  bool get isLoading => state is TurnstileLoading;

  /// Check if has error
  bool get hasError => state is TurnstileError;

  /// Check if current state is expired
  bool get isTokenExpired => state is TurnstileExpired;

  /// Get error message
  String? get errorMessage {
    final currentState = state;
    return currentState is TurnstileError ? currentState.message : null;
  }
}

/// Provider instances
/// Turnstile notifier provider
final turnstileNotifierProvider =
    StateNotifierProvider<TurnstileNotifier, TurnstileState>((ref) {
  return TurnstileNotifier();
});

/// Provider that checks if login can be attempted based on Turnstile verification
final turnstileCanAttemptLoginProvider = Provider<bool>((ref) {
  final turnstileState = ref.watch(turnstileNotifierProvider);
  return turnstileState is TurnstileSuccess;
});

/// Provider that provides the current Turnstile token (if available)
final turnstileTokenProvider = Provider<String?>((ref) {
  final turnstileState = ref.watch(turnstileNotifierProvider);
  return turnstileState is TurnstileSuccess ? turnstileState.token : null;
});

/// Convenience providers
final isTurnstileVerifiedProvider = Provider<bool>((ref) {
  return ref.watch(turnstileNotifierProvider.notifier).isVerified;
});

final isTurnstileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(turnstileNotifierProvider.notifier).isLoading;
});

final turnstileErrorProvider = Provider<String?>((ref) {
  return ref.watch(turnstileNotifierProvider.notifier).errorMessage;
});

/// Provider to check if controller is ready
final turnstileControllerReadyProvider = Provider<bool>((ref) {
  return ref.watch(turnstileNotifierProvider.notifier).isControllerReady;
});
