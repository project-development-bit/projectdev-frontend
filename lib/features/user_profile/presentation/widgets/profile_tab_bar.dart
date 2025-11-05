import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/data/enum/profile_tab_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_tab_provider.dart';

class ProfileTabBar extends ConsumerWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final isMobile = context.isMobile;

    final activeTab = ref.watch(profileTabProvider);

    final tabs = [
      {
        "type": ProfileTabType.overview,
        "icon": Icons.person_outline,
        "label": localizations?.translate("tab_overview") ?? 'Overview'
      },
      {
        "type": ProfileTabType.settings,
        "icon": Icons.settings_outlined,
        "label": localizations?.translate("tab_settings") ?? 'Settings'
      },
      {
        "type": ProfileTabType.cashOut,
        "icon": Icons.attach_money_rounded,
        "label": localizations?.translate("tab_cash_out") ?? 'Cash Out'
      },
      {
        "type": ProfileTabType.deposit,
        "icon": Icons.account_balance_wallet_outlined,
        "label": localizations?.translate("tab_deposit") ?? 'Deposit'
      },
      {
        "type": ProfileTabType.referrals,
        "icon": Icons.group_outlined,
        "label": localizations?.translate("tab_referrals") ?? 'Referrals'
      },
      {
        "type": ProfileTabType.bonuses,
        "icon": Icons.card_giftcard_outlined,
        "label": localizations?.translate("tab_bonuses") ?? 'Bonuses'
      },
    ];

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
            children: tabs.map((tab) {
              final isSelected = activeTab == tab["type"];
              final iconColor = isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant;

              final textColor = isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant;

              return GestureDetector(
                onTap: () => ref.read(profileTabProvider.notifier).state =
                    tab["type"] as ProfileTabType,
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
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHigh,
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
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
