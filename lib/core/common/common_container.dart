import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A common container widget with website-inspired styling
class CommonContainer extends StatelessWidget {
  const CommonContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.gradient,
    this.boxShadow,
    this.alignment,
    this.onTap,
    this.showBorder = false,
    this.showShadow = false,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppColors.websiteCard : colorScheme.onError);
    final effectiveBorderRadius = borderRadius ?? 12.0;
    final effectiveBorderColor = borderColor ??
        (isDark
            ? colorScheme.outline
            : AppColors.websiteBorder.withValues(alpha: 0.2));
    final effectiveBorderWidth = borderWidth ?? 1.0;

    final effectiveBoxShadow = boxShadow ??
        (showShadow
            ? [
                BoxShadow(
                  color: isDark
                      ? colorScheme.scrim.withValues(alpha: 0.3)
                      : colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: isDark ? 8 : 4,
                  offset: Offset(0, isDark ? 4 : 2),
                ),
              ]
            : null);

    Widget containerWidget = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: gradient == null ? effectiveBackgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: showBorder
            ? Border.all(
                color: effectiveBorderColor,
                width: effectiveBorderWidth,
              )
            : null,
        boxShadow: effectiveBoxShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          splashColor: (colorScheme.primary).withValues(alpha: 0.1),
          highlightColor: (colorScheme.primary).withValues(alpha: 0.05),
          child: containerWidget,
        ),
      );
    }

    return containerWidget;
  }
}

/// A specialized container for crypto/reward information
class CryptoContainer extends StatelessWidget {
  const CryptoContainer({
    super.key,
    required this.child,
    this.accentColor,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final Color? accentColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveAccentColor = accentColor ?? (colorScheme.primary);

    return CommonContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      onTap: onTap,
      showBorder: true,
      showShadow: true,
      borderColor: effectiveAccentColor.withValues(alpha: 0.3),
      borderWidth: 2,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          effectiveAccentColor.withValues(alpha: 0.1),
          effectiveAccentColor.withValues(alpha: 0.05),
        ],
      ),
      child: child,
    );
  }
}

/// A specialized container for website-style gradients
class GradientContainer extends StatelessWidget {
  const GradientContainer({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColors = colors ??
        [
          AppColors.websiteBackgroundStart,
          AppColors.websiteBackgroundEnd,
        ];

    return CommonContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      gradient: LinearGradient(
        begin: begin,
        end: end,
        colors: effectiveColors,
      ),
      child: child,
    );
  }
}

/// A specialized container for loading states
class LoadingContainer extends StatelessWidget {
  const LoadingContainer({
    super.key,
    this.message = 'Loading...',
    this.size = 50.0,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  final String message;
  final double size;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return CommonContainer(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      margin: margin,
      showShadow: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Barlow',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? colorScheme.onPrimaryContainer
                  : AppColors.websiteBackground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A specialized container for error states
class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText = 'Retry',
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryText;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return CommonContainer(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      margin: margin,
      showBorder: true,
      showShadow: true,
      borderColor: colorScheme.error.withValues(alpha: 0.3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ??
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Barlow',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? colorScheme.onPrimaryContainer
                  : AppColors.websiteBackground,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onError,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                retryText,
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
