import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_header_row.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/status_reward_row.dart';
import 'package:flutter/material.dart';

class StatusRewardsTable extends StatelessWidget {
  const StatusRewardsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      StatusRewardRowModel(
        bronzeLabel: "Bronze 1",
        levelRequired: "1+",
        dailySpin: "1 Free Daily",
        treasureChest: "1 Free Per Week",
        offerBoost: "0%",
        ptcDiscount: "0%",
      ),
      StatusRewardRowModel(
        bronzeLabel: "Bronze 2",
        levelRequired: "10+",
        dailySpin: "1 Free Daily",
        treasureChest: "1 Free Per Week",
        offerBoost: "10%",
        ptcDiscount: "0%",
      ),
      StatusRewardRowModel(
        bronzeLabel: "Bronze 3",
        levelRequired: "20+",
        dailySpin: "1 Free Daily",
        treasureChest: "1 Free Per Week",
        offerBoost: "10%",
        ptcDiscount: "0%",
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StatusRewardHeaderRow(),
          const SizedBox(height: 8),
          ...rows.map((row) => StatusRewardRow(row: row)),
        ],
      ),
    );
  }
}
