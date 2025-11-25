import 'package:cointiply_app/core/common/header/header_coin_balance_box.dart';
import 'package:cointiply_app/core/common/header/header_menu_item.dart';
import 'package:cointiply_app/core/common/header/header_profile_avatar.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GigaFaucetHeader extends ConsumerWidget {
  const GigaFaucetHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = context.screenWidth;
    final isAuthenticated = ref.watch(isAuthenticatedObservableProvider);
    return HomeSectionContainer(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xFF333333),
            ),
          ),
        ),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(maxWidth: 1240),
            margin: EdgeInsets.symmetric(horizontal: 25),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 1000 ? 30 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  screenWidth < 456
                      ? "assets/images/gigafaucet_logo.png"
                      : "assets/images/giga_faucet_text_logo.png",
                  height: 28,
                ),
                SizedBox(width: 20),
                if (screenWidth > 900) ...[
                  HeaderMenuItem(
                    label: localizations?.translate("menu_earn_cryptos") ??
                        "Earn Cryptos",
                  ),
                  HeaderMenuItem(
                    label:
                        localizations?.translate("menu_contests") ?? "Contests",
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
                if (screenWidth > 280 && isAuthenticated) ...[
                  HeaderCoinBalanceBox(
                    coinBalance: "14,212,568",
                  ),
                  SizedBox(width: screenWidth < 320 ? 8 : 16),
                ],
                isAuthenticated
                    ? HeaderProfileAvatar()
                    : ElevatedButton.icon(
                        onPressed: () => context.go('/auth/login'),
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: context.onPrimary,
                          backgroundColor: context.primary,
                        ),
                      )
              ],
            ),
          ),
        ));
  }
}
