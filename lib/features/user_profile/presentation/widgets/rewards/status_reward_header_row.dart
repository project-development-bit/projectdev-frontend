import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class StatusRewardHeaderRow extends StatelessWidget {
  const StatusRewardHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 70), // spacer for bronze icon

        CommonText.titleSmall(
          localizations?.translate("status_level_required") ??
              "Level\nRequired",
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
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
          image: "assets/images/rewards/offer_boost_reward.png",
          label:
              localizations?.translate("status_offer_boost") ?? "Offer Boost",
        ),
        _HeaderItem(
          image: "assets/images/rewards/ptc_ad_discount.png",
          label: localizations?.translate("status_ptc_discount") ??
              "PTC Ad Discount",
        ),
      ],
    );
  }
}

class _HeaderItem extends StatelessWidget {
  final String image;
  final String label;

  const _HeaderItem({
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      width: 89,
      height: 99,
      child: Column(
        children: [
          Image.asset(image, width: 42),
          const SizedBox(height: 6),
          CommonText.titleSmall(
            label,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
