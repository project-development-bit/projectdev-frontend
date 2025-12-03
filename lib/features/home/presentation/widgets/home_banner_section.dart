import 'package:carousel_slider/carousel_slider.dart';
import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/core/theme/data/models/app_settings_model.dart';
import 'package:cointiply_app/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBannerSection extends ConsumerStatefulWidget {
  const HomeBannerSection({super.key});

  @override
  ConsumerState<HomeBannerSection> createState() => HomeBannerSectionState();
}

class HomeBannerSectionState extends ConsumerState<HomeBannerSection> {
  final CarouselSliderController bannerCarouselController =
      CarouselSliderController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannersConfigProvider);
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final bannerHeight = isMobile ? 280.0 : 350.0;

    // Fallback static background image
    final fallbackImage = Image.asset(
      isMobile
          ? 'assets/images/bg/banner_mobile@2x.png'
          : 'assets/images/bg/banner_web@2x.png',
      width: double.infinity,
      height: bannerHeight,
      fit: BoxFit.cover,
    );
    // final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: Stack(
        children: [
          CarouselSlider.builder(
            carouselController: bannerCarouselController,
            itemCount: banners.length,
            itemBuilder: (context, index, realIndex) {
              final banner = banners[index];
              return BannerSlide(
                banner: banner,
                height: bannerHeight,
                fallbackImage: fallbackImage,
              );
            },
            options: CarouselOptions(
              height: bannerHeight,
              viewportFraction: 1.0,
              autoPlay: banners.length > 1,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 500),
              autoPlayCurve: Curves.easeInOut,
              enableInfiniteScroll: banners.length > 1,
              onPageChanged: (index, reason) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: isMobile ? 0 : null,
            right: isMobile ? 0 : 10,
            child: Row(
                mainAxisAlignment:
                    isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentPageIndex < banners.length - 1) {
                        bannerCarouselController.previousPage();
                      } else {
                        bannerCarouselController.animateToPage(0);
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF00A0DC), // TODO: use from theme
                        size: 16,
                      ),
                    ),
                  ),
                  ...List.generate(
                    banners.length,
                    (index) => GestureDetector(
                        onTap: () {
                          bannerCarouselController.animateToPage(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentPageIndex == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPageIndex == index
                                ? const Color(0xFF00A0DC)
                                : const Color(0xFFB8B8B8),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: currentPageIndex == index
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : const Color(0xFFB8B8B8),
                              width: 2,
                            ),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (currentPageIndex < banners.length - 1) {
                        bannerCarouselController.nextPage();
                      } else {
                        bannerCarouselController.animateToPage(0);
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.arrow_forward,
                        color: const Color(0xFF00A0DC), // TODO: use from theme
                        size: 16,
                      ),
                    ),
                  ),
                ]),
          )
        ],
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
        : (localizations?.translate('claim_now') ?? 'Claim Now');

    return Stack(
      fit: StackFit.expand,
      children: [
        CommonImage(
          imageUrl: isMobile ? banner.imageMobile : banner.imageWeb,
          // imageUrl: isMobile
          //     ? 'assets/images/bg/banner_mobile@2x.png'
          //     : 'assets/images/bg/banner_web@2x.png',
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
                if (banner.label.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const Color(0xFF195DCC), // TODO: use from theme
                        width: 1,
                      ),
                      color: Colors.transparent,
                    ),
                    child: CommonText.bodyMedium(
                      banner.label,
                      color: const Color(0xFF00A0DC), // TODO: use from theme
                      fontSize: isMobile ? 8 : 14,
                      fontWeight: FontWeight.w500,
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
                      fontSize: isMobile ? 20 : 40,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                if (banner.description.isNotEmpty && context.screenWidth >= 400)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: CommonText.bodyMedium(
                      banner.description,
                      fontSize: isMobile ? 10 : 16,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                CustomUnderLineButtonWidget(
                  onTap: () {
                    // context.goNamed(banner.link); // TODO: handle navigation when ready
                  },
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  isActive: true,
                  width: 140,
                  title: ctaText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
