import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/auth/presentation/providers/logout_provider.dart';
import 'package:cointiply_app/features/common/widgets/custom_pointer_interceptor.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:flutter/material.dart';

import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileMenu extends StatelessWidget {
  final VoidCallback closeMenu;

  const ProfileMenu({
    super.key,
    required this.closeMenu,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest, // deep navy
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF003248), // TODO use from colorScheme
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.scrim.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MenuHeaderProgress(),

          const SizedBox(height: 14),

          _MenuItem(
            title: "Profile",
            onTap: () {
              closeMenu();
              _showProfileDialog(context);
            },
          ),

          _MenuItem(title: "Manage Your Account", onTap: () {}),
          _MenuItem(title: "Rewards", onTap: () {}),
          _MenuItem(title: "Transactions", onTap: () {}),
          _MenuItem(title: "Referrals", onTap: () {}),
          const SizedBox(height: 4),
          // dotted divider (thin + low opacity)
          Container(
            height: 1,
            // width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 6),
          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(isLogoutLoadingProvider);
              return CustomButtonWidget(
                onTap: isLoading
                    ? () {}
                    : () {
                        _handleLogout(context, ref);
                      },
                padding: EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                title: isLoading ? "Logging out..." : "Sign Out",
              );
            },
          )
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
      builder: (context) => const ProfileDialog(),
    );
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
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.translate('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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
          closeMenu.call();
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

class _MenuHeaderProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.titleMedium(
                "Your Progress",
                color: colorScheme.onSurfaceVariant,
              ),
              CommonText.titleMedium(
                "78%",
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 78,
                          child: Container(color: colorScheme.primary),
                        ),
                        Expanded(
                          flex: 22,
                          child: Container(
                            color: colorScheme.scrim.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CommonText.titleMedium("Lvl 20", color: colorScheme.onPrimary),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;

    return InkWell(
      onTap: onTap,
      hoverColor: Colors.white.withValues(alpha: 0.05),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
        child: CommonText.titleMedium(
          title,
          color: color,
        ),
      ),
    );
  }
}
