import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/disable_2fa_confirmation_dialog.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/two_factor_auth_dialog.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/setting_profile_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/manage_profile/upload_avatar_dialog.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user_profile_image_widget.dart';
import 'change_email_dialog.dart';
import 'change_name_dialog.dart';
import 'change_password_dialog.dart';
import 'change_your_country_dialog.dart';
import 'change_your_language_dialog.dart';

part 'tab/profile_tab_content_widget.dart';
part 'tab/security_tab_content_widget.dart';
part 'tab/setting_tab_content_widget.dart';

/// Provider to manage the selected tab index in the Manage Profile dialog
final tabBarIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

void showManageProfileDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) => const ManageProfileDialog(),
  );
}

class ManageProfileDialog extends ConsumerStatefulWidget {
  const ManageProfileDialog({super.key});

  @override
  ConsumerState<ManageProfileDialog> createState() =>
      _ManageProfileDialogState();
}

class _ManageProfileDialogState extends ConsumerState<ManageProfileDialog> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getProfileNotifierProvider.notifier).fetchProfile();
      ref.read(tabBarIndexProvider.notifier).state = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getProfileStatus = ref.watch(getProfileNotifierProvider).status;
     final screenHeight = MediaQuery.of(context).size.height;

    return DialogBgWidget(
      dialogHeight: screenHeight > 700 ? 526 : screenHeight * 0.85,
      body: _manageDialogBody(status:getProfileStatus),
      title: context.translate("manage_profile_title"),
    );
  }

  _manageDialogBody({required GetProfileStatus status}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _manageProfileTabBar(),
        
        if (status == GetProfileStatus.loading) ...[
          const SizedBox(height: 50),
          Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        if (status == GetProfileStatus.failure) ...[
          const SizedBox(height: 50),
          Center(
            child: CommonText.bodyMedium(
              context.translate("manage_profile_load_error"),
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        if (status == GetProfileStatus.success) 
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _manageProfileTabBody(),
          ),
        ),
      ],
    );
  }

  Widget _manageProfileTabBar() {
    final selectedIndex = ref.watch(tabBarIndexProvider);

    // if (context.screenWidth > 600) {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(vertical: 21.5),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       spacing: 6.0,
    //       children: [
    //         _tabBarMenuItem(
    //           context.translate("manage_profile_tab_profile"),
    //           index: 0,
    //           isSelected: selectedIndex == 0,
    //           width:  150,
    //         ),
    //         _tabBarMenuItem(
    //           context.translate("manage_profile_tab_security"),
    //           index: 1,
    //           isSelected: selectedIndex == 1,
    //           width: 150,
    //         ),
    //         _tabBarMenuItem(
    //           context.translate("manage_profile_tab_settings"),
    //           index: 2,
    //           isSelected: selectedIndex == 2,
    //           width: 150,
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 21.5),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 8.0;
          final double buttonWidth =
              (constraints.maxWidth - spacing) / (context.isDesktop ? 3.1 : 2);

          return Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: 12.0,
            children: [
              _tabBarMenuItem(
                context.translate("manage_profile_tab_profile"),
                index: 0,
                isSelected: selectedIndex == 0,
                width: buttonWidth,
              ),
              _tabBarMenuItem(
                context.translate("manage_profile_tab_security"),
                index: 1,
                isSelected: selectedIndex == 1,
                width: buttonWidth,
              ),
              _tabBarMenuItem(
                context.translate("manage_profile_tab_settings"),
                index: 2,
                isSelected: selectedIndex == 2,
                width: buttonWidth,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tabBarMenuItem(
    String s, {
    required int index,
    required bool isSelected,
    required double width,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => ref.read(tabBarIndexProvider.notifier).state = index,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  width: 1,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                ),
        ),
        child: Center(
          child: CommonText.titleMedium(
            s,
            fontWeight: FontWeight.w700,
            fontSize: isSelected ? 16 : 14,
            color:
                isSelected ? const Color(0xff333333) : const Color(0xff98989A),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _manageProfileTabBody() {
    final selectedIndex = ref.watch(tabBarIndexProvider);
    if (selectedIndex == 0) {
      return const ProfileTabContent();
    } else if (selectedIndex == 1) {
      return const SecurityTabContentWidget();
    } else if (selectedIndex == 2) {
      return const SettingTabContentWidget();
    }
    return const SizedBox();
  }
}
