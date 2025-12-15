import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/widgets/responsive_container.dart';
import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({
    super.key,
    required this.child,
    this.maxContentWidth,
    this.containerPadding,
    this.logoImagePath,
    this.backgroundImagePath,
    this.childPadding,
    this.girlHeight,
    this.girlRightOffset,
    this.girlBottomOffset,
  });

  final Widget child;
  final double? maxContentWidth;
  final EdgeInsetsGeometry? containerPadding;
  final EdgeInsetsGeometry? childPadding;
  final String? logoImagePath;
  final String? backgroundImagePath;
  final double? girlHeight;
  final double? girlRightOffset;
  final double? girlBottomOffset;
  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    double localGirlHeight = girlHeight ?? (isMobile ? 200 : 400);
    double localGirlRightOffset = girlRightOffset ?? (isMobile ? -40 : -150);
    double localGirlBottomOffset = girlBottomOffset ?? (isMobile ? -10 : -110);

    return Scaffold(
      backgroundColor: context.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: CommonImage(
              imageUrl: backgroundImagePath ??
                  (isMobile
                      ? AppLocalImages.onboardingBgMobile
                      : AppLocalImages.onboardingBgDesktop),
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: ResponsiveContainer(
                maxWidth: maxContentWidth ?? (isMobile ? null : 500),
                padding: containerPadding ??
                    EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 32,
                      vertical: isMobile ? 24 : 32,
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImage(
                      imageUrl:
                          logoImagePath ?? AppLocalImages.gigaFaucetTextLogo,
                      width: isMobile ? 240 : 360,
                      height: isMobile ? 40 : 52,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 28),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: childPadding ??
                              EdgeInsets.symmetric(
                                horizontal: isMobile ? 16 : 24,
                                vertical: isMobile ? 16 : 24,
                              ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF00131E).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                          child: child,
                        ),
                        if (!isMobile)
                          Positioned(
                            right: localGirlRightOffset,
                            bottom: localGirlBottomOffset,
                            child: IgnorePointer(
                              ignoring: true,
                              child: Image.asset(
                                AppLocalImages.girlWholeBody,
                                height: localGirlHeight,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
