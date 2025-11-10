import 'package:cointiply_app/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:cointiply_app/features/common/widgets/custom_pointer_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/locale_switch_widget.dart';
import '../../../core/widgets/theme_switch_widget.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/presentation/providers/logout_provider.dart';
import '../../user_profile/presentation/providers/profile_providers.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      // On mobile, just show the app name
      return Row(
        children: [
          Icon(
            Icons.monetization_on,
            color: context.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            context.translate('app_name'),
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.onSurface,
            ),
          ),
        ],
      );
    } else {
      // On desktop, show full title with user info and controls
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App logo/title with user name
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: context.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.translate('app_name'),
                    style: context.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.onSurface,
                    ),
                  ),
                  // User name from profile (only show if authenticated)
                  Consumer(
                    builder: (context, ref, child) {
                      return FutureBuilder<bool>(
                        future:
                            ref.read(authProvider.notifier).isAuthenticated(),
                        builder: (context, snapshot) {
                          final isAuthenticated = snapshot.data ?? false;
                          final profile = ref.watch(currentUserProfileProvider);

                          if (isAuthenticated && profile != null) {
                            return Text(
                              'Welcome, ${profile.displayName ?? profile.username}!',
                              style: context.bodySmall?.copyWith(
                                color: context.onSurface.withValues(alpha: 0.7),
                              ),
                            );
                          } else {
                            return Text(
                              'Welcome to Gigafaucet!',
                              style: context.bodySmall?.copyWith(
                                color: context.onSurface.withValues(alpha: 0.7),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Theme and locale switches + Auth buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Authentication-dependent buttons
              Consumer(
                builder: (context, ref, child) {
                  // Use the observable authentication provider for real-time updates
                  final isAuthenticated =
                      ref.watch(isAuthenticatedObservableProvider);

                  if (isAuthenticated) {
                    // Show profile and logout buttons for authenticated users
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile button
                        IconButton(
                          onPressed: () => context.pushNamedProfile(),
                          icon: const Icon(Icons.person),
                          tooltip: 'Profile',
                        ),
                        // Chat overlay button
                        IconButton(
                          onPressed: () {
                            ref
                                .read(rightChatOverlayProvider.notifier)
                                .toggle();
                          },
                          icon: const Icon(Icons.chat),
                          tooltip: 'Chat',
                        ),
                        // Logout button
                        Consumer(
                          builder: (context, ref, child) {
                            final isLoading =
                                ref.watch(isLogoutLoadingProvider);
                            return IconButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _handleLogout(context, ref),
                              icon: isLoading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          context.primary,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.logout),
                              tooltip: isLoading ? 'Logging out...' : 'Logout',
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    // Show login button for unauthenticated users
                    return ElevatedButton.icon(
                      onPressed: () => context.go('/auth/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: context.onPrimary,
                        backgroundColor: context.primary,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
              const ThemeSwitchWidget(),
              const SizedBox(width: 8),
              const LocaleSwitchWidget(),
            ],
          ),
        ],
      );
    }
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => CustomPointerInterceptor(
        child: AlertDialog(
          title: Text(context.translate('logout')),
          content: Text(context.translate('logout_confirmation')),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(context.translate('cancel')),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              style: TextButton.styleFrom(
                foregroundColor: context.error,
              ),
              child: Text(context.translate('logout')),
            ),
          ],
        ),
      ),
    );

    if (shouldLogout == true) {
      try {
        // Perform logout - the UI should automatically update via the observable provider
        await ref.read(logoutNotifierProvider.notifier).logout();

        // Check the final state after logout
        final logoutState = ref.read(logoutNotifierProvider);

        if (logoutState is LogoutSuccess) {
          // Show success message but don't navigate - let UI update naturally
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logged out successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else if (logoutState is LogoutError) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(logoutState.message),
                backgroundColor: context.error,
              ),
            );
          }
        }
      } catch (e) {
        // Handle any unexpected errors
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: $e'),
              backgroundColor: context.error,
            ),
          );
        }
      }
    }
  }
}
