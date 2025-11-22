import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/coins_earned_history_card.dart';
import 'package:flutter/material.dart';

class CoinsHistorySection extends StatelessWidget {
  const CoinsHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 35,
            ),
            child: CommonText.bodyLarge(
              localizations?.translate('coins_history_title') ??
                  "Last Coins Earned History. Past 7 Days",
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimary,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 10 : 28),
        CoinsEarnedHistoryCard(
          title: "Treasure Chest",
          subtitle: "Treasure Chest Reward",
          amount: 14,
          timeAgo: "5 hours ago",
        ),
        CoinsEarnedHistoryCard(
          title: "Game App",
          subtitle: "Game App Reward",
          amount: 200,
          timeAgo: "5 hours ago",
        ),
      ],
    );
  }
}
