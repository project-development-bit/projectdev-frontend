import 'package:carousel_slider/carousel_slider.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/extensions.dart';
import 'package:gigafaucet/features/localization/data/helpers/app_localizations.dart';
import 'package:gigafaucet/core/theme/data/models/app_settings_model.dart';
import 'package:gigafaucet/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentBannerIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class HomeBannerSection extends ConsumerStatefulWidget {
  const HomeBannerSection({super.key});

  @override
  ConsumerState<HomeBannerSection> createState() => HomeBannerSectionState();
}

class HomeBannerSectionState extends ConsumerState<HomeBannerSection> {
  final CarouselSliderController bannerCarouselController =
      CarouselSliderController();

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
      isMobile ? AppLocalImages.bannerMobile : AppLocalImages.bannerDesktop,
      width: double.infinity,
      height: bannerHeight,
      fit: BoxFit.cover,
    );
    final currentPageIndex = ref.watch(currentBannerIndexProvider);
    final colorScheme = Theme.of(context).colorScheme;
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
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(
                seconds: 5,
              ),
              autoPlayCurve: Curves.linear,
              enableInfiniteScroll: banners.length > 1,
              onPageChanged: (index, reason) {
                ref.read(currentBannerIndexProvider.notifier).state = index;
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: isMobile ? 0 : null,
            right: isMobile ? 0 : 76,
            child: Row(
                mainAxisAlignment:
                    isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
                children: [
                  // _ArrowIconWidget(
                  //   onTap: () {
                  //     if (currentPageIndex < banners.length - 1) {
                  //       bannerCarouselController.previousPage();
                  //     } else {
                  //       bannerCarouselController.animateToPage(0);
                  //     }
                  //   },
                  //   iconData: Icons.arrow_back_ios,
                  // ),
                  ...List.generate(
                    banners.length,
                    (index) => GestureDetector(
                        onTap: () {
                          bannerCarouselController.animateToPage(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: currentPageIndex == index
                                ? colorScheme.primary
                                : colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: currentPageIndex == index
                            //       ? Colors.white.withValues(alpha: 0.8)
                            //       : const Color(0xFFB8B8B8),
                            //   width: 2,
                            // ),
                          ),
                        )),
                  ),
                  // _ArrowIconWidget(
                  //   onTap: () {
                  //     if (currentPageIndex < banners.length - 1) {
                  //       bannerCarouselController.nextPage();
                  //     } else {
                  //       bannerCarouselController.animateToPage(0);
                  //     }
                  //   },
                  //   iconData: Icons.arrow_forward_ios,
                  // ),
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

// class _ArrowIconWidget extends StatefulWidget {
//   const _ArrowIconWidget({required this.onTap, required this.iconData});
//   final VoidCallback onTap;
//   final IconData iconData;

//   @override
//   State<_ArrowIconWidget> createState() => _ArrowIconWidgetState();
// }

// class _ArrowIconWidgetState extends State<_ArrowIconWidget> {
//   bool isHover = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: MouseRegion(
//         onEnter: (_) => setState(() => isHover = true),
//         onExit: (_) => setState(() => isHover = false),
//         cursor: SystemMouseCursors.click,
//         child: Container(
//           width: 30,
//           height: 30,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               border: Border.all(
//                 color: isHover ? Colors.white : const Color(0xFF7E7E81),
//                 width: 1,
//               ),
//               shape: BoxShape.circle),
//           child: Icon(
//             widget.iconData,
//             color: isHover
//                 ? Colors.white
//                 : const Color(0xFF7E7E81), // TODO: use from theme
//             size: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }
