import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/providers/auth_provider.dart';
import 'package:gigafaucet/features/auth/presentation/providers/logout_provider.dart';

void main() {
  group('Authentication Observable Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should return false when initially unauthenticated', () {
      // Initially should be unauthenticated
      final isAuth = container.read(isAuthenticatedObservableProvider);
      expect(isAuth, false);
    });

    test('should return false when logout is successful', () {
      // Simulate successful logout
      container.read(logoutNotifierProvider.notifier).state =
          const LogoutSuccess();

      // Should be unauthenticated
      final isAuth = container.read(isAuthenticatedObservableProvider);
      expect(isAuth, false);
    });

    test('auth state should change when logout occurs', () {
      // Initially unauthenticated
      final initialAuthState = container.read(authProvider);
      expect(initialAuthState.isUnauthenticated, true);

      // Simulate logout
      container.read(logoutNotifierProvider.notifier).state =
          const LogoutSuccess();

      // Auth state should still be unauthenticated
      final newAuthState = container.read(authProvider);
      expect(newAuthState.isUnauthenticated, true);
    });

    test('observable provider should watch logout state changes', () {
      // Initially false
      expect(container.read(isAuthenticatedObservableProvider), false);

      // Simulate logout success
      container.read(logoutNotifierProvider.notifier).state =
          const LogoutSuccess();

      // Should still be false (logged out)
      expect(container.read(isAuthenticatedObservableProvider), false);
    });

    test('auth state should properly handle logout', () {
      final authNotifier = container.read(authProvider.notifier);

      // Initially unauthenticated
      expect(container.read(authProvider).isUnauthenticated, true);

      // Set to authenticated manually
      authNotifier.state = const AuthStateAuthenticated();
      expect(container.read(authProvider).isAuthenticated, true);

      // Trigger logout
      container.read(logoutNotifierProvider.notifier).state =
          const LogoutSuccess();

      // Should become unauthenticated due to listener
      expect(container.read(authProvider).isUnauthenticated, true);
    });
  });
}
