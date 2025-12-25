import 'package:gigafaucet/core/common/perceant_process_bar.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/reward/domain/entities/user_level_state.dart';
import 'package:flutter/material.dart';

class RewardXpPrograssArea extends StatelessWidget {
  final UserLevelState userlevelState;

  const RewardXpPrograssArea({super.key, required this.userlevelState});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CommonImage(
          imageUrl: AppLocalImages.levelStatusImage(
            userlevelState.currentStatus,
          ),
          height: 50,
          width: 42,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 31),
            child: Column(
              children: [
                CommonText.titleMedium(
                  "[${userlevelState.xpNeededInLevel.toStringAsFixed(0)}]%",
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  highlightColor: colorScheme.primary,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(height: 6),
                PerceantProcessBar(
                  percent: userlevelState.progressPercent / 100,
                  startColor: colorScheme.primary,
                  backgroundColor: const Color(0xFF262626),
                  borderColor: const Color(0xFFB28F0C),
                ),
                const SizedBox(height: 6),
                CommonText.titleMedium(
                  "[${userlevelState.xpNextLevel}] XP to next level",
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
              "${userlevelState.level}",
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
          ],
        )
      ],
    );
  }
}
