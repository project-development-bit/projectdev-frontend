import 'package:cointiply_app/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/data/models/app_settings_model.dart';

/// Widget to display banners from app settings
class DynamicBannersWidget extends ConsumerWidget {
  final double height;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;

  const DynamicBannersWidget({
    super.key,
    this.height = 120,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(appBannersConfigProvider);

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    if (banners.length == 1) {
      return Padding(
        padding: padding,
        child: _BannerItem(
          banner: banners.first,
          height: height,
          borderRadius: borderRadius,
        ),
      );
    }

    // Multiple banners - use PageView
    return SizedBox(
      height: height + padding.vertical,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: padding,
            child: _BannerItem(
              banner: banners[index],
              height: height,
              borderRadius: borderRadius,
            ),
          );
        },
      ),
    );
  }
}

/// Individual banner item
class _BannerItem extends StatelessWidget {
  final BannerConfig banner;
  final double height;
  final BorderRadius? borderRadius;

  const _BannerItem({
    required this.banner,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleBannerTap(context),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Image.network(
          MediaQuery.of(context).size.width < 768
              ? banner.imageMobile
              : banner.imageWeb,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: borderRadius ?? BorderRadius.circular(12),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: borderRadius ?? BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleBannerTap(BuildContext context) async {
    try {
      // Check if it's an internal route (starts with /)
      if (banner.link.startsWith('/')) {
        // Navigate internally using GoRouter
        context.go(banner.link);
      } else {
        // External URL - show a dialog or snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('External link: ${banner.link}'),
              action: SnackBarAction(
                label: 'Copy',
                onPressed: () {
                  // You can implement clipboard copy here if needed
                },
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error opening banner link: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error opening link'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// Carousel widget for multiple banners with auto-scroll
class DynamicBannersCarousel extends ConsumerStatefulWidget {
  final double height;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Duration autoScrollDuration;

  const DynamicBannersCarousel({
    super.key,
    this.height = 150,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius,
    this.autoScrollDuration = const Duration(seconds: 5),
  });

  @override
  ConsumerState<DynamicBannersCarousel> createState() =>
      _DynamicBannersCarouselState();
}

class _DynamicBannersCarouselState
    extends ConsumerState<DynamicBannersCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(widget.autoScrollDuration, () {
      if (!mounted) return;

      final banners = ref.read(appBannersConfigProvider);
      if (banners.length <= 1) return;

      final nextPage = (_currentPage + 1) % banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(appBannersConfigProvider);

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: widget.padding,
                child: _BannerItem(
                  banner: banners[index],
                  height: widget.height,
                  borderRadius: widget.borderRadius,
                ),
              );
            },
          ),
        ),
        if (banners.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
