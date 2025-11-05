import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ProfileTabBar extends StatefulWidget {
  const ProfileTabBar({super.key});

  @override
  State<ProfileTabBar> createState() => _ProfileTabBarState();
}

class _ProfileTabBarState extends State<ProfileTabBar> {
  int selectedIndex = 0;
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    final tabs = [
      {
        "icon": Icons.person_outline,
        "label": localizations?.translate("tab_overview") ?? 'Overview',
      },
      {
        "icon": Icons.settings_outlined,
        "label": localizations?.translate("tab_settings") ?? 'Settings',
      },
      {
        "icon": Icons.attach_money_rounded,
        "label": localizations?.translate("tab_cash_out") ?? 'Cash Out',
      },
      {
        "icon": Icons.account_balance_wallet_outlined,
        "label": localizations?.translate("tab_deposit") ?? 'Deposit',
      },
      {
        "icon": Icons.group_outlined,
        "label": localizations?.translate("tab_referrals") ?? 'Referrals',
      },
      {
        "icon": Icons.card_giftcard_outlined,
        "label": localizations?.translate("tab_bonuses") ?? 'Bonuses',
      },
    ];

    final isMobile = context.isMobile;

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
              final isSelected = selectedIndex == index;
              final isHovered = hoveredIndex == index;

              final bgColor = isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHigh;

              final iconColor = isSelected
                  ? colorScheme.onPrimaryContainer
                  : isHovered
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant;

              final textColor = isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant;

              return MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.symmetric(
                      horizontal: isMobile ? 4 : 6,
                      vertical: isMobile ? 4 : 8,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 18,
                      vertical: isMobile ? 8 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(tab["icon"] as IconData,
                            color: iconColor, size: isMobile ? 16 : 20),
                        SizedBox(width: isMobile ? 6 : 8),
                        CommonText.labelMedium(
                          tab["label"]! as String,
                          color: textColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
