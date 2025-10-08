import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple authentication provider for managing user auth state
class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider() : super(const AuthState.unauthenticated());

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    // TODO: Implement actual authentication check
    // This could check for stored tokens, validate with backend, etc.
    return state == const AuthState.authenticated();
  }

  /// Login user
  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      // TODO: Implement actual login logic
      // Make API call, store tokens, etc.
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Logout user
  Future<void> logout() async {
    // TODO: Implement actual logout logic
    // Clear tokens, clear local storage, etc.
    state = const AuthState.unauthenticated();
  }

  /// Sign up user
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthState.loading();
    try {
      // TODO: Implement actual signup logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

/// Authentication state
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

/// Provider for the auth state
final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(),
);