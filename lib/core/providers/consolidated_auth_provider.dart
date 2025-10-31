import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/login_provider.dart';
import '../../features/auth/presentation/providers/logout_provider.dart';
import '../../features/auth/presentation/providers/register_provider.dart';
import '../../features/auth/presentation/providers/forgot_password_provider.dart';
import '../../features/auth/presentation/providers/reset_password_provider.dart';
import 'recaptcha_provider.dart';
import 'auth_provider.dart';

// =============================================================================
// CONSOLIDATED AUTH STATE
// =============================================================================

/// Consolidated authentication state that combines all auth-related providers
class ConsolidatedAuthState {
  const ConsolidatedAuthState({
    required this.loginState,
    required this.logoutState,
    required this.registerState,
    required this.forgotPasswordState,
    required this.resetPasswordState,
    required this.recaptchaState,
    required this.isAuthenticated,
    required this.isRecaptchaVerified,
    required this.isRecaptchaRequired,
  });

  final LoginState loginState;
  final LogoutState logoutState;
  final RegisterState registerState;
  final ForgotPasswordState forgotPasswordState;
  final ResetPasswordState resetPasswordState;
  final RecaptchaState recaptchaState;
  final bool isAuthenticated;
  final bool isRecaptchaVerified;
  final bool isRecaptchaRequired;

  /// Check if any authentication operation is in progress
  bool get isLoading {
    return loginState is LoginLoading ||
        logoutState is LogoutLoading ||
        registerState is RegisterLoading ||
        forgotPasswordState is ForgotPasswordLoading ||
        resetPasswordState is ResetPasswordLoading ||
        recaptchaState is RecaptchaInitializing ||
        recaptchaState is RecaptchaVerifying;
  }

  /// Check if authentication is ready (not loading and authenticated)
  bool get isAuthReady {
    return isAuthenticated && !isLoading;
  }

  /// Check if login can be attempted (not loading and reCAPTCHA verified if required)
  bool get canAttemptLogin {
    return !isLoading && (!isRecaptchaRequired || isRecaptchaVerified);
  }

  /// Get current user from successful login state
  dynamic get currentUser {
    if (loginState is LoginSuccess) {
      return (loginState as LoginSuccess).user;
    }
    return null;
  }

  /// Get current authentication token from successful login state
  String? get authToken {
    if (loginState is LoginSuccess) {
      final loginResponse = (loginState as LoginSuccess).loginResponse;
      return loginResponse.tokens.accessToken;
    }
    return null;
  }

  /// Get any current error message from auth operations
  String? get currentError {
    if (loginState is LoginError) {
      return (loginState as LoginError).message;
    }
    if (logoutState is LogoutError) {
      return (logoutState as LogoutError).message;
    }
    if (registerState is RegisterError) {
      return (registerState as RegisterError).message;
    }
    if (forgotPasswordState is ForgotPasswordError) {
      return (forgotPasswordState as ForgotPasswordError).message;
    }
    if (resetPasswordState is ResetPasswordError) {
      return (resetPasswordState as ResetPasswordError).message;
    }
    if (recaptchaState is RecaptchaError) {
      return (recaptchaState as RecaptchaError).message;
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsolidatedAuthState &&
        other.loginState == loginState &&
        other.logoutState == logoutState &&
        other.registerState == registerState &&
        other.forgotPasswordState == forgotPasswordState &&
        other.resetPasswordState == resetPasswordState &&
        other.recaptchaState == recaptchaState &&
        other.isAuthenticated == isAuthenticated &&
        other.isRecaptchaVerified == isRecaptchaVerified &&
        other.isRecaptchaRequired == isRecaptchaRequired;
  }

  @override
  int get hashCode {
    return Object.hash(
      loginState,
      logoutState,
      registerState,
      forgotPasswordState,
      resetPasswordState,
      recaptchaState,
      isAuthenticated,
      isRecaptchaVerified,
      isRecaptchaRequired,
    );
  }

  @override
  String toString() {
    return 'ConsolidatedAuthState('
        'loginState: $loginState, '
        'logoutState: $logoutState, '
        'registerState: $registerState, '
        'forgotPasswordState: $forgotPasswordState, '
        'resetPasswordState: $resetPasswordState, '
        'recaptchaState: $recaptchaState, '
        'isAuthenticated: $isAuthenticated, '
        'isRecaptchaVerified: $isRecaptchaVerified, '
        'isRecaptchaRequired: $isRecaptchaRequired)';
  }
}

// =============================================================================
// CONSOLIDATED AUTH PROVIDERS
// =============================================================================

/// Provider that consolidates all authentication-related states
final consolidatedAuthStateProvider = Provider<ConsolidatedAuthState>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  final logoutState = ref.watch(logoutNotifierProvider);
  final registerState = ref.watch(registerNotifierProvider);
  final forgotPasswordState = ref.watch(forgotPasswordProvider);
  final resetPasswordState = ref.watch(resetPasswordProvider);
  final recaptchaState = ref.watch(recaptchaNotifierProvider);
  final isAuthenticated = ref.watch(isAuthenticatedObservableProvider);
  final isRecaptchaVerified = ref.watch(isRecaptchaVerifiedProvider);
  final isRecaptchaRequired = ref.watch(isRecaptchaRequiredProvider);

