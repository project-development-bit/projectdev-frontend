import 'package:flutter/material.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart'
    show MediaQueryExtension, CommonButton;

class SocialGoogleButton extends StatelessWidget {
  const SocialGoogleButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: 'Google',
      backgroundColor: Color(0xFF333333),
      onPressed: () {
        onPressed();
      },
      icon: CommonImage(
        imageUrl: AppLocalImages.googleLogo,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ),
      isOutlined: false,
      fontSize: 14,
      padding: context.isMobile ? EdgeInsets.symmetric(horizontal: 0) : null,
      height: 56,
    );
  }
}
