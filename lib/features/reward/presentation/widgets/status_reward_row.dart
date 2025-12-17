import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:flutter/material.dart';

class StatusRewardRow extends StatelessWidget {
  final StatusRewardRowModel row;

  const StatusRewardRow({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const double columnWidth = 89.0;
    final localizations = AppLocalizations.of(context);
    final dailySpinText =
        (localizations?.translate('status_rewards_daily_spin') ?? '')
            .replaceAll('{count}', row.dailySpin.toString());

    final treasureChestText =
        (localizations?.translate('status_rewards_treasure_chest') ?? '')
            .replaceAll('{count}', row.treasureChest.toString());
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
                  _tierImage(),
                  width: 42,
                ),
                const SizedBox(height: 4),
                CommonText.bodyMedium(
                  row.bronzeLabel.split(" ").first,
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
                CommonText.bodyMedium(
                  row.bronzeLabel.split(" ").last,
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF333333),
                  width: 1.3,
                ),
                color: row.isCurrentLevel
                    ? const Color(0xFF00131E)
                    : const Color(0xFF00131E).withValues(alpha: 0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  "),
                  SizedBox(
                    width: 64,
                    child: Center(
                      child: CommonText.titleMedium(
                        row.levelRequired,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  /// 2. Daily Spin
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: CommonText.bodyMedium(
                        dailySpinText,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                        highlightColor: colorScheme.onPrimary,
                      ),
                    ),
                  ),

                  /// 3. Treasure Chest
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: CommonText.bodyMedium(
                        treasureChestText,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                        highlightColor: colorScheme.onPrimary,
                      ),
                    ),
                  ),

                  /// 4. Offer Boost
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: CommonText.titleMedium(
                        row.offerBoost,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  /// 5. PTC Discount
                  SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: CommonText.titleMedium(
                        row.ptcDiscount,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
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

  String _tierImage() {
    switch (row.bronzeLabel.split(" ").first.toLowerCase()) {
      case "bronze":
        return AppLocalImages.bronze;
      case "silver":
        return AppLocalImages.silver;
      case "gold":
        return AppLocalImages.gold;
      case "diamond":
        return AppLocalImages.diamond;
      case "legend":
        return AppLocalImages.legend;
      default:
        return AppLocalImages.bronze;
    }
  }
}

class StatusRewardRowModel {
  final String tier;
  final String bronzeLabel;
  final String levelRequired;
  final String dailySpin;
  final String treasureChest;
  final String offerBoost;
  final String ptcDiscount;
  final bool isCurrentLevel;

  StatusRewardRowModel({
    required this.tier,
    required this.bronzeLabel,
    required this.levelRequired,
    required this.dailySpin,
    required this.treasureChest,
    required this.offerBoost,
    required this.ptcDiscount,
    this.isCurrentLevel = false,
  });
}
