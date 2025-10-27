import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// A common button widget with consistent styling
class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isOutlined = false,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.fontSize,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final bool isOutlined;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? theme.colorScheme.onPrimary;
    final effectiveBorderRadius = borderRadius ?? 12.0;
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    Widget child = Text(
      text,
      style: AppTypography.buttonText.copyWith(
        color: isOutlined ? effectiveBackgroundColor : effectiveTextColor,
        fontSize: fontSize,
      ),
    );

    if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            isOutlined ? effectiveBackgroundColor : effectiveTextColor,
          ),
        ),
      );
    }

    if (isOutlined) {
      return SizedBox(
        height: height,
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: effectiveBackgroundColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            padding: effectivePadding,
            backgroundColor: Colors.transparent,
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: effectivePadding,
          elevation: isLoading ? 0 : 3,
          shadowColor: effectiveBackgroundColor.withOpacity(0.3),
        ),
        child: child,
      ),
    );
  }
}
