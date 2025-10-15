// 📦 Package imports
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🌎 Project imports
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/user_profile/presentation/pages/profile_page.dart';
import '../core/providers/auth_provider.dart';
import '../core/widgets/shell_route_wrapper.dart';

// Route names for type safety
class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String auth = '/auth';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String offers = '/offers';
  static const String dashboard = '/dashboard';
}

// Router provider for dependency injection
final routerProvider = Provider<BurgerEatsAppRoutes>(
  (ref) => BurgerEatsAppRoutes(
    authProvider: ref.read(authProvider.notifier),
  ),
);

class BurgerEatsAppRoutes {
  final AuthProvider authProvider;

  BurgerEatsAppRoutes({
    required this.authProvider,
  });

  //--------------Navigator Keys--------------//
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  //--------------Navigator Keys--------------//

  static const _initialPath = '/';

  GoRouter get routerConfig => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: _initialPath,
        debugLogDiagnostics: true,
        routes: [
          // Landing Route Handler
          GoRoute(
            name: AppRoutes.initial,
            path: AppRoutes.initial,
            redirect: (context, state) async {
              final isAuthenticated = await authProvider.isAuthenticated();

              debugPrint(
                  '🔄 Landing redirect - authenticated: $isAuthenticated');
              debugPrint(
                  '🔄 Landing redirect - current path: ${state.fullPath}');

              if (isAuthenticated) {
                return AppRoutes.home;
              } else {
                return AppRoutes.login;
              }
            },
          ),

          // Authentication Routes
          GoRoute(
            path: AppRoutes.auth,
            redirect: (context, state) async {
              final isAuthenticated = await authProvider.isAuthenticated();
          
              if (isAuthenticated) {
                return AppRoutes.home;
              }

              // Only redirect to login if the exact path is /auth
              if (state.fullPath == AppRoutes.auth || state.fullPath == '/auth') {
                return AppRoutes.login;
              }
              
              // Allow sub-routes like forgot-password to proceed
              return null;
            },
            routes: [
              GoRoute(
                path: 'login',
                name: 'login',
                pageBuilder: (context, state) {
                  debugPrint(
                      '🔄 Building LoginPage for path: ${state.fullPath}');
                  return const NoTransitionPage(
                    child: LoginPage(),
                  );
                },
              ),
              GoRoute(
                path: 'signup',
                name: 'signup',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SignUpPage(),
                ),
              ),
              GoRoute(
                path: 'forgot-password',
                name: 'forgot-password',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ForgotPasswordPage(),
                ),
              ),
            ],
          ),

          // Main App Shell Route
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state, child) {
              return NoTransitionPage(
                child: ShellRouteWrapper(child: child),
              );
            },
            routes: [
              // Home/Dashboard Routes
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
              ),

              // Offers Routes
              GoRoute(
                path: AppRoutes.offers,
                redirect: (context, state) async {
                  if (state.fullPath == AppRoutes.offers) {
                    return '${AppRoutes.offers}/browse';
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    path: 'browse',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: Scaffold(
                        body: Center(
                          child: Text('Browse Offers - Coming Soon'),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'completed',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: Scaffold(
                        body: Center(
                          child: Text('Completed Offers - Coming Soon'),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'pending',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: Scaffold(
                        body: Center(
                          child: Text('Pending Offers - Coming Soon'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Profile Routes
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
              ),

              // Settings Routes
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Scaffold(
                    body: Center(
                      child: Text('Settings Page - Coming Soon'),
                    ),
                  ),
                ),
              ),

              // Dashboard Routes (for admin/advanced features)
              GoRoute(
                path: AppRoutes.dashboard,
                redirect: (context, state) async {
                  if (state.fullPath == AppRoutes.dashboard) {
                    return '${AppRoutes.dashboard}/overview';
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    path: 'overview',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: Scaffold(
                        body: Center(
                          child: Text('Dashboard Overview - Coming Soon'),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'earnings',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: Scaffold(
                        body: Center(
                          child: Text('Earnings Dashboard - Coming Soon'),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'analytics',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: Scaffold(
                        body: Center(
                          child: Text('Analytics Dashboard - Coming Soon'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],

        // Error handling
        errorPageBuilder: (context, state) => const NoTransitionPage(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Page Not Found',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The page you are looking for does not exist.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Global redirect logic for authentication
        redirect: (context, state) async {
          final currentPath = state.fullPath ?? '';
          final matchedLocation = state.matchedLocation;

          debugPrint('🔄 Global redirect - current location: $currentPath');
          debugPrint('🔄 Global redirect - target location: $matchedLocation');

          // Allow access to auth routes without authentication
          if (currentPath.startsWith('/auth')) {
            debugPrint('🔄 Allowing access to auth route: $currentPath');
            return null;
          }

          // Skip redirect if already on home page to prevent loops
          if (currentPath == AppRoutes.home) {
            debugPrint('🔄 Already on home page, skipping redirect');
            return null;
          }

          try {
            final isAuthenticated = await authProvider.isAuthenticated();
            debugPrint('🔄 Authentication check result: $isAuthenticated');

            // If authenticated and trying to access root or auth, redirect to home
            if (isAuthenticated &&
                (currentPath == '/' || currentPath.startsWith('/auth'))) {
              debugPrint('🔄 Redirecting authenticated user to home');
              return AppRoutes.home;
            }

            // If not authenticated and not on auth route, redirect to login
            if (!isAuthenticated && !currentPath.startsWith('/auth')) {
              debugPrint('🔄 Redirecting to login - user not authenticated');
              return AppRoutes.login;
            }
          } catch (e) {
            debugPrint('🔄 Error checking authentication: $e');
            // On error, redirect to login for safety
            if (!currentPath.startsWith('/auth')) {
              return AppRoutes.login;
            }
          }
      
          return null;
        },
      );
}

// Navigation helper extensions - using context_extensions.dart
// Removed duplicate methods to avoid ambiguous extension member access
extension GoRouterExtension on BuildContext {
  void go(String location, {Object? extra}) =>
      GoRouter.of(this).go(location, extra: extra);
  void push(String location, {Object? extra}) =>
      GoRouter.of(this).push(location, extra: extra);
  void pop<T extends Object?>([T? result]) => GoRouter.of(this).pop(result);
  void replace(String location, {Object? extra}) =>
      GoRouter.of(this).pushReplacement(location, extra: extra);
}

