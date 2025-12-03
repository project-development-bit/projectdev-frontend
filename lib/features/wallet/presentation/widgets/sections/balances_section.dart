import 'package:flutter/material.dart';
import 'package:cointiply_app/core/core.dart';

class BalancesSection extends StatelessWidget {
  const BalancesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF333333), // TODO: use Color From Scheme
                ),
                color: const Color(0xFF00131E).withValues(alpha: 0.5)),
            child: isMobile
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _balanceItem(
                          "30",
                          localizations?.translate('coins_balance') ??
                              "Coins Balance",
                          colorScheme),
                      const SizedBox(height: 8),
                      CommonText.titleMedium(
                        "=",
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 8),
                      _balanceItem(
                          "\$0.003",
                          localizations?.translate('usd_balance') ??
                              "USD Balance",
                          colorScheme),
                      const SizedBox(height: 8),
                      CommonText.titleMedium(
                        "=",
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 8),
                      _balanceItem(
                          "0.00000003",
                          localizations?.translate('btc_balance') ??
                              "BTC Balance",
                          colorScheme),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _balanceItem(
                          "30",
                          localizations?.translate('coins_balance') ??
                              "Coins Balance",
                          colorScheme),
                      CommonText.titleMedium(
                        "=",
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      _balanceItem(
                          "\$0.003",
                          localizations?.translate('usd_balance') ??
                              "USD Balance",
                          colorScheme),
                      CommonText.titleMedium(
                        "=",
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      _balanceItem(
                          "0.00000003",
                          localizations?.translate('btc_balance') ??
                              "BTC Balance",
                          colorScheme),
                    ],
                  ),
          ),

          const SizedBox(height: 20),

          isMobile
              ? Column(
                  children: [
                    _statItem(
                        "N/A",
                        "Interest Earned",
                        "assets/images/rewards/coin.png",
                        colorScheme,
                        isMobile),
                    const SizedBox(height: 12),
                    _statItem(
                        "15 coins",
                        "Coins Today",
                        "assets/images/rewards/coin.png",
                        colorScheme,
                        isMobile),
                    const SizedBox(height: 12),
                    _statItem(
                        "30 coins",
                        "Coins (7 Days)",
                        "assets/images/rewards/coin.png",
                        colorScheme,
                        isMobile),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem(
                        "N/A",
                        "Interest Earned",
                        "assets/images/rewards/coin.png",
                        colorScheme,
                        isMobile),
                    _statItem(
                        "15 coins",
                        "Coins Today",
                        "assets/images/rewards/coin.png",
                        colorScheme,
                        isMobile),
                    _statItem(
                        "30 coins",
                        "Coins (7 Days)",
                        "assets/images/rewards/coin.png",
                        colorScheme,
                        isMobile),
                  ],
                ),

          const SizedBox(height: 16),

          // Info Text
          CommonText.bodySmall(
            localizations?.translate('balances_update_info') ??
                "Balances update every 10 minutes. History limited to 90 days.",
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  // Helper widget for balance items (Coins Balance, USB Balance, etc.)
  Widget _balanceItem(String value, String label, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleMedium(
          value,
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 12),
        CommonText.bodyMedium(
          label,
          color: const Color(0xFF98989A),
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  // Helper widget for the statistics (Interest Earned, Coins Today, etc.)
  Widget _statItem(String value, String label, String icon,
      ColorScheme colorScheme, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 181,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF333333), //TODO: use Color From Scheme
          ),
          color: const Color(0xFF00131E)
              .withValues(alpha: 0.5)), //TODO: use Color From Scheme
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 24,
            height: 24,
          ),
          SizedBox(height: 9),
          CommonText.titleSmall(
            value,
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 9),
          CommonText.bodySmall(
            label,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
