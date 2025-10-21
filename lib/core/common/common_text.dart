import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// A common text widget with predefined styles
class CommonText extends StatelessWidget {
  const CommonText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  });

  /// Display text styles
  const CommonText.displayLarge(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.displayLarge;

  const CommonText.displayMedium(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.displayMedium;

  const CommonText.displaySmall(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.displaySmall;

  /// Headline text styles
  const CommonText.headlineLarge(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.headlineLarge;

  const CommonText.headlineMedium(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.headlineMedium;

  const CommonText.headlineSmall(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.headlineSmall;

  /// Title text styles
  const CommonText.titleLarge(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.titleLarge;

  const CommonText.titleMedium(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.titleMedium;

  const CommonText.titleSmall(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.titleSmall;

  /// Body text styles
  const CommonText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.bodyLarge;

  const CommonText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.bodyMedium;

  const CommonText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.bodySmall;

  /// Label text styles
  const CommonText.labelLarge(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.labelLarge;

  const CommonText.labelMedium(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.labelMedium;

  const CommonText.labelSmall(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.labelSmall;

  /// Special crypto display text style (Orbitron with effects)
  const CommonText.cryptoDisplay(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.cryptoDisplay;

  /// Special crypto amount text style (Orbitron for numbers)
  const CommonText.cryptoAmount(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.cryptoAmount;

  /// Button text style (Orbitron for buttons)
  const CommonText.button(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : style = _TextStyle.button;

  final String text;
  final _TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    TextStyle? baseStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (style) {
      case _TextStyle.displayLarge:
        baseStyle = isDark
            ? AppTypography.displayLargeDark
            : AppTypography.displayLarge;
        break;
      case _TextStyle.displayMedium:
        baseStyle = isDark
            ? AppTypography.displayMediumDark
            : AppTypography.displayMedium;
        break;
      case _TextStyle.displaySmall:
        baseStyle = isDark
            ? AppTypography.displaySmallDark
            : AppTypography.displaySmall;
        break;
      case _TextStyle.headlineLarge:
        baseStyle = isDark
            ? AppTypography.headlineLargeDark
            : AppTypography.headlineLarge;
        break;
      case _TextStyle.headlineMedium:
        baseStyle = isDark
            ? AppTypography.headlineMediumDark
            : AppTypography.headlineMedium;
        break;
      case _TextStyle.headlineSmall:
        baseStyle = isDark
            ? AppTypography.headlineSmallDark
            : AppTypography.headlineSmall;
        break;
      case _TextStyle.titleLarge:
        baseStyle =
            isDark ? AppTypography.titleLargeDark : AppTypography.titleLarge;
        break;
      case _TextStyle.titleMedium:
        baseStyle =
            isDark ? AppTypography.titleMediumDark : AppTypography.titleMedium;
        break;
      case _TextStyle.titleSmall:
        baseStyle =
            isDark ? AppTypography.titleSmallDark : AppTypography.titleSmall;
        break;
      case _TextStyle.bodyLarge:
        baseStyle =
            isDark ? AppTypography.bodyLargeDark : AppTypography.bodyLarge;
        break;
      case _TextStyle.bodyMedium:
        baseStyle =
            isDark ? AppTypography.bodyMediumDark : AppTypography.bodyMedium;
        break;
      case _TextStyle.bodySmall:
        baseStyle =
            isDark ? AppTypography.bodySmallDark : AppTypography.bodySmall;
        break;
      case _TextStyle.labelLarge:
        baseStyle =
            isDark ? AppTypography.labelLargeDark : AppTypography.labelLarge;
        break;
      case _TextStyle.labelMedium:
        baseStyle =
            isDark ? AppTypography.labelMediumDark : AppTypography.labelMedium;
        break;
      case _TextStyle.labelSmall:
        baseStyle =
            isDark ? AppTypography.labelSmallDark : AppTypography.labelSmall;
        break;
      case _TextStyle.cryptoDisplay:
        baseStyle = AppTypography.cryptoDisplay;
        break;
      case _TextStyle.cryptoAmount:
        baseStyle = AppTypography.cryptoAmount;
        break;
      case _TextStyle.button:
        baseStyle = AppTypography.buttonText;
        break;
      case null:
        baseStyle =
            isDark ? AppTypography.bodyMediumDark : AppTypography.bodyMedium;
        break;
    }

    final effectiveStyle = baseStyle.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
    );

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

enum _TextStyle {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  cryptoDisplay,
  cryptoAmount,
  button,
}