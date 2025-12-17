import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/double_extensions.dart';
import 'package:gigafaucet/core/extensions/int_extensions.dart';
import 'package:gigafaucet/features/wallet/presentation/providers/get_balance_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalancesSection extends ConsumerWidget {
  const BalancesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = context.screenWidth;
    final isMobile = context.isMobile;
    final balanceState = ref.watch(getBalanceNotifierProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 31),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth < 500
                ? double.infinity
                : screenWidth < 740
                    ? null
                    : 565,
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
                          (balanceState.balance?.coinBalance ?? 0)
                              .currencyFormat(),
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
                          "\$${(balanceState.balance?.usdBalance ?? 0).currencyFormat()}",
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
                          (balanceState.balance?.btcBalance ?? 0)
                              .currencyFormat(),
                          localizations?.translate('btc_balance') ??
                              "BTC Balance",
                          colorScheme),
                    ],
                  )
                : Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      _balanceItem(
                          (balanceState.balance?.coinBalance ?? 0)
                              .currencyFormat(),
                          localizations?.translate('coins_balance') ??
                              "Coins Balance",
                          colorScheme),
                      CommonText.titleMedium(
                        "=",
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      _balanceItem(
                          "\$${(balanceState.balance?.usdBalance ?? 0).currencyFormat()}",
                          localizations?.translate('usd_balance') ??
                              "USD Balance",
                          colorScheme),
                      CommonText.titleMedium(
                        "=",
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      _balanceItem(
                          (balanceState.balance?.btcBalance ?? 0)
                              .currencyFormat(),
                          localizations?.translate('btc_balance') ??
                              "BTC Balance",
                          colorScheme),
                    ],
                  ),
          ),

          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 11,
            spacing: 11,
            children: [
              _statItem(
                  balanceState.balance?.interestEarned != null
                      ? "${balanceState.balance?.interestEarned}"
                      : 'N/A',
                  "Interest Earned",
                  AppLocalImages.coin,
                  colorScheme,
                  screenWidth),
              _statItem(
                  balanceState.balance?.coinsToday != null
                      ? "${balanceState.balance?.coinsToday} coins"
                      : 'N/A',
                  "Coins Today",
                  AppLocalImages.coin,
                  colorScheme,
                  screenWidth),
              _statItem(
                  balanceState.balance?.coinsLast7Days != null
                      ? "${balanceState.balance?.coinsLast7Days} coins"
                      : 'N/A',
                  "Coins (7 Days)",
                  AppLocalImages.coin,
                  colorScheme,
                  screenWidth),
            ],
          ),

          const SizedBox(height: 16),

          // Info Text
          CommonText.bodySmall(
            localizations?.translate('balances_update_info', args: [
                  '${balanceState.balance?.metaInfo.cacheTtlSec != null ? balanceState.balance!.metaInfo.cacheTtlSec / 60 : 0}',
                  '${balanceState.balance?.metaInfo.windowDays ?? 0}',
                ]) ??
                "Balances update every ${balanceState.balance?.metaInfo.cacheTtlSec != null ? balanceState.balance!.metaInfo.cacheTtlSec / 60 : 0} minutes. History limited to ${balanceState.balance?.metaInfo.windowDays ?? 0} days.",
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  // Helper widget for balance items (Coins Balance, USB Balance, etc.)
  Widget _balanceItem(
    String value,
    String label,
    ColorScheme colorScheme,
  ) {
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
      ColorScheme colorScheme, double screenWidth) {
    return Container(
      width: screenWidth < 500 ? double.infinity : 181,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
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
