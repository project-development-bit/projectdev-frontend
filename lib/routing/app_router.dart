// 📦 Package imports
import 'package:cointiply_app/features/auth/presentation/examples/two_factor_auth_example.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/internal_verification_overlay.dart';
import 'package:cointiply_app/features/home/widgets/dialog/tutorial_overlay.dart';
import 'package:cointiply_app/features/chat/presentation/pages/chat_page.dart';
import 'package:cointiply_app/features/chat/presentation/pages/right_chat_overlay.dart';
import 'package:cointiply_app/features/terms_privacy/presentation/screens/privacy_screen.dart';
import 'package:cointiply_app/features/terms_privacy/presentation/screens/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🌎 Project imports
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/verification_page.dart';
import '../features/auth/presentation/pages/reset_password_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/user_profile/presentation/pages/profile_page.dart';
import '../features/legal/presentation/pages/contact_us_page.dart';
import '../core/providers/auth_provider.dart';
import '../core/widgets/shell_route_wrapper.dart';
import 'verification_page_parameter.dart';

// Route names for type safety
class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verification = '/auth/verification';
  static const String twoFactorAuth = '/auth/2fa';
  static const String resetPassword = '/auth/reset-password';
  static const String auth = '/auth';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String offers = '/offers';
  static const String dashboard = '/dashboard';
  static const String privacyPolicy = '/legal/privacy-policy';
  static const String termsOfService = '/legal/terms-of-service';
  static const String contactUs = '/legal/contact-us';
  static const String chat = '/chat';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
}

// Router provider for dependency injection
final routerProvider = Provider<BurgerEatsAppRoutes>(
  (ref) => BurgerEatsAppRoutes(
    authProvider: ref.read(authProvider.notifier),
  ),
);

