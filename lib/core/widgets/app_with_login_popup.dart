// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import '../../features/auth/presentation/widgets/login_popup_overlay.dart';

// /// Main app wrapper that handles the login popup overlay
// /// Only shows popup for non-authentication routes when user is not authenticated
// class AppWithLoginPopup extends ConsumerWidget {
//   const AppWithLoginPopup({
//     super.key,
//     required this.child,
//   });

//   final Widget child;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Watch authentication state to show/hide popup
//     final isAuthenticated = ref.watch(isAuthenticatedObservableProvider);

//     // Get current route to determine if we should show popup
//     final currentLocation = GoRouterState.of(context).uri.path;
//     final isAuthRoute = currentLocation.startsWith('/auth');

//     // Only show popup if:
//     // 1. User is not authenticated
//     // 2. Current route is NOT an authentication route
//     final shouldShowPopup = !isAuthenticated && !isAuthRoute;

//     debugPrint(
//         '🔍 AppWithLoginPopup - Location: $currentLocation, IsAuth: $isAuthenticated, IsAuthRoute: $isAuthRoute, ShowPopup: $shouldShowPopup');

//     return LoginPopupOverlay(
//       showPopup: shouldShowPopup,
//       onLoginSuccess: () {
//         // The popup will automatically disappear when auth state changes
//         debugPrint('✅ Login successful - popup should close automatically');
//       },
//       child: child,
//     );
//   }
// }
