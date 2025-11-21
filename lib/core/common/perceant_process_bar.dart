import 'package:flutter/material.dart';

class PerceantProcessBar extends StatelessWidget {
  final double percent; // 0.0 → 1.0
  final double height;
  final double borderRadius;
  final Color startColor;
  final Color backgroundColor;
  final Color borderColor;

  const PerceantProcessBar({
    super.key,
    required this.percent,
    this.height = 15,
    this.borderRadius = 12,
    required this.startColor,
    required this.backgroundColor,
    required this.borderColor,
  });
  @override
  Widget build(BuildContext context) {
    final clampedPercent = percent.clamp(0.0, 1.0); // prevent overflow

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            // Filled part
            Expanded(
              flex: (clampedPercent * 100).round(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: borderColor, width: 3),
                  ),
                  color: startColor,
                ),
              ),
            ),

            // Remaining part
            Expanded(
              flex: (100 - clampedPercent * 100).round(),
              child: Container(
                color: backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
