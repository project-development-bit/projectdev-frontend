import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/manage_profile/upload_avatar_dialog.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user_profile_image_widget.dart';

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
  Widget build(BuildContext context) {
    return DialogBgWidget(
      body: _manageDialogBody(),
      title: context.translate("manage_profile_title"),
    );
  }

  _manageDialogBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _manageProfileTabBar(),
          _manageProfileTabBody(),
        ],
      ),
    );
  }

  Widget _manageProfileTabBar() {
    final selectedIndex = ref.watch(tabBarIndexProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 21.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 6.0,
        children: [
          _tabBarMenuItem("My Profile",
              index: 0, isSelected: selectedIndex == 0),
          _tabBarMenuItem("Security", index: 1, isSelected: selectedIndex == 1),
          _tabBarMenuItem("Settings", index: 2, isSelected: selectedIndex == 2),
        ],
      ),
    );
  }

  Widget _tabBarMenuItem(String s,
      {required int index, required bool isSelected}) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => ref.read(tabBarIndexProvider.notifier).state = index,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
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
        child: Container(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Center(
            child: CommonText.titleMedium(
              s,
              fontWeight: FontWeight.w700,
              fontSize: isSelected ? 16 : 14,
              color: isSelected ? Color(0xff333333) : Color(0xff98989A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _manageProfileTabBody() {
    final selectedIndex = ref.watch(tabBarIndexProvider);
    if (selectedIndex == 0) {
      return _ProfileTabContent();
    } else if (selectedIndex == 1) {
      return SizedBox(); // TODO: Implement Security tab content
    } else if (selectedIndex == 2) {
      return SizedBox(); // TODO: Implement Settings tab content
    }
    return SizedBox();
  }
}

class _ProfileTabContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(profileCurrentUserProvider)?.email ?? '';
    // final country = ref.watch(profileCurrentUserProvider)?.country ?? '';
    return Column(
      children: [
        _profileTabContentItem(
          title: "Avatar",
          child: UserProfileImageWidget(size: 25),
          btnTitle: context.translate("change_your_avatar"),
          onPressed: () {
            context.pop();

            showUploadAvatarDialog(context);
          },
        ),
        _profileTabContentItem(
          title: "Email",
          child: email.isNotEmpty
              ? CommonText.bodyMedium(
                  email,
                  fontWeight: FontWeight.w500,
                )
              : CommonText.bodyMedium(
                  "No email set",
                  fontWeight: FontWeight.w500,
                ),
          btnTitle: context.translate("change_your_email"),
          onPressed: () {},
        ),
        _profileTabContentItem(
          title: "Country",
          child: CommonText.bodyMedium(
             "No country set",
            fontWeight: FontWeight.w500,
          ),
          btnTitle: context.translate("change_your_country"),
          onPressed: () {},
        ),
        _profileTabContentItem(
          title: "Offer Token",
          child: CommonText.bodyMedium(
            "95f...h45",
            fontWeight: FontWeight.w500,
          ),
          btnTitle: context.translate("show_offer_token"),
          onPressed: () {},
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
              Expanded(
                  child: CommonText.titleMedium(
                "",
                fontWeight: FontWeight.w700,
              )),
              Expanded(
                flex: 4,
                child: CommonText.bodyMedium(
                    context.translate("offer_token_description"),
                    color: Color(0xff98989A)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _profileTabContentItem(
      {required String title,
      required Widget child,
      required String btnTitle,
      required Function() onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 21.0,
        children: [
          Expanded(
              child: CommonText.titleMedium(
            title,
            fontWeight: FontWeight.w700,
          )),
          Expanded(
            flex: 2,
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF262626),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: CommonText.titleSmall(
                    btnTitle,
                    color: Color(0xff98989A),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
