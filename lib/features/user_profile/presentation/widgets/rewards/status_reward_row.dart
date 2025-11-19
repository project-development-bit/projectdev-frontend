import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/rewards/reward_rich_text.dart';

class StatusRewardRow extends StatelessWidget {
  final StatusRewardRowModel row;

  const StatusRewardRow({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const double columnWidth = 89.0; // Fixed width to match Header

    return Padding(
      padding: EdgeInsets.only(bottom: context.isMobile ? 8 : 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/rewards/bronze_level.png",
                  width: 42,
                ),
                const SizedBox(height: 4),
                CommonText.bodyMedium(
                  "Bronze",
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                CommonText.bodySmall(
                  row.bronzeLabel.split(" ").last,
                  color: colorScheme.onPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF333333),
                  width: 1.3,
                ),
                color: const Color(0xFF131E4D).withValues(alpha: 0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 64,
                    child: Center(
                      child: CommonText.bodyMedium(
                        row.levelRequired,
                        color: const Color(0xFF00A0DC),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  /// 2. Daily Spin
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: RewardRichText(
                        boldNumber: "1",
                        label: "Free Daily",
                      ),
                    ),
                  ),

                  /// 3. Treasure Chest
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: RewardRichText(
                        boldNumber: "1",
                        label: "Free Per\nWeek",
                      ),
                    ),
                  ),

                  /// 4. Offer Boost
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: CommonText.bodyMedium(
                        row.offerBoost,
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  /// 5. PTC Discount
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: CommonText.bodyMedium(
                        row.ptcDiscount,
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
