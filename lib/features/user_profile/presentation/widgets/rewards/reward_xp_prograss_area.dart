import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/perceant_process_bar.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_data.dart';
import 'package:flutter/material.dart';

class RewardXpPrograssArea extends StatelessWidget {
  final RewardData data;

  const RewardXpPrograssArea({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Image.asset(
          "assets/images/levels/${data.currentTier}.png",
          height: 50,
          width: 42,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 31),
            child: Column(
              children: [
                CommonText.titleMedium(
                  "[${data.levelProgressPct.toStringAsFixed(0)}]%",
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  highlightColor: colorScheme.primary,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(height: 6),
                PerceantProcessBar(
                  percent: data.levelProgressPct / 100,
                  startColor: colorScheme.primary,
                  backgroundColor: const Color(0xFF262626),
                  borderColor: const Color(0xFFB28F0C),
                ),
                const SizedBox(height: 6),
                CommonText.titleMedium(
                  "[${data.xpToNextLevel}] XP to next level",
                  fontSize: isMobile ? 16 : 18,
                  color: colorScheme.onPrimary,
                  highlightColor: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                )
              ],
            ),
          ),
        ),
        Column(
          children: [
            CommonText.titleMedium(
              "Level",
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
            CommonText.titleMedium(
              "${data.currentLevel}",
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
          ],
        )
      ],
    );
  }
}
