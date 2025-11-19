import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/common/common_text.dart';

class StatusRewardRow extends StatelessWidget {
  final StatusRewardRowModel row;

  const StatusRewardRow({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LEFT — BRONZE COLUMN
        SizedBox(
          width: 70,
          child: Column(
            children: [
              Image.asset("assets/images/rewards/bronze_level.png", width: 42),
              const SizedBox(height: 4),
              CommonText.bodyMedium(
                "Bronze",
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              CommonText.bodySmall(
                row.bronzeLabel
                    .split(" ")
                    .last, // 1 / 2 / 3 //TODO: improve this when api bind
                color: colorScheme.onPrimary,
              ),
            ],
          ),
        ),

        const SizedBox(width: 18),

        // RIGHT — ACTUAL TABLE ROW
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF333333), // TODO: use from color scheme
                  width: 1.3,
                ),
                color: const Color(0xFF131E4D).withValues(alpha: 0.3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonText.bodyMedium(
                  row.levelRequired,
                  color: const Color(0xFF00A0DC),
                  fontWeight: FontWeight.w700,
                ),
                RewardRichText(
                  boldNumber: "1",
                  label: "Free Daily",
                ),
                RewardRichText(
                  boldNumber: "1",
                  label: "Free Per\nWeek",
                ),
                CommonText.bodyMedium(
                  row.offerBoost,
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
                CommonText.bodyMedium(
                  row.ptcDiscount,
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatusRewardRowModel {
  final String bronzeLabel;
  final String levelRequired;
  final String dailySpin;
  final String treasureChest;
  final String offerBoost;
  final String ptcDiscount;

  StatusRewardRowModel({
    required this.bronzeLabel,
    required this.levelRequired,
    required this.dailySpin,
    required this.treasureChest,
    required this.offerBoost,
    required this.ptcDiscount,
  });
}
