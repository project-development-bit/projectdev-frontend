import 'package:cointiply_app/core/common/close_square_button.dart';
import 'package:cointiply_app/core/common/common_rich_text_with_ccon.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class RewardDialogHeader extends StatelessWidget {
  const RewardDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.headlineSmall(
                context.translate("rewards_title"),
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
              ),
              CloseSquareButton(
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 27, top: 22),
          child: Divider(
            color: const Color(0xFF003248),
            thickness: 1,
          ),
        ),

        /// DESCRIPTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: CommonRichTextWithIcon(
            prefixText: context.translate("reward_description_prefix"),
            boldNumber: "5",
            suffixText: context.translate("reward_description_suffix"),
            iconPath: "assets/images/rewards/coin.png",
          ),
        ),
      ],
    );
  }
}
