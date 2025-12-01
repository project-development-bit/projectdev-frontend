import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../features/auth/presentation/providers/login_provider.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import 'auth_provider.dart';

/// Debug provider to help diagnose routing issues
class AuthDebugProvider extends StateNotifier<AuthDebugState> {
  AuthDebugProvider(this._ref) : super(AuthDebugState());

  final Ref _ref;

  /// Log current authentication state for debugging
  Future<void> logAuthState(String context) async {
    final loginState = _ref.read(loginNotifierProvider);
    final authState = _ref.read(authProvider);

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      final isAuthResult = await authRepository.isAuthenticated();

      final debugState = AuthDebugState(
        context: context,
        loginStateType: loginState.runtimeType.toString(),
        authStateType: authState.runtimeType.toString(),
        isAuthenticated: isAuthResult.fold((l) => false, (r) => r),
        timestamp: DateTime.now(),
      );

      state = debugState;

      debugPrint('🔍 Auth Debug [$context]:');
      debugPrint('  Login State: ${debugState.loginStateType}');
      debugPrint('  Auth State: ${debugState.authStateType}');
      debugPrint('  Is Authenticated: ${debugState.isAuthenticated}');
      debugPrint('  Timestamp: ${debugState.timestamp}');
    } catch (e) {
      debugPrint('🔍 Auth Debug Error [$context]: $e');
    }
  }
}

/// Debug state class
class AuthDebugState {
  final String context;
  final String loginStateType;
  final String authStateType;
  final bool isAuthenticated;
  final DateTime timestamp;

  AuthDebugState({
    this.context = '',
    this.loginStateType = '',
    this.authStateType = '',
    this.isAuthenticated = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'AuthDebugState(context: $context, loginState: $loginStateType, authState: $authStateType, isAuth: $isAuthenticated, time: $timestamp)';
  }
}

/// Provider for auth debugging
final authDebugProvider =
    StateNotifierProvider<AuthDebugProvider, AuthDebugState>((ref) {
  return AuthDebugProvider(ref);
});
