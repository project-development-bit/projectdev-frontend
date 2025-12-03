import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class TransactionDesktopHeader extends StatelessWidget {
  const TransactionDesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // final colorScheme = Theme.of(context).colorScheme;

    final headers = [
      localizations?.translate("tx_description") ?? "Description",
      localizations?.translate("tx_status") ?? "Status",
      localizations?.translate("tx_amount") ?? "Amount",
      localizations?.translate("tx_coins") ?? "Coins",
      localizations?.translate("tx_currency") ?? "Currency",
      localizations?.translate("tx_address") ?? "Address",
      localizations?.translate("tx_date") ?? "Date",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: headers.map((e) {
          return Expanded(
            flex: 1,
            child: CommonText.bodyMedium(
              e,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF98989A), //TODO: use Color From Scheme
            ),
          );
        }).toList(),
      ),
    );
  }
}
