import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/coins_earned_history_card.dart';
import 'package:flutter/material.dart';

class CoinsHistorySection extends StatelessWidget {
  const CoinsHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CommonText.titleMedium(
            localizations?.translate('coins_history_title') ??
                "Last Coins Earned History. Past 7 Days",
            fontWeight: FontWeight.w500,
            color: Color(0xFF98989A), // TODO use from colorScheme
          ),
        ),
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
