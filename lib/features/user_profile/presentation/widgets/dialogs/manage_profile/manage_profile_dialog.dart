import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/disable_2fa_confirmation_dialog.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/two_factor_auth_dialog.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/language.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/setting_profile_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/manage_profile/security_pin_dialog.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/manage_profile/upload_avatar_dialog.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user_profile_image_widget.dart';
import 'change_email_dialog.dart';
import 'change_name_dialog.dart';
import 'change_password_dialog.dart';
import 'change_your_country_dialog.dart';
import '../../../../../localization/presentation/widgets/dialogs/change_your_language_dialog.dart';
import 'delete_account_dialog.dart';
import 'show_offer_token_dialog.dart';

part 'tab/profile_tab_content_widget.dart';
part 'tab/security_tab_content_widget.dart';
part 'tab/setting_tab_content_widget.dart';

/// Provider to manage the selected tab index in the Manage Profile dialog
final profileTabBarIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

void showManageProfileDialog(BuildContext context) {
  // final screenHeight = MediaQuery.of(context).size.height;
  context.showManagePopup(
    // height: screenHeight > 700 ? 526 : screenHeight * 0.85,
    barrierDismissible: true,
    child: const ManageProfileDialog(),
    // title: context.translate("manage_profile_title"),
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
      ref.read(profileTabBarIndexProvider.notifier).state = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getProfileStatus = ref.watch(getProfileNotifierProvider).status;

    return DialogBgWidget(
      isInitLoading: getProfileStatus == GetProfileStatus.loading,
      isOverlayLoading: false,
      dialogHeight: _getDialogHeight(context),
      body: _manageDialogBody(status: getProfileStatus),
      title: context.translate("manage_profile_title"),
    );
  }

  double _getDialogHeight(BuildContext context) {
    final tabIndex = ref.watch(profileTabBarIndexProvider);
    if (tabIndex == 0) {
      return context.screenWidth <= 430 ? context.screenHeight * 0.9 : 600;
    } else if (tabIndex == 1) {
      return context.screenWidth <= 430 ? context.screenHeight * 0.9 : 550;
    } else {
      return context.screenWidth <= 430 ? context.screenHeight * 0.9 : 720;
    }
  }

  _manageDialogBody({required GetProfileStatus status}) {
    return SingleChildScrollView(
      padding: context.isMobile || context.isTablet
          ? EdgeInsets.symmetric(horizontal: 16)
          : const EdgeInsets.symmetric(horizontal: 31).copyWith(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _manageProfileTabBar(),
            SizedBox(height: 16),
           
            if (status == GetProfileStatus.failure) ...[
              const SizedBox(height: 50),
              Center(
                child: CommonText.bodyMedium(
                  context.translate("manage_profile_load_error"),
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            SizedBox(height: 16),
            if (status == GetProfileStatus.success) _manageProfileTabBody(),
          ],
        ),
      ),
    );
  }

  Widget _manageProfileTabBar() {
    final selectedIndex = ref.watch(profileTabBarIndexProvider);
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 8.0;
          final double buttonWidth = (constraints.maxWidth - spacing) /
              (context.isDesktop || context.isTablet ? 3.1 : 2);

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
    return CustomButtonWidget(
      isOutlined: true,
      title: s,
      width: width,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      isActive: isSelected,
      onTap: () {
        ref.read(profileTabBarIndexProvider.notifier).state = index;
      },
    );
  }

  Widget _manageProfileTabBody() {
    final selectedIndex = ref.watch(profileTabBarIndexProvider);
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
