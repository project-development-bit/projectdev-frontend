import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/common/menu/profile_menu.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';

class HeaderProfileAvatar extends StatelessWidget {
  const HeaderProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
      child: UserProfileImageWidget(
          size: 25, borderColor: context.primary), // size 25 means 45X45
    );
  }
}
