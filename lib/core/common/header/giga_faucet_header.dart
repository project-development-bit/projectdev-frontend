import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/header/header_coin_balance_box.dart';
import 'package:cointiply_app/core/common/header/header_menu_item.dart';
import 'package:cointiply_app/core/common/header/header_profile_avatar.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
        // width: double.infinity,
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
            // constraints: const BoxConstraints(maxWidth: 1240),
            // margin: EdgeInsets.symmetric(horizontal: 17),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 1000 ? 30 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (screenWidth < 900) ...[
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: SvgPicture.asset(
                      "assets/images/icons/menu.svg",
                      height: 32,
                      width: 32,
                    ),
                  ),
                  SizedBox(width: 4),
                ],
                GestureDetector(
                  onTap: () {
                    final currentRoute =
                        GoRouterState.of(context).uri.toString();
                    if (!currentRoute.contains('home')) {
                      context.go('/home');
                    }
                  },
                  child: Image.asset(
                    screenWidth < 360
                        ? "assets/images/gigafaucet_logo.png"
                        : "assets/images/giga_faucet_text_logo.png",
                    height: 28,
                    width: screenWidth < 360
                        ? null
                        : screenWidth < 430
                            ? 111
                            : 131,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: (screenWidth < 900) ? 8 : 20),
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
                isAuthenticated
                    ? Row(
                        children: [
                          HeaderCoinBalanceBox(
                            coinBalance: "14,212,568",
                          ),
                          SizedBox(
                              width: screenWidth < 320 ||
                                      (screenWidth >= 768 && screenWidth < 900)
                                  ? 8
                                  : 16),
                        ],
                      )
                    : CustomUnderLineButtonWidget(
                        //TODO: Change to CustomButtonWidget after getting design confirmation
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        height: 41,
                        onTap: () => context.go('/auth/login'),
                        fontSize: 16,
                        title: 'Login',
                      ),
                if (isAuthenticated) ...[
                  HeaderProfileAvatar(),
                  SizedBox(width: screenWidth < 320 ? 8 : 16),
                ],
              ],
            ),
          ),
        ));
  }
}
