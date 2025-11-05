import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class RewardGridWidget extends StatefulWidget {
  const RewardGridWidget({super.key});

  @override
  State<RewardGridWidget> createState() => _RewardGridWidgetState();
}

class _RewardGridWidgetState extends State<RewardGridWidget> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    final rewards = [
      {
        "title": localizations?.translate("reward_daily_spin_title") ?? "",
        "subtitle":
            localizations?.translate("reward_daily_spin_subtitle") ?? "",
        "image": "assets/images/rewards/bonus_spin.png",
        "active": true,
      },
      {
        "title": localizations?.translate("reward_mystery_box_title") ?? "",
        "subtitle":
            localizations?.translate("reward_mystery_box_subtitle") ?? "",
        "image": "assets/images/rewards/mystery_box.png",
        "active": true,
      },
      {
        "title": localizations?.translate("reward_offer_boost_title") ?? "",
        "subtitle":
            localizations?.translate("reward_offer_boost_subtitle") ?? "",
        "image": "assets/images/rewards/offer_boost.png",
        "active": false,
      },
      {
        "title": localizations?.translate("reward_ptc_discount_title") ?? "",
        "subtitle":
            localizations?.translate("reward_ptc_discount_subtitle") ?? "",
        "image": "assets/images/rewards/ptc_discount.png",
        "active": false,
      },
    ];

    int crossAxisCount = 4;
    if (context.isTablet) crossAxisCount = 2;
    if (context.isMobile) crossAxisCount = 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 170,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final isActive = reward["active"] == true;
        final isHovered = hoveredIndex == index;

        final borderColor = isActive
            ? colorScheme.primary
            : isHovered
                ? colorScheme.secondary
                : colorScheme.outline;

        return MouseRegion(
          onEnter: (_) => setState(() => hoveredIndex = index),
          onExit: (_) => setState(() => hoveredIndex = null),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 1.4,
              ),
              boxShadow: [
                if (isHovered && !context.isMobile)
                  BoxShadow(
                    color: colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  reward["image"] as String,
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                CommonText.titleMedium(
                  reward["title"] as String,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                CommonText.bodySmall(
                  reward["subtitle"] as String,
                  color: colorScheme.onSurfaceVariant,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
