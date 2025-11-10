import 'package:cointiply_app/features/common/widgets/custom_pointer_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/common/common_container.dart';
import '../../../core/common/common_text.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/locale_switch_widget.dart';
import '../../../core/widgets/theme_switch_widget.dart';
import '../../auth/presentation/providers/logout_provider.dart';
import '../../user_profile/presentation/providers/current_user_provider.dart';

/// Mobile drawer widget containing navigation options, settings, and user controls
class MobileDrawer extends ConsumerWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedObservableProvider);
    final currentUserState = ref.watch(currentUserProvider);

    // Initialize user data when authenticated and no user data exists
    // Only call this when we actually need the user data
    if (isAuthenticated &&
        currentUserState.user == null &&
        !currentUserState.isLoading &&
        currentUserState.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentUserProvider.notifier).initializeUser();
      });
    }

    return CustomPointerInterceptor(
      child: Drawer(
        child: Column(
          children: [
            // Drawer Header
            _buildDrawerHeader(context, ref, isAuthenticated, currentUserState),

            // Main content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Settings Section
                  _buildSectionHeader(context, context.translate('settings')),

                  // Theme Switch
                  _buildThemeItem(context, ref),

                  // Locale Switch
                  _buildLocaleItem(context, ref),

                  const Divider(),

                  // User Section (only if authenticated)
                  if (isAuthenticated) ...[
                    _buildSectionHeader(context, context.translate('account')),

                    // Profile
                    _buildProfileItem(context, currentUserState),
                    _buildSectionHeader(context, context.translate('support')),
                    _buildChatItem(context),

                    const Divider(),

                    // Logout
                    _buildLogoutItem(context, ref),
                  ] else ...[
                    // Login option for unauthenticated users
                    _buildSectionHeader(context, context.translate('account')),
                    _buildLoginItem(context),
                  ],
                ],
              ),
            ),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Build the drawer header with app branding and user info
  Widget _buildDrawerHeader(BuildContext context, WidgetRef ref,
      bool isAuthenticated, CurrentUserState currentUserState) {
    return CommonContainer(
      height: 160, // Fixed height to prevent overflow
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          context.primary,
          context.primary.withValues(alpha: 0.8),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // App logo and name
          Flexible(
            child: Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: context.onPrimary,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CommonText.titleLarge(
                    context.translate('app_name'),
                    color: context.onPrimary,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // User info
          Flexible(
            child: _buildUserInfo(context, isAuthenticated, currentUserState),
          ),
        ],
      ),
    );
  }

  /// Build user info section with proper state handling
  Widget _buildUserInfo(BuildContext context, bool isAuthenticated,
      CurrentUserState currentUserState) {
    if (!isAuthenticated) {
      return Row(
        children: [
          Icon(
            Icons.account_circle,
            color: context.onPrimary.withValues(alpha: 0.7),
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonText.titleSmall(
              context.translate('welcome_to_gigafaucet'),
              color: context.onPrimary,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      );
    }

    // Loading state
    if (currentUserState.isLoading) {
      return Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                context.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonText.titleSmall(
              context.translate('loading_user_info'),
              color: context.onPrimary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }

    // Error state
    if (currentUserState.error != null) {
      return Row(
        children: [
          Icon(
            Icons.error_outline,
            color: context.onPrimary.withValues(alpha: 0.7),
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleSmall(
                  context.translate('error_loading_user'),
                  color: context.onPrimary,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                CommonText.bodySmall(
                  context.translate('tap_to_retry'),
                  color: context.onPrimary.withValues(alpha: 0.8),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // User data available
    final user = currentUserState.user;
    if (user != null) {
      return Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.onPrimary.withValues(alpha: 0.2),
            child: CommonText.titleSmall(
              user.name.isNotEmpty
                  ? user.name.substring(0, 1).toUpperCase()
                  : 'U',
              color: context.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleSmall(
                  user.name.isNotEmpty ? user.name : 'User',
                  color: context.onPrimary,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                CommonText.bodySmall(
                  user.email,
                  color: context.onPrimary.withValues(alpha: 0.8),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Fallback state
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          color: context.onPrimary.withValues(alpha: 0.7),
          size: 36,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CommonText.titleSmall(
            context.translate('user_not_found'),
            color: context.onPrimary.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: CommonText.titleSmall(
        title,
        color: context.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Build theme switch item
  Widget _buildThemeItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.palette_outlined,
        color: context.onSurfaceVariant,
      ),
      title: CommonText.bodyLarge(context.translate('theme')),
      subtitle: CommonText.bodySmall(
        context.translate('change_app_appearance'),
        color: context.onSurfaceVariant,
      ),
      trailing: const ThemeSwitchWidget(),
      onTap: () {
        // The theme switch widget handles the tap
      },
    );
  }

  /// Build locale switch item
  Widget _buildLocaleItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.language_outlined,
        color: context.onSurfaceVariant,
      ),
      title: CommonText.bodyLarge(context.translate('language')),
      subtitle: CommonText.bodySmall(
        context.translate('change_app_language'),
        color: context.onSurfaceVariant,
      ),
      trailing: const LocaleSwitchWidget(),
      onTap: () {
        // The locale switch widget handles the tap
      },
    );
  }

  /// Build profile item
  Widget _buildProfileItem(
      BuildContext context, CurrentUserState currentUserState) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: context.primary.withValues(alpha: 0.1),
        child: Icon(
          Icons.person,
          color: context.primary,
          size: 20,
        ),
      ),
      title: CommonText.bodyLarge(context.translate('profile')),
      subtitle: CommonText.bodySmall(
        context.translate('view_edit_profile'),
        color: context.onSurfaceVariant,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: context.onSurfaceVariant,
      ),
      onTap: () {
        Navigator.of(context).pop(); // Close drawer
        context.pushNamedProfile();
      },
    );
  }

  Widget _buildChatItem(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: context.primary.withValues(alpha: 0.1),
        child: Icon(
          Icons.chat,
          color: context.primary,
          size: 20,
        ),
      ),
      title: CommonText.bodyLarge(context.translate('chat')),
      subtitle: CommonText.bodySmall(
        context.translate('open_chat'),
        color: context.onSurfaceVariant,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: context.onSurfaceVariant,
      ),
      onTap: () {
        Navigator.of(context).pop(); // Close drawer
        context.pushNamedChat();
      },
    );
  }

  /// Build login item
  Widget _buildLoginItem(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.login,
        color: context.primary,
      ),
      title: CommonText.bodyLarge(
        context.translate('sign_in'),
        color: context.primary,
        fontWeight: FontWeight.w500,
      ),
      subtitle: CommonText.bodySmall(
        context.translate('sign_in_to_account'),
        color: context.onSurfaceVariant,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: context.primary,
      ),
      onTap: () {
        Navigator.of(context).pop(); // Close drawer
        context.go('/auth/login');
      },
    );
  }

  /// Build logout item
  Widget _buildLogoutItem(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final isLoading = ref.watch(isLogoutLoadingProvider);

        return ListTile(
          leading: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.error,
                    ),
                  ),
                )
              : Icon(
                  Icons.logout,
                  color: context.error,
                ),
          title: CommonText.bodyLarge(
            context.translate('logout'),
            color: context.error,
            fontWeight: FontWeight.w500,
          ),
          subtitle: CommonText.bodySmall(
            isLoading
                ? context.translate('signing_out')
                : context.translate('sign_out_account'),
            color: context.onSurfaceVariant,
          ),
          onTap: isLoading
              ? null
              : () {
                  debugPrint('🔴 Logout ListTile onTap triggered - debugPrint');
                  _handleLogout(context, ref);
                },
        );
      },
    );
  }

  /// Build footer with app version
  Widget _buildFooter(BuildContext context) {
    return CommonContainer(
      padding: const EdgeInsets.all(16),
      showBorder: true,
      borderColor: context.outlineVariant,
      borderWidth: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText.bodySmall(
            context.translate('app_name'),
            color: context.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 4),
          CommonText.bodySmall(
            '${context.translate('version')} 1.0.0',
            color: context.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  /// Handle logout functionality
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    debugPrint('🔴 Logout button pressed - starting logout process');

    // Store references early before any navigation that might dispose the widget
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final logoutNotifier = ref.read(logoutNotifierProvider.notifier);
    // Close drawer first
    Navigator.of(context).pop();

    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => CustomPointerInterceptor(
        child: AlertDialog(
          title: Text(dialogContext.translate('logout')),
          content: Text(dialogContext.translate('logout_confirmation')),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint('🔴 User pressed Cancel in logout dialog');
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(dialogContext.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                debugPrint('🔴 User pressed Logout in logout dialog');
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              child: Text(dialogContext.translate('logout')),
            ),
          ],
        ),
      ),
    );

    debugPrint('🔴 User logout choice: $shouldLogout');

    if (shouldLogout == true) {
      try {
        debugPrint('🔴 Calling logout notifier...');

        // Perform logout using the stored reference
        await logoutNotifier.logout();

        debugPrint('🔴 Logout call completed successfully');

        // Navigate to home using GoRouter directly without context dependency
        if (context.mounted) {
          debugPrint('🔴 Navigating to home...');
          context.go('/');
        } else {
          debugPrint('🔴 Context no longer mounted, skipping navigation');
        }
      } catch (e) {
        debugPrint('🔴 Exception during logout: $e');

        // Show error message using stored reference if context is mounted
        if (context.mounted) {
          try {
            final errorMessage = context
                .translate('logout_failed')
                .replaceAll('{0}', e.toString());
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } catch (snackBarError) {
            debugPrint('🔴 Could not show error snackbar: $snackBarError');
          }
        }
      }
    }
  }
}
