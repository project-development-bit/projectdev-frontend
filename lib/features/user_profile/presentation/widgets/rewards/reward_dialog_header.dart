import 'package:cointiply_app/core/common/close_square_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class RewardDialogHeader extends StatelessWidget {
  const RewardDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 26 : 35),
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
          padding: const EdgeInsets.only(top: 22),
          child: Divider(
            color: const Color(0xFF003248),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
