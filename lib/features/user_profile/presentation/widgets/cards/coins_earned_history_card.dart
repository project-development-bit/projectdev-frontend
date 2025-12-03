import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/int_extensions.dart';
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff333333)), // TODO: Use from scheme
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

  Widget _buildMobileLayout(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.bodyLarge(
          title,
          maxLines: 3,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        CommonText.bodyMedium(
          subtitle,
          fontWeight: FontWeight.w500,
          color: Color(0xFF98989A),

          /// TODO: Use from scheme,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 10),
        _buildAmountPill(colorScheme, isMobile: true),
        const SizedBox(height: 4),
        CommonText.bodyMedium(
          timeAgo,
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
          overflow: TextOverflow.ellipsis,
        ),
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
                color: Color(0xFF98989A),

                /// TODO: Use from scheme
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
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
      width: 200,
      height: 40,
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
            amount.currencyFormat().toString(),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
          const SizedBox(width: 6),
          Image.asset(
            "assets/images/rewards/coin.png",
            width: 24,
          ),
        ],
      ),
    );
  }
}
