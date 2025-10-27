import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/login_provider.dart';
import '../../features/auth/presentation/providers/logout_provider.dart';

/// Global authentication state provider
///
/// This provider combines the authentication logic from login/logout providers
/// to provide a unified authentication state across the app
final globalAuthStateProvider = StreamProvider<bool>((ref) async* {
  // Initial authentication check
  try {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.isAuthenticated();

    final initialState = result.fold(
      (failure) => false,
      (isAuth) => isAuth,
    );

    yield initialState;
  } catch (e) {
    yield false;
  }

  // Listen to login state changes
  ref.listen(loginNotifierProvider, (previous, next) {
    if (next is LoginSuccess) {
      // User just logged in successfully
      ref.invalidateSelf();
    }
  });

  // Listen to logout state changes
  ref.listen(logoutNotifierProvider, (previous, next) {
    if (next is LogoutSuccess) {
      // User just logged out successfully
      ref.invalidateSelf();
    }
  });
});

/// Provider for checking if user is currently authenticated
///
/// This is a simpler synchronous version that can be used in build methods
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
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

/// Provider for getting current authenticated user
final currentAuthenticatedUserProvider = Provider((ref) {
  final loginState = ref.watch(loginNotifierProvider);

  if (loginState is LoginSuccess) {
    return loginState.user;
  }

  return null;
});

/// Provider for checking if any auth operation is in progress
final isAuthLoadingProvider = Provider<bool>((ref) {
  final isLoginLoading = ref.watch(isLoginLoadingProvider);
  final isLogoutLoading = ref.watch(isLogoutLoadingProvider);

  return isLoginLoading || isLogoutLoading;
});
