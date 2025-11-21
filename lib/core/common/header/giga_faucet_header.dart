import 'package:cointiply_app/core/common/header/header_coin_balance_box.dart';
import 'package:cointiply_app/core/common/header/header_menu_item.dart';
import 'package:cointiply_app/core/common/header/header_profile_avatar.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GigaFaucetHeader extends StatelessWidget {
  const GigaFaucetHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final screenWidth = context.screenWidth;

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
              horizontal: isMobile || isTablet ? 30 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if (isMobile || isTablet) SizedBox(width: 30),
                Image.asset(
                  "assets/images/giga_faucet_text_logo.png",
                  height: 28,
                ),
                SizedBox(width: 20),
                if (!isMobile && !isTablet) ...[
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
                if (screenWidth > 500) ...[
                  Consumer(
                    builder: (context, ref, child) {
                      final isAuthenticated =
                          ref.watch(isAuthenticatedObservableProvider);
                      if (isAuthenticated) {
                        return Row(
                          children: [
                            HeaderCoinBalanceBox(
                              coinBalance: "14,212,568",
                            ),
                            const SizedBox(width: 16),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ],
                Consumer(
                  builder: (context, ref, child) {
                    final isAuthenticated =
                        ref.watch(isAuthenticatedObservableProvider);

                    if (isAuthenticated) {
                      return HeaderProfileAvatar();
                    } else {
                      return ElevatedButton.icon(
                        onPressed: () => context.go('/auth/login'),
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: context.onPrimary,
                          backgroundColor: context.primary,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
