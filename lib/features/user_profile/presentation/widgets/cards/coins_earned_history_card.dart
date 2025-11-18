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
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF333333), // TODO use from colorScheme
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

  // ======================
  // MOBILE LAYOUT
  // ======================
  Widget _buildMobileLayout(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: text + amount pill
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  CommonText.bodyLarge(
                    subtitle,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildAmountPill(colorScheme),
          ],
        ),

        const SizedBox(height: 10),

        // Time ago (below everything)
        CommonText.bodyLarge(
          timeAgo,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ======================
  //  DESKTOP / TABLET
  // ======================
  Widget _buildDesktopLayout(ColorScheme colorScheme) {
    return Row(
      children: [
        // Left text section
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
              CommonText.bodyLarge(
                subtitle,
                fontWeight: FontWeight.w500,
                color: colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Coin amount pill
        _buildAmountPill(colorScheme),

        const SizedBox(width: 16),

        // Time ago
        CommonText.bodyLarge(
          timeAgo,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAmountPill(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.scrim,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText.titleMedium(
            amount.toString(),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
          const SizedBox(width: 6),
          Image.asset(
            "assets/images/rewards/coin.png",
            width: 22,
          ),
        ],
      ),
    );
  }
}
