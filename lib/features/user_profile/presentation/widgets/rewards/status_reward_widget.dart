import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class StatusRewardsWidget extends StatelessWidget {
  final String selectedTier; // "bronze", "silver", etc.

  const StatusRewardsWidget({
    super.key,
    required this.selectedTier,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final items = [
      StatusTierModel(
        keyName: "bronze",
        image: "assets/images/rewards/bronze_level.png",
        label: localizations?.translate("status_bronze") ?? "Bronze",
      ),
      StatusTierModel(
        keyName: "silver",
        image: "assets/images/rewards/sliver.png",
        label: localizations?.translate("status_silver") ?? "Silver",
      ),
      StatusTierModel(
        keyName: "gold",
        image: "assets/images/rewards/gold.png",
        label: localizations?.translate("status_gold") ?? "Gold",
      ),
      StatusTierModel(
        keyName: "diamond",
        image: "assets/images/rewards/diamond.png",
        label: localizations?.translate("status_diamond") ?? "Diamond",
      ),
      StatusTierModel(
        keyName: "legend",
        image: "assets/images/rewards/legend.png",
        label: localizations?.translate("status_legend") ?? "Legend",
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 21),
      margin: EdgeInsets.only(
        left: 35,
        right: 35,
        top: 40,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1.4,
          color: const Color(0xFF333333), // TODO: use from color scheme
        ),
        image: const DecorationImage(
          image: AssetImage("assets/images/rewards/status_rewards_bg.png"),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          CommonText.headlineSmall(
            localizations?.translate("status_rewards_title") ??
                "Status Rewards",
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00A0DC),
          ),
          SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              double spacing = constraints.maxWidth < 400 ? 10 : 16;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items
                    .map(
                      (tier) => StatusRewardItem(
                        tier: tier,
                        isSelected: tier.keyName == selectedTier,
                        spacing: spacing,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StatusRewardItem extends StatelessWidget {
  final StatusTierModel tier;
  final bool isSelected;
  final double spacing;

  const StatusRewardItem({
    super.key,
    required this.tier,
    required this.isSelected,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 90,
      height: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0x80FFFFFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0x80FFFFFF),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            tier.image,
            width: 40,
            height: 40,
          ),
          SizedBox(height: 6),
          CommonText.titleMedium(
            tier.label,
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class StatusTierModel {
  // TODO move to separate file when api integrated
  final String keyName;
  final String image;
  final String label;

  StatusTierModel({
    required this.keyName,
    required this.image,
    required this.label,
  });
}
