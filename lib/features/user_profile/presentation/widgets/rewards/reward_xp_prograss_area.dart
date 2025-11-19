import 'package:cointiply_app/core/common/common_rich_text_ab.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/perceant_process_bar.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class RewardXpPrograssArea extends StatelessWidget {
  const RewardXpPrograssArea({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/levels/bronze.png",
            height: 50,
            width: 42,
            fit: BoxFit.contain,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Column(
                children: [
                  /// 78%
                  CommonRichTextAB(
                    primary: "78",
                    secondary:
                        context.translate("reward_progress_percent_symbol"),
                    primaryColor: const Color(0xFF00A0DC),
                    secondaryColor: colorScheme.onPrimary,
                  ),

                  const SizedBox(height: 8),

                  /// Percent Bar
                  PerceantProcessBar(
                    percent: 0.78,
                    startColor: colorScheme.primary,
                    backgroundColor: const Color(0xFF262626),
                    borderColor: const Color(0xFFB28F0C),
                  ),

                  const SizedBox(height: 8),

                  /// XP to next level
                  CommonRichTextAB(
                    primary: "2,452 ",
                    secondary: context.translate("reward_next_level_label"),
                    primaryColor: const Color(0xFF00A0DC),
                    secondaryColor: colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),

          /// Level column
          Column(
            children: [
              CommonText.titleMedium(
                context.translate("reward_level_label"),
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
              ),
              CommonText.titleMedium(
                "20",
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
