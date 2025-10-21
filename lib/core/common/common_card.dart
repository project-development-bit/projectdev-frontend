import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A common card widget with website-inspired styling
class CommonCard extends StatelessWidget {
  const CommonCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.showShadow = true,
    this.gradient,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final bool showShadow;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final effectiveBackgroundColor = backgroundColor ?? 
        (isDark ? AppColors.websiteCard : Colors.white);
    final effectiveBorderRadius = borderRadius ?? 16.0;
    final effectivePadding = padding ?? const EdgeInsets.all(20);
    final effectiveMargin = margin ?? const EdgeInsets.all(8);
    final effectiveBorderColor = borderColor ?? 
        (isDark ? AppColors.websiteBorder.withOpacity(0.3) : Colors.transparent);
    final effectiveBorderWidth = borderWidth ?? (isDark ? 1.0 : 0.0);

    Widget cardContent = Container(
      margin: effectiveMargin,
      decoration: BoxDecoration(
        color: gradient == null ? effectiveBackgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
        boxShadow: showShadow ? [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.1),
            blurRadius: isDark ? 8 : 4,
            offset: Offset(0, isDark ? 4 : 2),
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || subtitle != null)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: isDark 
                            ? AppTypography.titleLargeDark
                            : AppTypography.titleLarge,
                      ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: isDark 
                            ? AppTypography.bodyMediumDark
                            : AppTypography.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            Padding(
              padding: effectivePadding,
              child: child,
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          splashColor: (isDark ? AppColors.primaryLight : AppColors.primary)
              .withOpacity(0.1),
          highlightColor: (isDark ? AppColors.primaryLight : AppColors.primary)
              .withOpacity(0.05),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// A specialized card for crypto/reward information
class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    this.icon,
    this.subtitle,
    this.onTap,
    this.backgroundColor,
    this.accentColor,
  });

  final String title;
  final String amount;
  final String currency;
  final Widget? icon;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveAccentColor = accentColor ?? 
        (isDark ? AppColors.primaryLight : AppColors.primary);

    return CommonCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: effectiveAccentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: effectiveAccentColor,
                  width: 2,
                ),
              ),
              child: Center(child: icon!),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isDark 
                      ? AppTypography.titleMediumDark
                      : AppTypography.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: isDark 
                        ? AppTypography.bodySmallDark
                        : AppTypography.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTypography.cryptoAmount.copyWith(
                  color: effectiveAccentColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currency,
                style: AppTypography.captionText.copyWith(
                  color: effectiveAccentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A specialized card for website-style gradients
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.title,
    this.colors,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final String? title;
  final List<Color>? colors;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColors = colors ?? [
      AppColors.websiteBackgroundStart,
      AppColors.websiteBackgroundEnd,
    ];

    return CommonCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: effectiveColors,
      ),
      title: title,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
}