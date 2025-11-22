import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class StatusRewardsWidget extends StatelessWidget {
  final String selectedTier;
  final List<String> tiers;

  const StatusRewardsWidget({
    super.key,
    required this.selectedTier,
    required this.tiers,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    final items = tiers.map((e) {
      final tier = e.toLowerCase();
      return StatusTierModel(
        keyName: tier,
        image: _tierImage(tier),
        label: _tierLabel(t, tier),
      );
    }).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile || isTablet ? 4 : 26,
        vertical: isMobile ? 8 : 21,
      ),
      margin: EdgeInsets.only(
        left: isMobile ? 4 : 35,
        right: isMobile ? 4 : 35,
        top: isMobile ? 26 : 40,
        bottom: isMobile ? 26 : 32,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1.4,
          color: const Color(0xFF333333),
        ),
        image: DecorationImage(
          image: AssetImage("assets/images/rewards/status_rewards_bg.png"),
          fit: isMobile ? BoxFit.cover : BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          CommonText.headlineSmall(
            t?.translate("status_rewards_title") ?? "Status Rewards",
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00A0DC),
          ),

          const SizedBox(height: 18),

          /// ----------- MOBILE: 2 ROW GRID -------------

          if (isMobile)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: (90 * 3) + (16 * 2),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: items.map((tier) {
                    return StatusRewardItem(
                      tier: tier,
                      isSelected: tier.keyName == selectedTier,
                      spacing: 12,
                    );
                  }).toList(),
                ),
              ),
            )

          /// ----------- DESKTOP/TABLET: -------------
          else
            SizedBox(
              height: 120,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: items.map((tier) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: StatusRewardItem(
                        tier: tier,
                        isSelected: tier.keyName == selectedTier,
                        spacing: 16,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _tierImage(String tier) {
    switch (tier) {
      case "bronze":
        return "assets/images/rewards/bronze_level.png";
      case "silver":
        return "assets/images/rewards/sliver.png";
      case "gold":
        return "assets/images/rewards/gold.png";
      case "diamond":
        return "assets/images/rewards/diamond.png";
      case "legend":
        return "assets/images/rewards/legend.png";
      default:
        return "assets/images/rewards/bronze_level.png";
    }
  }

  /// Localization helper
  String _tierLabel(AppLocalizations? t, String tier) {
    switch (tier) {
      case "bronze":
        return t?.translate("status_bronze") ?? "Bronze";
      case "silver":
        return t?.translate("status_silver") ?? "Silver";
      case "gold":
        return t?.translate("status_gold") ?? "Gold";
      case "diamond":
        return t?.translate("status_diamond") ?? "Diamond";
      case "legend":
        return t?.translate("status_legend") ?? "Legend";
      default:
        return tier;
    }
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
    final isMobile = context.isMobile;
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
            fontSize: isMobile ? 14 : 16,
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
