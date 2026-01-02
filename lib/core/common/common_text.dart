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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.displayLarge; // Display large text style (57px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.displayMedium; // Display medium text style (45px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.displaySmall; // Display small text style (36px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.headlineLarge; // Headline large text style (32px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style =
            TextStyleEnum.headlineMedium; // Headline medium text style (28px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.headlineSmall; // Headline small text style (24px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.titleLarge; // Title large text style (22px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.titleMedium; // Title medium text style (16px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.titleSmall; // Title small text style (14px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.bodyLarge; // Body large text style (16px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.bodyMedium; // Body medium text style (14px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.bodySmall; // Body small text style (12px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.labelLarge; // Label large text style (14px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.labelMedium; // Label medium text style (12px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.labelSmall; // Label small text style (10px)

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.cryptoDisplay; // Crypto display text style

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.cryptoAmount; // Crypto amount text style

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
    this.highlightColor,
    this.highlightFontSize,
    this.highlightFontWeight,
  }) : style = TextStyleEnum.button; // Button text style

  final String text;
  final TextStyleEnum? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final Color? highlightColor;
  final double? highlightFontSize;
  final FontWeight? highlightFontWeight;

  @override
  Widget build(BuildContext context) {
    TextStyle? baseStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (style) {
      case TextStyleEnum.displayLarge:
        baseStyle = isDark
            ? AppTypography.displayLargeDark
            : AppTypography.displayLarge;
        break;
      case TextStyleEnum.displayMedium:
        baseStyle = isDark
            ? AppTypography.displayMediumDark
            : AppTypography.displayMedium;
        break;
      case TextStyleEnum.displaySmall:
        baseStyle = isDark
            ? AppTypography.displaySmallDark
            : AppTypography.displaySmall;
        break;
      case TextStyleEnum.headlineLarge:
        baseStyle = isDark
            ? AppTypography.headlineLargeDark
            : AppTypography.headlineLarge;
        break;
      case TextStyleEnum.headlineMedium:
        baseStyle = isDark
            ? AppTypography.headlineMediumDark
            : AppTypography.headlineMedium;
        break;
      case TextStyleEnum.headlineSmall:
        baseStyle = isDark
            ? AppTypography.headlineSmallDark
            : AppTypography.headlineSmall;
        break;
      case TextStyleEnum.titleLarge:
        baseStyle =
            isDark ? AppTypography.titleLargeDark : AppTypography.titleLarge;
        break;
      case TextStyleEnum.titleMedium:
        baseStyle =
            isDark ? AppTypography.titleMediumDark : AppTypography.titleMedium;
        break;
      case TextStyleEnum.titleSmall:
        baseStyle =
            isDark ? AppTypography.titleSmallDark : AppTypography.titleSmall;
        break;
      case TextStyleEnum.bodyLarge:
        baseStyle =
            isDark ? AppTypography.bodyLargeDark : AppTypography.bodyLarge;
        break;
      case TextStyleEnum.bodyMedium:
        baseStyle =
            isDark ? AppTypography.bodyMediumDark : AppTypography.bodyMedium;
        break;
      case TextStyleEnum.bodySmall:
        baseStyle =
            isDark ? AppTypography.bodySmallDark : AppTypography.bodySmall;
        break;
      case TextStyleEnum.labelLarge:
        baseStyle =
            isDark ? AppTypography.labelLargeDark : AppTypography.labelLarge;
        break;
      case TextStyleEnum.labelMedium:
        baseStyle =
            isDark ? AppTypography.labelMediumDark : AppTypography.labelMedium;
        break;
      case TextStyleEnum.labelSmall:
        baseStyle =
            isDark ? AppTypography.labelSmallDark : AppTypography.labelSmall;
        break;
      case TextStyleEnum.cryptoDisplay:
        baseStyle = AppTypography.cryptoDisplay;
        break;
      case TextStyleEnum.cryptoAmount:
        baseStyle = AppTypography.cryptoAmount;
        break;
      case TextStyleEnum.button:
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

    // Check if text contains brackets for highlighting
    if (text.contains('[') && text.contains(']')) {
      return _buildRichText(context, effectiveStyle);
    }

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Build rich text with highlighted brackets content
  Widget _buildRichText(BuildContext context, TextStyle effectiveStyle) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final spans = <TextSpan>[];

    // Regex to match text in brackets: [text]
    final regex = RegExp(r'\[([^\]]+)\]');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the bracket
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: effectiveStyle,
        ));
      }

      // Add highlighted text (content inside brackets)
      spans.add(TextSpan(
        text: match.group(1), // Text without brackets
        style: effectiveStyle.copyWith(
            color: highlightColor ?? primaryColor,
            fontSize: highlightFontSize,
            fontWeight: highlightFontWeight),
      ));

      lastIndex = match.end;
    }

    // Add remaining text after last match
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: effectiveStyle,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

enum TextStyleEnum {
  displayLarge, // Display large text style (57px)
  displayMedium, // Display medium text style (45px)
  displaySmall, // Display small text style (36px)
  headlineLarge, // Headline large text style (32px)
  headlineMedium, // Headline medium text style (28px)
  headlineSmall, // Headline small text style (24px)
  titleLarge, // Title large text style (22px)
  titleMedium, // Title medium text style (16px)
  titleSmall, // Title small text style (14px)
  bodyLarge, // Body large text style (16px)
  bodyMedium, // Body medium text style (14px)
  bodySmall, // Body small text style (12px)
  labelLarge, // Label large text style (14px)
  labelMedium, // Label medium text style (12px)
  labelSmall, // Label small text style (10px)
  cryptoDisplay, // Crypto display text style
  cryptoAmount, // Crypto amount text style
  button, // Button text style

}
