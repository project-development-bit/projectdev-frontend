import 'package:flutter/material.dart';
import 'package:gigafaucet/core/common/common_button.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart'
    show MediaQueryExtension;

class SocialFacebookButton extends StatelessWidget {
  const SocialFacebookButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: 'Facebook',
      backgroundColor: Color(0xFF333333),
      onPressed: () {
        onPressed();
      },
      icon: CommonImage(
        imageUrl: AppLocalImages.facebookLogo,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      ),
      padding: context.isMobile ? EdgeInsets.symmetric(horizontal: 0) : null,
      isOutlined: false,
      height: 56,
    );
  }
}