  return ConsolidatedAuthState(
    loginState: loginState,
    logoutState: logoutState,
    registerState: registerState,
    forgotPasswordState: forgotPasswordState,
    resetPasswordState: resetPasswordState,
    recaptchaState: recaptchaState,
    isAuthenticated: isAuthenticated,
    isRecaptchaVerified: isRecaptchaVerified,
    isRecaptchaRequired: isRecaptchaRequired,
  );
});

/// Provider for checking if any auth operation is in progress
final isAnyAuthLoadingProvider = Provider<bool>((ref) {
  final consolidatedState = ref.watch(consolidatedAuthStateProvider);
  return consolidatedState.isLoading;
});

/// Provider for checking if authentication is ready
final isAuthReadyProvider = Provider<bool>((ref) {
  final consolidatedState = ref.watch(consolidatedAuthStateProvider);
  return consolidatedState.isAuthReady;
});

/// Provider for checking if login can be attempted
final canAttemptLoginProvider = Provider<bool>((ref) {
  final consolidatedState = ref.watch(consolidatedAuthStateProvider);
  return consolidatedState.canAttemptLogin;
});

/// Provider for getting current user
final currentUserProvider = Provider<dynamic>((ref) {
  final consolidatedState = ref.watch(consolidatedAuthStateProvider);
  return consolidatedState.currentUser;
});

/// Provider for getting current auth token
final currentAuthTokenProvider = Provider<String?>((ref) {
  final consolidatedState = ref.watch(consolidatedAuthStateProvider);
  return consolidatedState.authToken;
});

/// Provider for getting current auth error
final currentAuthErrorProvider = Provider<String?>((ref) {
  final consolidatedState = ref.watch(consolidatedAuthStateProvider);
  return consolidatedState.currentError;
});

// =============================================================================
// AUTH ACTIONS PROVIDER
// =============================================================================

/// Provider that provides authentication actions
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref);
});

/// Class containing all authentication actions
class AuthActions {
  const AuthActions(this._ref);

  final Ref _ref;

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    final loginNotifier = _ref.read(loginNotifierProvider.notifier);
    await loginNotifier.login(
        email: email,
        password: password,
        onError: onError,
        onSuccess: onSuccess);
  }

  /// Logout current user
  Future<void> logout() async {
    final logoutNotifier = _ref.read(logoutNotifierProvider.notifier);
    await logoutNotifier.logout();
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    dynamic role, // UserRole - made dynamic to avoid import issues
  }) async {
    final registerNotifier = _ref.read(registerNotifierProvider.notifier);
    await registerNotifier.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
      role: role,
    );
  }

  /// Send forgot password email
  Future<void> forgotPassword({required String email}) async {
    final forgotPasswordNotifier = _ref.read(forgotPasswordProvider.notifier);
    await forgotPasswordNotifier.forgotPassword(email);
  }

  /// Reset password with new password
  Future<void> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final resetPasswordNotifier = _ref.read(resetPasswordProvider.notifier);
    await resetPasswordNotifier.resetPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  /// Verify reCAPTCHA
  Future<void> verifyRecaptcha({String action = 'login'}) async {
    final recaptchaNotifier = _ref.read(recaptchaNotifierProvider.notifier);
    await recaptchaNotifier.verify(action: action);
  }

  /// Reset reCAPTCHA verification
  void resetRecaptcha() {
    final recaptchaNotifier = _ref.read(recaptchaNotifierProvider.notifier);
    recaptchaNotifier.reset();
  }

  /// Reset all auth states
  void resetAllStates() {
    _ref.read(loginNotifierProvider.notifier).reset();
    // Note: LogoutNotifier doesn't have a reset method
    _ref.read(recaptchaNotifierProvider.notifier).reset();
  }
}
