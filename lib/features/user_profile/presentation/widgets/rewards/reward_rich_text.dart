import 'package:cointiply_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class RewardRichText extends StatelessWidget {
  final String boldNumber; // "1"
  final String label; // "Free Daily", "Free Per\nWeek"

  const RewardRichText({
    super.key,
    required this.boldNumber,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final baseStyle = Theme.of(context).brightness == Brightness.dark
        ? AppTypography.bodyMediumDark
        : AppTypography.bodyMedium;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "$boldNumber ",
            style: baseStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF00A0DC), // TODO: to use from color scheme
            ),
          ),
          TextSpan(
            text: label,
            style: baseStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
