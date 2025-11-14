import 'package:cointiply_app/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:cointiply_app/features/common/menu/profile_menu.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/locale_switch_widget.dart';
import '../../../core/widgets/theme_switch_widget.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../user_profile/presentation/providers/profile_providers.dart';

class CommonAppBar extends ConsumerWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        IconButton(
                          icon: const Icon(Icons.contact_mail),
                          onPressed: () {
                            context.go(
                                '/legal/contact-us'); // Navigate to Contact Us screen
                          },
                        ),
                        // Profile button
                        PopupMenuButton(
                          position: PopupMenuPosition.under,
                          offset: const Offset(0, 8),
                          elevation: 0,
                          color: Colors.transparent,
                          clipBehavior: Clip.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 0,
                            maxWidth: 260,
                          ),
                          itemBuilder: (ext) => [
                            PopupMenuItem(
                              enabled: false,
                              padding: EdgeInsets.zero,
                              child: ProfileMenu(
                                closeMenu: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                          child: UserProfileImageWidget(size: 20),
                        ),
                      ],
                    );
                  } else {
                    // Show login button for unauthenticated users
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.contact_mail),
                          onPressed: () {
                            context.go('/legal/contact-us');
                          },
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/auth/login'),
                          icon: const Icon(Icons.login),
                          label: const Text('Login'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: context.onPrimary,
                            backgroundColor: context.primary,
                          ),
                        ),
                      ],
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
}
