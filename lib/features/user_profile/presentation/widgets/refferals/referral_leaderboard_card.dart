import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ReferralLeaderboardCard extends StatelessWidget {
  const ReferralLeaderboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    final leaderboard = [
      {'rank': 1, 'id': 'PqgZw', 'entries': '366'},
      {'rank': 2, 'id': 'NkprN', 'entries': '334'},
      {'rank': 3, 'id': 'xkM0pq', 'entries': '2'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.titleMedium(
            localizations?.translate('referrals_leaderboard_title') ??
                'Referral Contest Leaderboard',
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          CommonText.bodySmall(
            'The leaderboard is updated every 15 minutes.',
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: leaderboard.map((e) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText.bodySmall('${e['rank']}',
                          color: colorScheme.onSurfaceVariant),
                      CommonText.bodySmall('${e['id']}',
                          color: colorScheme.onSurface),
                      CommonText.bodySmall('${e['entries']}',
                          color: colorScheme.onSurfaceVariant),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: CommonText.bodyMedium(
              localizations?.translate('referrals_guide') ??
                  'Read Our Referral Guide',
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
