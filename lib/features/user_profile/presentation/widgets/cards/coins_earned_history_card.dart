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
          color: colorScheme.primaryContainer,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Left text section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.titleMedium(
                title,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(height: 4),
              CommonText.bodySmall(
                subtitle,
                color: colorScheme.onSecondary,
              ),
            ],
          ),

          const Spacer(),

          // Coin amount pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.scrim,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                CommonText.titleMedium(
                  amount.toString(),
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(width: 6),
                Image.asset(
                  "assets/images/rewards/coin.png",
                  width: 22,
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Time ago
          CommonText.bodyMedium(
            timeAgo,
            color: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
