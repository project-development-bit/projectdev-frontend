import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/reward/data/models/response/reward_level.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_header_row.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_row.dart';
import 'package:flutter/material.dart';

class StatusRewardsTable extends StatelessWidget {
  final List<RewardLevel> levels;

  const StatusRewardsTable({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    const double fixedTableWidth = 800.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.only(bottom: context.isMobile ? 0 : 27),
      child: context.screenWidth < 750
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: fixedTableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const StatusRewardHeaderRow(),
                    const SizedBox(height: 12),
                    ...levels.map((level) => StatusRewardRow(
                          row: StatusRewardRowModel(
                            tier: level.tier,
                            bronzeLabel: "${level.tier} ${level.level}",
                            levelRequired: "${level.level}+",
                            dailySpin: "${level.dailySpin}",
                            treasureChest: "${level.weeklyChest}",
                            offerBoost: "${level.offerBoostPct}%",
                            ptcDiscount: "${level.ptcDiscountPct}%",
                          ),
                        )),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const StatusRewardHeaderRow(),
                const SizedBox(height: 12),
                ...levels.map((level) => StatusRewardRow(
                      row: StatusRewardRowModel(
                        tier: level.tier,
                        bronzeLabel: "${level.tier} ${level.level}",
                        levelRequired: "${level.level}+",
                        dailySpin: "${level.dailySpin}",
                        treasureChest: "${level.weeklyChest}",
                        offerBoost: "${level.offerBoostPct}%",
                        ptcDiscount: "${level.ptcDiscountPct}%",
                      ),
                    )),
              ],
            ),
    );
  }
}
