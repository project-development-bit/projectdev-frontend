import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/reward/domain/entities/reward_level.dart';
import 'package:gigafaucet/features/user_profile/data/enum/user_level.dart';
import 'package:flutter/material.dart';

class StatusRewardsWidget extends StatelessWidget {
  final String selectedTier;
  final List<RewardLevel> tiers;
  final Function(RewardLevel) onTierSelected;

  const StatusRewardsWidget({
    super.key,
    required this.selectedTier,
    required this.tiers,
    required this.onTierSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile || isTablet ? 4 : 26,
        vertical: isMobile ? 8 : 21,
      ),
      margin: EdgeInsets.only(
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
          image: AssetImage(AppLocalImages.statusRewardBg),
          fit: isMobile ? BoxFit.cover : BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          CommonText.headlineSmall(
            t?.translate("status_rewards_title") ?? "Status Rewards",
            fontWeight: FontWeight.w700,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            color: colorScheme.primary,
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
                  children: tiers.map((tier) {
                    final keyName = tier.label.toLowerCase();
                    return StatusRewardItem(
                      tier: tier,
                      isSelected: keyName == selectedTier.toLowerCase(),
                      spacing: 12,
                      onTap: (selectedTier) {
                        final matchedLevel = tiers.firstWhere(
                          (level) => level.label.toLowerCase() == keyName,
                        );
                        onTierSelected(matchedLevel);
                      },
                    );
                  }).toList(),
                ),
              ),
            )

          /// ----------- DESKTOP/TABLET: -------------
          else
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: tiers.map((tier) {
                  final keyName = tier.label.toLowerCase();
                  final isLast = tiers.indexOf(tier) == tiers.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 16),
                    child: StatusRewardItem(
                      tier: tier,
                      isSelected: keyName == selectedTier.toLowerCase(),
                      spacing: 16,
                      onTap: (selectedTier) {
                        final matchedLevel = tiers.firstWhere(
                          (level) => level.label.toLowerCase() == keyName,
                        );
                        onTierSelected(matchedLevel);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class StatusRewardItem extends StatelessWidget {
  final RewardLevel tier;
  final bool isSelected;
  final double spacing;
  final Function(RewardLevel) onTap;

  const StatusRewardItem({
    super.key,
    required this.tier,
    required this.isSelected,
    required this.spacing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    final localizations = AppLocalizations.of(context);
    final UserLevel userLevel = tier.label.toLowerCase().toUserLevel();
    return GestureDetector(
      onTap: () => onTap(tier),
      child: Container(
        width: 90,
        height: 90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x8000131E) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0x80333333) : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(userLevel.asset, width: 40, height: 40),
            const SizedBox(height: 6),
            CommonText.titleMedium(
              userLevel.labelByTier(localizations, tier.label),
              fontSize: isMobile ? 14 : 16,
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
