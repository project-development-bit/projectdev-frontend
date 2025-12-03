import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/secure_storage_service.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? token;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorageService _secureStorage;

  AuthNotifier(this._secureStorage) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await _secureStorage.getAuthToken();
    final userId = await _secureStorage.getUserId();

    state = state.copyWith(
      isAuthenticated: token != null && token.isNotEmpty,
      token: token,
      userId: userId,
    );
  }

  Future<void> signIn(String token, String userId) async {
    await _secureStorage.saveAuthToken(token);
    await _secureStorage.saveUserId(userId);

    state = state.copyWith(
      isAuthenticated: true,
      token: token,
      userId: userId,
    );
  }

  Future<void> signOut() async {
    await _secureStorage.clearAllAuthData();

    state = const AuthState(isAuthenticated: false);
  }

  Future<void> updateToken(String newToken) async {
    await _secureStorage.saveAuthToken(newToken);

    state = state.copyWith(token: newToken);
  }
}

// Provider for auth state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return AuthNotifier(secureStorage);
});

// Convenient provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});
