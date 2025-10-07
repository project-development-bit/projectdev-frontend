import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

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
    final effectiveBackgroundColor = backgroundColor ?? context.primary;
    final effectiveTextColor = textColor ?? context.onPrimary;
    final effectiveBorderRadius = borderRadius ?? 8.0;
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    Widget child = Text(
      text,
      style: context.bodyMedium?.copyWith(
        color: isOutlined ? effectiveBackgroundColor : effectiveTextColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
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
          elevation: isLoading ? 0 : 2,
        ),
        child: child,
      ),
    );
  }
}
