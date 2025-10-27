import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// A responsive container widget that limits content width similar to Bootstrap containers
/// Provides different max widths based on screen size breakpoints
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final double? maxWidth;
  final bool fullWidthOnMobile;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.decoration,
    this.maxWidth,
    this.fullWidthOnMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    // Bootstrap-like breakpoints and max widths
    double containerMaxWidth;

    if (maxWidth != null) {
      containerMaxWidth = maxWidth!;
    } else if (context.isMobile && fullWidthOnMobile) {
      // Mobile: Full width with padding
      return Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        color: color,
        decoration: decoration,
        child: child,
      );
    } else if (context.isMobile) {
      containerMaxWidth = context.screenWidth - 32; // Mobile with margins
    } else if (context.isTablet) {
      containerMaxWidth = 768; // Tablet max width
    } else if (context.screenWidth <= 1200) {
      containerMaxWidth = 1140; // Desktop small
    } else if (context.screenWidth <= 1400) {
      containerMaxWidth = 1320; // Desktop medium
    } else {
      containerMaxWidth = 1400; // Desktop large
    }

    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: containerMaxWidth,
        ),
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: context.isMobile ? 16 : 32,
            ),
        color: color,
        decoration: decoration,
        child: child,
      ),
    );
  }
}

/// A section wrapper that provides consistent spacing and responsive container
class ResponsiveSection extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final bool fullWidthOnMobile;

  const ResponsiveSection({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.maxWidth,
    this.fullWidthOnMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      child: ResponsiveContainer(
        maxWidth: maxWidth,
        fullWidthOnMobile: fullWidthOnMobile,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 40),
        child: child,
      ),
    );
  }
}
