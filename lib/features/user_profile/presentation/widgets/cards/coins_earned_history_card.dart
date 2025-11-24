import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';

class CoinsEarnedHistoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int amount;
  final String timeAgo;

  const CoinsEarnedHistoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
      margin: const EdgeInsets.symmetric(vertical: 6.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1.2,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 420;

          return isMobile
              ? _buildMobileLayout(colorScheme)
              : _buildDesktopLayout(colorScheme);
        },
      ),
    );
  }

  // MOBILE LAYOUT
  Widget _buildMobileLayout(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText.bodyLarge(
                title,
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              CommonText.bodyLarge(
                subtitle,
                fontWeight: FontWeight.w500,
                color: colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // PASS isMobile: true
            _buildAmountPill(colorScheme, isMobile: true),
            const SizedBox(height: 4),
            CommonText.bodyLarge(
              timeAgo,
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )
      ],
    );
  }

  // DESKTOP LAYOUT
  Widget _buildDesktopLayout(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.bodyLarge(
                title,
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              CommonText.bodyMedium(
                subtitle,
                fontWeight: FontWeight.w500,
                color: colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // PASS isMobile: false (Default)
        _buildAmountPill(colorScheme, isMobile: false),
        const SizedBox(width: 16),
        CommonText.bodyLarge(
          timeAgo,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAmountPill(ColorScheme colorScheme, {required bool isMobile}) {
    return Container(
      width: isMobile ? null : 200,
      height: isMobile ? 30 : 40,
      alignment: Alignment.center,
      padding: isMobile ? const EdgeInsets.symmetric(horizontal: 12) : null,
      decoration: BoxDecoration(
        color: colorScheme.scrim,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText.titleMedium(
            amount.toString(),
            fontSize: isMobile ? 14 : 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
          const SizedBox(width: 6),
          Image.asset(
            "assets/images/rewards/coin.png",
            width: isMobile ? 16 : 22,
          ),
        ],
      ),
    );
  }
}
