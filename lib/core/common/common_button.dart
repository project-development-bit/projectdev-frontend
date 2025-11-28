import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

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
        padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 10);
    final effectiveHeight = height ?? 44.0;

    Widget child = CommonText.titleSmall(
      text,
      color: isOutlined ? effectiveBackgroundColor : effectiveTextColor,
      fontSize: fontSize,
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
        height: effectiveHeight,
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: effectiveBackgroundColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            padding: effectivePadding,
            backgroundColor: AppColors.transparent,
          ),
          child: child,
        ),
      );
    }

    // Wrap ElevatedButton with Container for bottom border
    return Container(
      height: effectiveHeight,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: effectiveBackgroundColor.withValues(
                alpha: 0.5), // Adjust color as needed
            width: 3.0, // Adjust width as needed
          ),
        ),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
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
          shadowColor: effectiveBackgroundColor.withValues(alpha: 0.3),
        ),
        child: child,
      ),
    );
  }
}
