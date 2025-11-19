import 'package:cointiply_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';

class StatusRewardsTable extends StatelessWidget {
  const StatusRewardsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

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
        horizontal: 35,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeaderRow(localizations),
          const SizedBox(height: 16),
          ...rows.map((row) => RewardsRow(row: row)),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(AppLocalizations? localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 70), // left spacer for bronze column
        CommonText.bodySmall(
          "Level\nRequired",
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        _HeaderItem(
          image: "assets/images/rewards/daily_spin.png",
          label: localizations?.translate("status_daily_spin") ?? "Daily Spin",
        ),
        _HeaderItem(
          image: "assets/images/rewards/treasure_chest.png",
          label: localizations?.translate("status_treasure_chest") ??
              "Treasure Chest",
        ),
        _HeaderItem(
          image: "assets/images/rewards/offer_boost.png",
          label:
              localizations?.translate("status_offer_boost") ?? "Offer Boost",
        ),
        _HeaderItem(
          image: "assets/images/rewards/ptc_discount.png",
          label: localizations?.translate("status_ptc_discount") ??
              "PTC Ad Discount",
        ),
      ],
    );
  }
}

class RewardsRow extends StatelessWidget {
  final StatusRewardRowModel row;

  const RewardsRow({super.key, required this.row});

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
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              CommonText.bodySmall(
                row.bronzeLabel.split(" ").last, // 1 / 2 / 3
                color: Colors.white,
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

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
                // CommonText.bodyMedium(
                //   row.dailySpin,
                //   color: colorScheme.onPrimary,
                //   fontWeight: FontWeight.w600,
                // ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "1 ",
                        style: (Theme.of(context).brightness == Brightness.dark
                                ? AppTypography.bodyMediumDark
                                : AppTypography.bodyMedium)
                            .copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00A0DC),
                        ),
                      ),
                      TextSpan(
                        text: "Free Daily",
                        style: (Theme.of(context).brightness == Brightness.dark
                                ? AppTypography.bodyMediumDark
                                : AppTypography.bodyMedium)
                            .copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary, // Matches Figma
                        ),
                      ),
                    ],
                  ),
                ),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "1 ",
                        style: (Theme.of(context).brightness == Brightness.dark
                                ? AppTypography.bodyMediumDark
                                : AppTypography.bodyMedium)
                            .copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00A0DC),
                        ),
                      ),
                      TextSpan(
                        text: "Free Per\nWeek",
                        style: (Theme.of(context).brightness == Brightness.dark
                                ? AppTypography.bodyMediumDark
                                : AppTypography.bodyMedium)
                            .copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary, // Matches Figma
                        ),
                      ),
                    ],
                  ),
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

class _HeaderItem extends StatelessWidget {
  final String image;
  final String label;

  const _HeaderItem({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, width: 42),
        const SizedBox(height: 6),
        CommonText.bodySmall(
          label,
          fontWeight: FontWeight.w600,
          color: Colors.white,
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
