import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/widgets/responsive_container.dart';
import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({
    super.key,
    required this.child,
    this.maxContentWidth,
    this.horizontalPadding,
    this.logoImagePath,
    this.backgroundImagePath,
  });

  final Widget child;
  final double? maxContentWidth;
  final EdgeInsetsGeometry? horizontalPadding;
  final String? logoImagePath;
  final String? backgroundImagePath;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    double girlHeight = isMobile ? 200 : 360;
    double girlRightOffset = isMobile ? -40 : -180;
    double girlBottomOffset = isMobile ? -10 : -40;

    return Scaffold(
      backgroundColor: context.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundImagePath ??
                  'assets/images/bg/onboarding_background.png',
              fit: context.isMobile ? BoxFit.cover : BoxFit.fill,
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: ResponsiveContainer(
                maxWidth: maxContentWidth ?? (isMobile ? null : 500),
                padding: horizontalPadding ??
                    EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 32,
                      vertical: isMobile ? 24 : 32,
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImage(
                      imageUrl: logoImagePath ??
                          "assets/images/giga_faucet_text_logo.png",
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
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 40,
                            vertical: isMobile ? 24 : 34,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF00131E).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: context.outline.withAlpha(20),
                            ),
                          ),
                          child: child,
                        ),
                        if (!isMobile)
                          Positioned(
                            right: girlRightOffset,
                            bottom: girlBottomOffset,
                            child: IgnorePointer(
                              ignoring: true,
                              child: Image.asset(
                                "assets/images/girl.png",
                                height: girlHeight,
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
