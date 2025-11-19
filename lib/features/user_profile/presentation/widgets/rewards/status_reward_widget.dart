import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class StatusRewardsWidget extends StatelessWidget {
  final String selectedTier;

  const StatusRewardsWidget({
    super.key,
    required this.selectedTier,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isMobile = context.isMobile;

    final items = [
      StatusTierModel(
        keyName: "bronze",
        image: "assets/images/rewards/bronze_level.png",
        label: t?.translate("status_bronze") ?? "Bronze",
      ),
      StatusTierModel(
        keyName: "silver",
        image: "assets/images/rewards/sliver.png",
        label: t?.translate("status_silver") ?? "Silver",
      ),
      StatusTierModel(
        keyName: "gold",
        image: "assets/images/rewards/gold.png",
        label: t?.translate("status_gold") ?? "Gold",
      ),
      StatusTierModel(
        keyName: "diamond",
        image: "assets/images/rewards/diamond.png",
        label: t?.translate("status_diamond") ?? "Diamond",
      ),
      StatusTierModel(
        keyName: "legend",
        image: "assets/images/rewards/legend.png",
        label: t?.translate("status_legend") ?? "Legend",
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 26,
        vertical: isMobile ? 18 : 21,
      ),
      margin: EdgeInsets.only(
        left: isMobile ? 20 : 35,
        right: isMobile ? 20 : 35,
        top: isMobile ? 26 : 40,
        bottom: isMobile ? 26 : 32,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1.4,
          color: const Color(0xFF333333), //TODO: to use from scheme
        ),
        image: const DecorationImage(
          image: AssetImage("assets/images/rewards/status_rewards_bg.png"),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          CommonText.headlineSmall(
            t?.translate("status_rewards_title") ?? "Status Rewards",
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00A0DC), //TODO: to use from scheme
          ),
          const SizedBox(height: 18),

          /// --- Horizontal Scrollable  List for Mobile ---
          if (isMobile)
            SizedBox(
              height: 110,
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 4, right: 4),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final tier = items[index];
                  return SizedBox(
                    width: 90,
                    child: StatusRewardItem(
                      tier: tier,
                      isSelected: tier.keyName == selectedTier,
                      spacing: 12,
                    ),
                  );
                },
              ),
            )

          /// --- Desktop / Tablet ---
          else
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(tier.image, width: 40, height: 40),
          const SizedBox(height: 6),
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
  final String keyName;
  final String image;
  final String label;

  StatusTierModel({
    required this.keyName,
    required this.image,
    required this.label,
  });
}
