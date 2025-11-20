import 'package:cointiply_app/core/common/header/header_coin_balance_box.dart';
import 'package:cointiply_app/core/common/header/header_menu_item.dart';
import 'package:cointiply_app/core/common/header/header_profile_avatar.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class GigaFaucetHeader extends StatelessWidget {
  final String coinBalance;

  const GigaFaucetHeader({
    super.key,
    required this.coinBalance,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final isMobile = context.isMobile;

    return Container(
      alignment: Alignment.center,
      height: 74,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 50 : 100),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFF333333),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/giga_faucet_text_logo.png",
            height: 28,
          ),
          SizedBox(width: 24),
          if (!isMobile) ...[
            HeaderMenuItem(
              label: localizations?.translate("menu_earn_cryptos") ??
                  "Earn Cryptos",
            ),
            HeaderMenuItem(
              label: localizations?.translate("menu_contests") ?? "Contests",
            ),
            HeaderMenuItem(
              label: localizations?.translate("menu_events") ?? "Events",
            ),
            HeaderMenuItem(
              label: localizations?.translate("menu_shop") ?? "Shop",
            ),
            HeaderMenuItem(
              label: localizations?.translate("menu_help") ?? "Help",
            ),
            HeaderMenuItem(
              label: localizations?.translate("menu_blog") ?? "Blog",
            ),
          ],
          const Spacer(),
          if (!isMobile) ...[
            HeaderCoinBalanceBox(coinBalance: coinBalance),
            const SizedBox(width: 16),
          ],
          HeaderProfileAvatar(),
        ],
      ),
    );
  }
}
