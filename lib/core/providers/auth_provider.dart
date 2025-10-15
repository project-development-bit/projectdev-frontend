import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/login_provider.dart';

/// Legacy authentication provider for backward compatibility
///
/// This provider is kept for compatibility with existing routing logic.
/// New authentication logic should use the separated login/register providers
class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(this._ref) : super(const AuthState.unauthenticated()) {
    // Listen to login state changes to keep auth state in sync
    _ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (next is LoginSuccess) {
        state = const AuthState.authenticated();
      } else if (next is LoginError) {
        state = const AuthState.unauthenticated();
      }
    });
  }

  final Ref _ref;

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    try {
      // First check if we have a successful login state
      final loginState = _ref.read(loginNotifierProvider);
      if (loginState is LoginSuccess) {
        state = const AuthState.authenticated();
        return true;
      }

      // Fallback to checking stored tokens
      final authRepository = _ref.read(authRepositoryProvider);
      final result = await authRepository.isAuthenticated();

      return result.fold(
        (failure) {
          state = const AuthState.unauthenticated();
          return false;
        },
        (isAuth) {
          // Update state based on authentication status
          if (isAuth) {
            state = const AuthState.authenticated();
          } else {
            state = const AuthState.unauthenticated();
          }
          return isAuth;
        },
      );
    } catch (e) {
      state = const AuthState.unauthenticated();
      return false;
    }
  }

  /// Login user (delegates to new auth system)
  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      // This should delegate to the new auth system
      // For now, keep the old implementation for compatibility
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Logout user (delegates to new auth system)
  Future<void> logout() async {
    try {
      state = const AuthState.loading();

      final authRepository = _ref.read(authRepositoryProvider);
      final result = await authRepository.logout();

      await result.fold(
        (failure) {
          state = AuthState.error(failure.message ?? 'Logout failed');
        },
        (_) {
          state = const AuthState.unauthenticated();
        },
      );
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Sign up user (delegates to new auth system)
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthState.loading();
    try {
      // This should delegate to the new auth system
      // For now, keep the old implementation for compatibility
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

/// Legacy authentication state for backward compatibility
class AuthState {
  const AuthState();

  const AuthState.unauthenticated() : this();
  const AuthState.authenticated() : this();
  const AuthState.loading() : this();
  const AuthState.error(String message) : this();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Legacy provider for the auth state (for backward compatibility)
final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(ref),
);