import 'package:gigafaucet/core/common/footer/footer_section.dart';
import 'package:gigafaucet/core/common/store_button.dart';
import 'package:gigafaucet/features/home/presentation/widgets/home_section_container.dart';
import 'package:gigafaucet/features/terms_privacy/presentation/services/terms_privacy_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';

class GigaFooter extends StatelessWidget {
  const GigaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isMobile = context.isMobile;
    final screenWidth = context.screenWidth;

    return !context.isMobile
        ? HomeSectionContainer(
            width: double.infinity,
            child: Center(
              child: Container(
                width: double.infinity,
                color: colorScheme.surface,
                constraints: const BoxConstraints(maxWidth: 1240),
                padding: const EdgeInsets.symmetric(vertical: 40),
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    _buildResponsiveLayout(context, screenWidth, isMobile),
                    const SizedBox(height: 40),
                    CommonText.bodyMedium(
                      "${DateTime.now().year} GigaFaucet",
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  // -----------------------------------------------------------
  // RESPONSIVE LAYOUT LOGIC (unchanged breakpoints)
  // -----------------------------------------------------------

  Widget _buildResponsiveLayout(
      BuildContext context, double screenWidth, bool isMobile) {
    if (screenWidth <= 850 && screenWidth >= 655) {
      return _buildTabletLayout(context);
    }

    if (screenWidth < 680 && screenWidth > 400) {
      return _buildMidMobileLayout(context);
    }

    if (isMobile) {
      return _buildMobileLayout(context);
    }

    return _buildDesktopLayout(context);
  }

  // -----------------------------------------------------------
  // DESKTOP
  // -----------------------------------------------------------

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(context),
        _buildAboutSection(context),
        _buildServicesSection(context),
        _buildInfoSection(context),
        _buildMobileAppSection(context),
      ],
    );
  }

  // -----------------------------------------------------------
  // TABLET (your exact rule: 850 >= width >= 655)
  // -----------------------------------------------------------

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(context),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAboutSection(context),
            _buildServicesSection(context),
            _buildInfoSection(context),
            _buildMobileAppSection(context),
          ],
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  // MID-MOBILE (your exact rule: 680 > width > 400)
  // -----------------------------------------------------------

  Widget _buildMidMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(context),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAboutSection(context),
            _buildServicesSection(context),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoSection(context),
            _buildMobileAppSection(context),
          ],
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  // MOBILE
  // -----------------------------------------------------------

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(context),
        const SizedBox(height: 32),
        _buildAboutSection(context),
        _buildServicesSection(context),
        _buildInfoSection(context),
        _buildMobileAppSection(context),
      ],
    );
  }

  // -----------------------------------------------------------
  // SECTIONS
  // -----------------------------------------------------------

  Widget _buildLogo(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          final currentRoute = GoRouterState.of(context).uri.toString();
          if (!currentRoute.contains('home')) {
            context.go('/home');
          }
        },
        child: Image.asset(
          "assets/images/giga_faucet_color_text_logo.png",
          height: 32,
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) => FooterSection(
        title: context.translate("footer_about"),
        actions: {
          context.translate("footer_faq"): () {},
          context.translate("footer_privacy"): () {
            // Navigate to Privacy Policy page
            context.showPrivacy();
          },
          context.translate("footer_cookie"): () {},
          context.translate("footer_terms"): () {
            // Navigate to Terms of Service page
            context.showTerms();
          },
        },
        items: [
          context.translate("footer_faq"),
          context.translate("footer_privacy"),
          context.translate("footer_cookie"),
          context.translate("footer_terms"),
        ],
      );

  Widget _buildServicesSection(BuildContext context) => FooterSection(
        title: context.translate("footer_services"),
        items: [
          context.translate("footer_support"),
          context.translate("footer_advertise"),
          context.translate("footer_leaderboard"),
          context.translate("footer_affiliate"),
        ],
      );

  Widget _buildInfoSection(BuildContext context) => FooterSection(
        title: context.translate("footer_info"),
        items: [
          context.translate("footer_forum"),
          context.translate("footer_testimonials"),
          context.translate("footer_cashout"),
        ],
      );

  Widget _buildMobileAppSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.bodyMedium(
          context.translate("footer_mobile_app"),
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 32),
        const GigaStoreButton(type: StoreButtonType.googlePlay),
        const SizedBox(height: 8),
        const GigaStoreButton(type: StoreButtonType.appStore),
      ],
    );
  }
}
