import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_level.dart';
import 'package:cointiply_app/features/reward/presentation/widgets/status_reward_header_row.dart';
import 'package:cointiply_app/features/reward/presentation/widgets/status_reward_row.dart';
import 'package:flutter/material.dart';

class StatusRewardsTableSliver extends StatelessWidget {
  final RewardLevel level;
  final int currentLevel;

  const StatusRewardsTableSliver({
    super.key,
    required this.level,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    const double fixedTableWidth = 800.0;
    final bool isNarrow = context.screenWidth < 750;

    if (isNarrow) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: fixedTableWidth,
                child: _buildTableColumn(),
              ),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return const StatusRewardHeaderRow();
            }
            if (index == 1) {
              return const SizedBox(height: 12);
            }
            final subLevel = level.subLevels[index - 2];
            return StatusRewardRow(
              row: StatusRewardRowModel(
                tier: subLevel.label,
                bronzeLabel: "${subLevel.label} ${subLevel.minLevel}",
                levelRequired: "${subLevel.minLevel}+",
                dailySpin: "${subLevel.dailySpinFree}",
                treasureChest: "${subLevel.weeklyChestFree}",
                offerBoost: "${subLevel.offerBoostPercent}%",
                ptcDiscount: "${subLevel.ptcDiscountPercent}%",
                isCurrentLevel: subLevel.minLevel == currentLevel,
              ),
            );
          },
          childCount: level.subLevels.length + 2,
        ),
      ),
    );
  }

  Widget _buildTableColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const StatusRewardHeaderRow(),
        const SizedBox(height: 12),
        ...level.subLevels.map(
          (subLevel) => StatusRewardRow(
            row: StatusRewardRowModel(
              tier: subLevel.label,
              bronzeLabel: "${subLevel.label} ${subLevel.minLevel}",
              levelRequired: "${subLevel.minLevel}+",
              dailySpin: "${subLevel.dailySpinFree}",
              treasureChest: "${subLevel.weeklyChestFree}",
              offerBoost: "${subLevel.offerBoostPercent}%",
              ptcDiscount: "${subLevel.ptcDiscountPercent}%",
              isCurrentLevel: subLevel.minLevel == currentLevel,
            ),
          ),
        ),
      ],
    );
  }
}
