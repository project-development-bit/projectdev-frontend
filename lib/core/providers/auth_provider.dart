import 'package:gigafaucet/core/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/login_provider.dart';
import '../../features/auth/presentation/providers/logout_provider.dart';

/// Legacy authentication provider for backward compatibility
///
/// This provider is kept for compatibility with existing routing logic.
/// New authentication logic should use the separated login/register providers
class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(this._ref) : super(const AuthStateUnauthenticated()) {
    // Initialize auth state by checking stored tokens
    _initializeAuthState();

    // Listen to login state changes to keep auth state in sync
    _ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (next is LoginSuccess) {
        state = const AuthStateAuthenticated();
      } else if (next is LoginError) {
        state = const AuthStateUnauthenticated();
      }
    });

    // Listen to logout state changes to keep auth state in sync
    _ref.listen<LogoutState>(logoutNotifierProvider, (previous, next) {
      if (next is LogoutSuccess) {
        state = const AuthStateUnauthenticated();
      }
    });
  }

  final Ref _ref;

  /// Initialize auth state by checking stored tokens
  Future<void> _initializeAuthState() async {
    try {
      final secureStorage = _ref.read(secureStorageServiceProvider);
      final accessToken = await secureStorage.getAuthToken();
      final userId = await secureStorage.getUserId();

      if (accessToken != null &&
          accessToken.isNotEmpty &&
          userId != null &&
          userId.isNotEmpty) {
        state = const AuthStateAuthenticated();
      } else {
        state = const AuthStateUnauthenticated();
      }
    } catch (e) {
      state = const AuthStateUnauthenticated();
    }
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    try {
      // First check if we have a successful login state
      final loginState = _ref.read(loginNotifierProvider);
      if (loginState is LoginSuccess) {
        state = const AuthStateAuthenticated();
        return true;
      }

      // Fallback to checking stored tokens
      final authRepository = _ref.read(authRepositoryProvider);
      final result = await authRepository.isAuthenticated();

      return result.fold(
        (failure) {
          state = const AuthStateUnauthenticated();
          return false;
        },
        (isAuth) {
          // Update state based on authentication status
          if (isAuth) {
            state = const AuthStateAuthenticated();
          } else {
            state = const AuthStateUnauthenticated();
          }
          return isAuth;
        },
      );
    } catch (e) {
      state = const AuthStateUnauthenticated();
      return false;
    }
  }

  /// Login user (delegates to new auth system)
  Future<void> login({required String email, required String password}) async {
    state = const AuthStateLoading();
    try {
      // This should delegate to the new auth system
      // For now, keep the old implementation for compatibility
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      state = const AuthStateAuthenticated();
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  /// Logout user (delegates to new auth system)
  Future<void> logout() async {
    try {
      state = const AuthStateLoading();

      final authRepository = _ref.read(authRepositoryProvider);
      final result = await authRepository.logout();

      await result.fold(
        (failure) {
          state = AuthStateError(failure.message ?? 'Logout failed');
        },
        (_) {
          state = const AuthStateUnauthenticated();
        },
      );
    } catch (e) {
      state = const AuthStateUnauthenticated();
    }
  }

  /// Sign up user (delegates to new auth system)
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthStateLoading();
    try {
      // This should delegate to the new auth system
      // For now, keep the old implementation for compatibility
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      state = const AuthStateAuthenticated();
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }
}

/// Legacy authentication state for backward compatibility
sealed class AuthState {
  const AuthState();
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateError extends AuthState {
  const AuthStateError(this.message);
  final String message;
}

/// Convenience getters for AuthState
extension AuthStateExtension on AuthState {
  bool get isAuthenticated => this is AuthStateAuthenticated;
  bool get isUnauthenticated => this is AuthStateUnauthenticated;
  bool get isLoading => this is AuthStateLoading;
  bool get isError => this is AuthStateError;
  String? get errorMessage =>
      this is AuthStateError ? (this as AuthStateError).message : null;
}

/// Legacy provider for the auth state (for backward compatibility)
final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(ref),
);

/// Observable authentication status provider (synchronous)
/// This provider automatically updates when login/logout state changes
/// Returns the immediate auth state without async token checking
final isAuthenticatedObservableProvider = Provider<bool>((ref) {
  // Watch login state for immediate updates - highest priority
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginSuccess) {
    return true;
  }

  // Watch logout state for immediate updates
  final logoutState = ref.watch(logoutNotifierProvider);
  if (logoutState is LogoutSuccess) {
    return false;
  }

  // Watch the auth state as fallback
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

/// Observable authentication status provider with token validation (async)
/// This provider checks if access token actually exists in storage
final isAuthenticatedWithTokenProvider = FutureProvider<bool>((ref) async {
  // Watch login state for immediate updates
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginSuccess) {
    return true;
  }

  // Watch logout state for immediate updates
  final logoutState = ref.watch(logoutNotifierProvider);
  if (logoutState is LogoutSuccess) {
    return false;
  }

  // Check if access token exists in storage
  try {
    final secureStorage = ref.watch(secureStorageServiceProvider);
    final accessToken = await secureStorage.getAuthToken();
    final userId = await secureStorage.getUserId();
    return accessToken != null &&
        accessToken.isNotEmpty &&
        userId != null &&
        userId.isNotEmpty;
  } catch (e) {
    return false;
  }
});

/// Async version of authentication status provider
/// Use this when you need to check stored tokens
final isAuthenticatedAsyncProvider = FutureProvider<bool>((ref) async {
  // Watch for state changes to invalidate this provider
  ref.watch(loginNotifierProvider);
  ref.watch(logoutNotifierProvider);

  try {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.isAuthenticated();

    return result.fold(
      (failure) => false,
      (isAuth) => isAuth,
    );
  } catch (e) {
    return false;
  }
});
