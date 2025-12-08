import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class TransactionFilterButton extends StatelessWidget {
  final String title;
  const TransactionFilterButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 10.5, horizontal: isMobile ? 6 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFF333333)), //TODO: use from color scheme
      ),
      child: Row(
        children: [
          isMobile
              ? CommonText.bodySmall(
                  title,
                  color: const Color(0xFF98989A), //TODO: use from color scheme
                )
              : CommonText.bodyMedium(
                  title,
                  color: const Color(0xFF98989A), //TODO: use from color scheme
                ),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFF98989A),
              size: isMobile ? 16 : 18), //TODO: use from color scheme
        ],
      ),
    );
  }
}
