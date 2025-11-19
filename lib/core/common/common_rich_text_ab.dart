import 'package:flutter/material.dart';
import 'package:cointiply_app/core/theme/app_typography.dart';

class CommonRichTextAB extends StatelessWidget {
  final String primary; // number part
  final String secondary; // label part
  final Color primaryColor;
  final Color secondaryColor;
  final TextStyle? textStyle;

  const CommonRichTextAB({
    super.key,
    required this.primary,
    required this.secondary,
    required this.primaryColor,
    required this.secondaryColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = textStyle ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppTypography.titleMediumDark
            : AppTypography.titleMedium);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: primary,
            style: baseStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
          TextSpan(
            text: secondary,
            style: baseStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
