import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/core/theme/data/models/app_settings_model.dart';
import 'package:cointiply_app/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBannerSection extends ConsumerWidget {
  const HomeBannerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final banners = ref.watch(bannersConfigProvider);

    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final bannerHeight = isMobile ? 280.0 : 350.0;

    // Fallback static background image
    final fallbackImage = Image.asset(
      isMobile
          ? 'assets/images/bg/banner mobile.png'
          : 'assets/images/bg/banner web.png',
      width: double.infinity,
      height: bannerHeight,
      fit: BoxFit.cover,
    );

    if (banners.isEmpty) {
      // Just show static background if no banners from API
      return SizedBox(
        width: double.infinity,
        height: bannerHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            fallbackImage,
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText.titleLarge(
                    localizations?.translate('home_banner_fallback_title') ??
                        'Trusted and Secure Bitcoin and Crypto Faucet',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 24 : 32,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 16),
                  CommonText.bodyMedium(
                    localizations
                            ?.translate('home_banner_fallback_description') ??
                        'We prioritize security, transparency, and a seamless user experience. So you can earn crypto with confidence, every day.',
                    textAlign: TextAlign.center,
                    color: colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return BannerSlide(
            banner: banner,
            height: bannerHeight,
            fallbackImage: fallbackImage,
          );
        },
      ),
    );
  }
}

class BannerSlide extends StatelessWidget {
  final BannerConfig banner;
  final double height;
  final Widget fallbackImage;

  const BannerSlide({
    super.key,
    required this.banner,
    required this.height,
    required this.fallbackImage,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final contentMaxWidth = isMobile ? size.width * 0.9 : 760.0;

    final ctaText = banner.btnText.isNotEmpty
        ? banner.btnText
        : (localizations?.translate('home_banner_cta') ?? 'Claim Now');

    return Stack(
      fit: StackFit.expand,
      children: [
        CommonImage(
          imageUrl: isMobile ? banner.imageMobile : banner.imageWeb,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorWidget: fallbackImage,
          loadingWidget: fallbackImage,
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (banner.badge.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Color(0xFF195DCC), //TODO: Use from theme
                        width: 1,
                      ),
                      color: Colors.transparent,
                    ),
                    child: CommonText.bodyMedium(
                      banner.badge,
                      color: Color(0xFF00A0DC), //TODO: Use from theme
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (banner.title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CommonText.titleLarge(
                      banner.title,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 24 : 32,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                if (banner.description.isNotEmpty && context.screenWidth >= 400)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: CommonText.bodyMedium(
                      banner.description,
                      textAlign: TextAlign.center,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                CustomUnderLineButtonWidget(
                  onTap: () {},
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  isActive: true,
                  width: 140,
                  title: ctaText,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
