import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/doted_line_divider.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/affiliate_program/presentation/widgets/affiliate_program_dialog.dart';
import 'package:cointiply_app/features/auth/presentation/providers/logout_provider.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/logout_dialog_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_scaffold_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/reward_dialog.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/dialogs/wallet_dialog.dart';
import 'package:flutter/material.dart';

import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/user_profile/presentation/widgets/dialogs/manage_profile/manage_profile_dialog.dart';

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
      padding: EdgeInsets.only(top: 22, left: 32, right: 32, bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0B38), // deep navy#0C0B38
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF333333), // TODO use from colorScheme
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
          DotedLineDivider(
              padding: const EdgeInsets.symmetric(
            vertical: 10,
          )),
          _MenuItem(
            title: context.translate("profile"),
            onTap: () {
              closeMenu();
              _showProfileDialog(context);
            },
          ),
          _MenuItem(
            title: context.translate("manage_your_account"),
            onTap: () {
              closeMenu();
              showManageProfileDialog(context);
            },
          ),

          _MenuItem(
            title: context.translate("rewards"),
            onTap: () {
              closeMenu();
              _showRewardDialog(context);
            },
          ),

          _MenuItem(
            title: context.translate("wallet"),
            onTap: () {
              closeMenu();
              _showWalletDialog(context);
            },
          ),

          _MenuItem(
            title: context.translate("referrals"),
            onTap: () {
              closeMenu();
              showAffiliateProgramDialog(context);
            },
          ),
          // dotted divider (thin + low opacity)
          DotedLineDivider(
              padding: const EdgeInsets.only(
            top: 4,
            bottom: 7,
          )),
          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(isLogoutLoadingProvider);
              return CustomUnderLineButtonWidget(
                isDark: true,
                onTap: isLoading
                    ? () {}
                    : () {
                        closeMenu();
                        _handleLogout(context, ref);
                      },
                fontSize: 14,
                fontWeight: FontWeight.w700,
                title: isLoading
                    ? context.translate("logging_out")
                    : context.translate("sign_out"),
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
      builder: (context) => DialogScaffoldWidget(child: const ProfileDialog()),
    );
  }

  void _showRewardDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
      builder: (context) => DialogScaffoldWidget(child: const RewardDialog()),
    );
  }

  void _showWalletDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
      builder: (context) => DialogScaffoldWidget(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: const WalletDialog()),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    showLogoutDialog(context);
    // final shouldLogout = await showDialog<bool>(
    //   context: context,
    //   builder: (context) => CustomPointerInterceptor(
    //     child: AlertDialog(
    //       title: Text(context.translate('logout')),
    //       content: Text(context.translate('logout_confirmation')),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(false),
    //           child: Text(context.translate('cancel')),
    //         ),
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(true),
    //           style: TextButton.styleFrom(
    //             foregroundColor: context.error,
    //           ),
    //           child: Text(context.translate('logout')),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    // if (shouldLogout == true) {
    //   try {
    //     // Perform logout - the UI should automatically update via the observable provider
    //     await ref.read(logoutNotifierProvider.notifier).logout();

    //     // Check the final state after logout
    //     final logoutState = ref.read(logoutNotifierProvider);

    //     if (logoutState is LogoutSuccess) {
    //       closeMenu.call();
    //       if (context.mounted) {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text(context.translate('logout_successful')),
    //             backgroundColor: Colors.green,
    //           ),
    //         );
    //       }
    //     } else if (logoutState is LogoutError) {
    //       // Show error message
    //       if (context.mounted) {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text(logoutState.message),
    //             backgroundColor: context.error,
    //           ),
    //         );
    //       }
    //     }
    //   } catch (e) {
    //     // Handle any unexpected errors
    //     if (context.mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(context.translate('logout_failed', args: ['$e'])),
    //           backgroundColor: context.error,
    //         ),
    //       );
    //     }
    //   }
    // }
  }
}

class _MenuHeaderProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText.titleMedium(
              "Your Progress",
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
            ),
            CommonText.titleMedium(
              "78%",
              fontWeight: FontWeight.w700,
              color: Color(0xFF00A0DC),
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
            CommonText.titleMedium("Lvl 20",
                fontWeight: FontWeight.w500, color: colorScheme.onPrimary),
          ],
        ),
      ],
    );
  }
}

class _MenuItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    required this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        hoverColor: Colors.transparent, // disable default blue hover
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 9,
          ),
          margin: EdgeInsets.only(
            bottom: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: CommonText.bodyLarge(
            widget.title,
            fontWeight: FontWeight.w700,
            color: isHovered ? colorScheme.primary : colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
