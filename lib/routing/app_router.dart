import 'package:cointiply_app/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';

// Route names for type safety
class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home, // Start with login page
  debugLogDiagnostics: true,
  routes: [
    // Auth Routes
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: AppRoutes.signUp,
      name: 'signUp',
      builder: (context, state) => const SignUpPage(),
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    // Main App Routes
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        // Nested routes under main tab page
        GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Profile Page - Coming Soon'),
            ),
          ),
        ),

        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Settings Page - Coming Soon'),
            ),
          ),
        ),
      ],
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Page Not Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'The page you are looking for does not exist.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),

  // Redirect logic (optional)
  redirect: (context, state) {
    // Add authentication logic here
    // For now, allow all routes
    return null;
  },
);

// Navigation helper extensions
extension GoRouterExtension on BuildContext {
  void goToLogin() => go(AppRoutes.login);
  void goToHome() => go(AppRoutes.home);
  void goToSignUp() => go(AppRoutes.signUp);
  void goToForgotPassword() => go(AppRoutes.forgotPassword);
  void goToProfile() => go('${AppRoutes.home}/profile');
  void goToSettings() => go('${AppRoutes.home}/settings');

  void pushLogin() => push(AppRoutes.login);
  void pushSignUp() => push(AppRoutes.signUp);
  void pushForgotPassword() => push(AppRoutes.forgotPassword);
  void pushProfile() => push('${AppRoutes.home}/profile');
  void pushSettings() => push('${AppRoutes.home}/settings');
}
