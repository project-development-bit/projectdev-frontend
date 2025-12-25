import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class CommonRichTextWithIcon extends StatelessWidget {
  final String prefixText;
  final String boldNumber;
  final String suffixText;
  final String iconPath;
  final double iconSize;

  const CommonRichTextWithIcon({
    super.key,
    required this.prefixText,
    required this.boldNumber,
    required this.suffixText,
    required this.iconPath,
    this.iconSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = (Theme.of(context).brightness == Brightness.dark
            ? AppTypography.bodyMediumDark
            : AppTypography.bodyMedium)
        .copyWith(
      fontSize: 14,
      color: Color(0xFF98989A), // TODO color from theme
    );

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: prefixText),
          TextSpan(
            text: boldNumber,
            style: baseStyle.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: context.primary),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Image.asset(iconPath, width: iconSize),
          ),
          TextSpan(text: suffixText),
        ],
      ),
    );
  }
}
