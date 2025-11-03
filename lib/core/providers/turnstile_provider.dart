import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';

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
  
  /// Initialize the controller
  void initializeController() {
    _controller = TurnstileController();
  }
  
  /// Get the controller
  TurnstileController? get controller => _controller;
  
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
final turnstileNotifierProvider = StateNotifierProvider<TurnstileNotifier, TurnstileState>((ref) {
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