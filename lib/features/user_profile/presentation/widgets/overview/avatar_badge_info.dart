import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/user_profile/presentation/widgets/user_profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarBadgeInfo extends StatelessWidget {
  final String levelImage;
  final String levelText;
  final String messageCount;
  final String location;
  final String createdText;

  const AvatarBadgeInfo({
    super.key,
    required this.levelImage,
    required this.levelText,
    required this.messageCount,
    required this.location,
    required this.createdText,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final colorScheme = Theme.of(context).colorScheme;

    return isMobile
        ? _buildMobile(context, colorScheme)
        : _buildDesktop(context, colorScheme);
  }

  // ============================
  // 📱 MOBILE UI
  // ============================
  Widget _buildMobile(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserProfileImageWidget(size: 60),
            const SizedBox(width: 16),
            Column(
              children: [
                // Level Badge
                Image.asset(levelImage, width: 40),
                const SizedBox(height: 4),
                CommonText.titleMedium(
                  levelText,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppLocalImages.message,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.titleMedium(
                      messageCount,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                    CommonText.bodyLarge(
                      context.translate("profile_message"),
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppLocalImages.location,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 12),
                CommonText.titleMedium(
                  location,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 18),

        CommonText.bodyLarge(
          createdText,
          fontWeight: FontWeight.w500,
          color: colorScheme.onPrimary,
        ),
      ],
    );
  }

  // ============================
  //  DESKTOP UI or TABLET UI
  // ============================
  Widget _buildDesktop(BuildContext context, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        UserProfileImageWidget(size: 50),
        const SizedBox(width: 24),

        // Level Badge
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(levelImage, width: 40),
            const SizedBox(height: 4),
            CommonText.titleMedium(
              levelText,
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
          ],
        ),

        const Spacer(),

        // Right side
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Messages
                Row(
                  children: [
                    SvgPicture.asset(
                      AppLocalImages.message,
                      width: 38,
                      height: 38,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.titleMedium(
                          messageCount,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 4),
                        CommonText.bodyLarge(
                          context.translate("profile_message"),
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                // Location
                Row(
                  children: [
                    SvgPicture.asset(
                      AppLocalImages.location,
                      width: 38,
                      height: 38,
                    ),
                    const SizedBox(width: 12),
                    CommonText.titleMedium(
                      location,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 31.5),
            CommonText.bodyLarge(
              createdText,
              color: colorScheme.onPrimary,
            ),
          ],
        ),
      ],
    );
  }
}
