import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

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

    switch (style) {
      case _TextStyle.displayLarge:
        baseStyle = context.displayLarge;
        break;
      case _TextStyle.displayMedium:
        baseStyle = context.displayMedium;
        break;
      case _TextStyle.displaySmall:
        baseStyle = context.displaySmall;
        break;
      case _TextStyle.headlineLarge:
        baseStyle = context.headlineLarge;
        break;
      case _TextStyle.headlineMedium:
        baseStyle = context.headlineMedium;
        break;
      case _TextStyle.headlineSmall:
        baseStyle = context.headlineSmall;
        break;
      case _TextStyle.titleLarge:
        baseStyle = context.titleLarge;
        break;
      case _TextStyle.titleMedium:
        baseStyle = context.titleMedium;
        break;
      case _TextStyle.titleSmall:
        baseStyle = context.titleSmall;
        break;
      case _TextStyle.bodyLarge:
        baseStyle = context.bodyLarge;
        break;
      case _TextStyle.bodyMedium:
        baseStyle = context.bodyMedium;
        break;
      case _TextStyle.bodySmall:
        baseStyle = context.bodySmall;
        break;
      case _TextStyle.labelLarge:
        baseStyle = context.labelLarge;
        break;
      case _TextStyle.labelMedium:
        baseStyle = context.labelMedium;
        break;
      case _TextStyle.labelSmall:
        baseStyle = context.labelSmall;
        break;
      case null:
        baseStyle = context.bodyMedium;
        break;
    }

    final effectiveStyle = baseStyle?.copyWith(
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
}