// GoRouter provider - persistent across theme changes
final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final routes = ref.read(routerProvider);
    return routes.routerConfig;
  },
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

              // Always redirect to home page regardless of auth state
              return AppRoutes.home;
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
              if (state.fullPath == AppRoutes.auth ||
                  state.fullPath == '/auth') {
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
                path: 'verification',
                name: 'verification',
                pageBuilder: (context, state) {
                  final parameter = state.extra as VerificationPageParameter?;
                  final email = parameter?.email ??
                      state.uri.queryParameters['email'] ??
                      '';
                  return NoTransitionPage(
                    child: VerificationPage(
                      email: email,
                      isSendCode: parameter?.isSendCode ?? false,
                      isFromForgotPassword:
                          parameter?.isFromForgotPassword ?? false,
                    ),
                  );
                },
              ),
              GoRoute(
                path: '2fa',
                name: '2fa',
                pageBuilder: (context, state) {
                  state.uri.queryParameters['sessionToken'];
                  return NoTransitionPage(
                    child: TwoFactorAuthExample(),
                    // child: TwoFactorAuthPage(
                    //   email: email,
                    //   sessionToken: sessionToken,
                    // ),
                  );
                },
              ),
              GoRoute(
                path: 'reset-password',
                name: 'reset-password',
                pageBuilder: (context, state) {
                  final email = state.uri.queryParameters['email'] ?? '';
                  return NoTransitionPage(
                    child: ResetPasswordPage(email: email),
                  );
                },
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

          // Legal Routes - Public access
          GoRoute(
            path: AppRoutes.contactUs,
            name: 'contact-us',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ContactUsPage(),
            ),
          ),

          // Main App Shell Route - Wraps non-auth routes with login popup
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state, child) {
              return NoTransitionPage(
                child: ShellRouteWrapper(
                  child: InternalVerificationOverlay(
                    child: RightChatOverlay(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final isVerified =
                              ref.watch(internalVerificationProvider);

                          return isVerified
                              ? TutorialOverlay(child: child)
                              : child;
                        },
                      ),
                    ),
                  ),
                ),
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

              // chat Route
              GoRoute(
                path: AppRoutes.chat,
                name: 'chat',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ChatPage(),
                ),
              ),

              // Terms and Privacy Routes - Public access
              GoRoute(
                path: AppRoutes.terms,
                name: AppRoutes.terms,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TermsScreen(),
                ),
              ),

              GoRoute(
                path: AppRoutes.privacy,
                name: AppRoutes.privacy,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: PrivacyScreen(),
                ),
              ),

              // Offers Routes - Requires Authentication
              GoRoute(
                path: AppRoutes.offers,
                redirect: (context, state) async {
                  final isAuthenticated = await authProvider.isAuthenticated();

                  if (!isAuthenticated) {
                    debugPrint(
                        '🔒 Offers access denied - redirecting to login');
                    return AppRoutes.login;
                  }

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

              // Profile Routes - Requires Authentication
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                redirect: (context, state) async {
                  final isAuthenticated = await authProvider.isAuthenticated();

                  if (!isAuthenticated) {
                    debugPrint(
                        '🔒 Profile access denied - redirecting to login');
                    return AppRoutes.login;
                  }

                  return null; // Allow access to profile
                },
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
              ),

              // Settings Routes - Requires Authentication
              GoRoute(
                path: AppRoutes.settings,
                redirect: (context, state) async {
                  final isAuthenticated = await authProvider.isAuthenticated();

                  if (!isAuthenticated) {
                    debugPrint(
                        '🔒 Settings access denied - redirecting to login');
                    return AppRoutes.login;
                  }

                  return null; // Allow access to settings
                },
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Scaffold(
                    body: Center(
                      child: Text('Settings Page - Coming Soon'),
                    ),
                  ),
                ),
              ),

              // Dashboard Routes (for admin/advanced features) - Requires Authentication
              GoRoute(
                path: AppRoutes.dashboard,
                redirect: (context, state) async {
                  final isAuthenticated = await authProvider.isAuthenticated();

                  if (!isAuthenticated) {
                    debugPrint(
                        '🔒 Dashboard access denied - redirecting to login');
                    return AppRoutes.login;
                  }

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
        // redirect: (context, state) async {
        //   final currentPath = state.fullPath ?? '';
        //   final matchedLocation = state.matchedLocation;

        //   debugPrint('🔄 Global redirect - current location: $currentPath');
        //   debugPrint('🔄 Global redirect - target location: $matchedLocation');

        //   // Allow access to auth routes without authentication
        //   if (currentPath.startsWith('/auth')) {
        //     debugPrint('🔄 Allowing access to auth route: $currentPath');
        //     return null;
        //   }

        //   // Allow access to home page regardless of authentication state
        //   if (currentPath == AppRoutes.home) {
        //     debugPrint('🔄 Allowing access to home page');
        //     return null;
        //   }

        //   try {
        //     final isAuthenticated = await authProvider.isAuthenticated();
        //     debugPrint('🔄 Authentication check result: $isAuthenticated');

        //     // If authenticated and trying to access root, redirect to home
        //     if (isAuthenticated && currentPath == '/') {
        //       debugPrint('🔄 Redirecting authenticated user to home');
        //       return AppRoutes.home;
        //     }

        //     // If not authenticated and trying to access protected routes (profile, settings, etc.)
        //     if (!isAuthenticated &&
        //         (currentPath.startsWith('/profile') ||
        //             currentPath.startsWith('/settings') ||
        //             currentPath.startsWith('/dashboard'))) {
        //       debugPrint('🔄 Redirecting to login - accessing protected route');
        //       return AppRoutes.login;
        //     }
        //   } catch (e) {
        //     debugPrint('🔄 Error checking authentication: $e');
        //     // On error, only redirect if accessing protected routes
        //     if (currentPath.startsWith('/profile') ||
        //         currentPath.startsWith('/settings') ||
        //         currentPath.startsWith('/dashboard')) {
        //       return AppRoutes.login;
        //     }
        //   }

        //   return null;
        // },
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

  // Helper methods for common navigation patterns
  void goToVerification({
    required String email,
    bool isSendCode = false,
    bool isFromForgotPassword = false,
  }) {
    go(
      AppRoutes.verification,
      extra: VerificationPageParameter(
        email: email,
        isSendCode: isSendCode,
        isFromForgotPassword: isFromForgotPassword,
      ),
    );
  }

  void pushToVerification({
    required String email,
    bool isSendCode = false,
    bool isFromForgotPassword = false,
  }) {
    push(
      AppRoutes.verification,
      extra: VerificationPageParameter(
        email: email,
        isSendCode: isSendCode,
        isFromForgotPassword: isFromForgotPassword,
      ),
    );
  }

  /// Navigate to reset password page
  void goToResetPassword({required String email}) {
    go('${AppRoutes.resetPassword}?email=${Uri.encodeComponent(email)}');
  }

  /// Push reset password page
  void pushToResetPassword({required String email}) {
    push('${AppRoutes.resetPassword}?email=${Uri.encodeComponent(email)}');
  }

  /// Navigate to 2FA page
  void goTo2FA({
    required String email,
    String? sessionToken,
  }) {
    final uri = Uri(
      path: AppRoutes.twoFactorAuth,
      queryParameters: {
        'email': email,
        if (sessionToken != null) 'sessionToken': sessionToken,
      },
    );
    go(uri.toString());
  }

  /// Push 2FA page
  void pushTo2FA({
    required String email,
    String? sessionToken,
  }) {
    final uri = Uri(
      path: AppRoutes.twoFactorAuth,
      queryParameters: {
        'email': email,
        if (sessionToken != null) 'sessionToken': sessionToken,
      },
    );
    push(uri.toString());
  }
}
