import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/reward/domain/entities/reward_level.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_header_row.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_row.dart';
import 'package:flutter/material.dart';

class StatusRewardsTableSliver extends StatelessWidget {
  final List<RewardLevel> levels;

  const StatusRewardsTableSliver({
    super.key,
    required this.levels,
  });

  @override
  Widget build(BuildContext context) {
    const double fixedTableWidth = 800.0;
    final bool isNarrow = context.screenWidth < 750;

    if (isNarrow) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(bottom: context.isMobile ? 0 : 27),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: fixedTableWidth,
              child: _buildTableColumn(),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: context.isMobile ? 0 : 27,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return const StatusRewardHeaderRow();
            }
            if (index == 1) {
              return const SizedBox(height: 12);
            }
            final level = levels[index - 2];
            return StatusRewardRow(
              row: StatusRewardRowModel(
                tier: level.tier,
                bronzeLabel: "${level.tier} ${level.level}",
                levelRequired: "${level.level}+",
                dailySpin: "${level.dailySpin}",
                treasureChest: "${level.weeklyChest}",
                offerBoost: "${level.offerBoostPct}%",
                ptcDiscount: "${level.ptcDiscountPct}%",
              ),
            );
          },
          childCount: levels.length + 2,
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
        ...levels.map(
          (level) => StatusRewardRow(
            row: StatusRewardRowModel(
              tier: level.tier,
              bronzeLabel: "${level.tier} ${level.level}",
              levelRequired: "${level.level}+",
              dailySpin: "${level.dailySpin}",
              treasureChest: "${level.weeklyChest}",
              offerBoost: "${level.offerBoostPct}%",
              ptcDiscount: "${level.ptcDiscountPct}%",
            ),
          ),
        ),
      ],
    );
  }
}
