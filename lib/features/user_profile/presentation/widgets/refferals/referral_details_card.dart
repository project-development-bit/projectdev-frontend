import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ReferralDetailsCard extends StatelessWidget {
  const ReferralDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

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
            localizations?.translate('referrals_details_title') ??
                'Referral Contest Details',
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          CommonText.bodySmall(
            'Referral contest runs each month and is paid at the end of each month. Earn entries for each referred user.',
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          CommonText.bodyMedium(
            'Prizes:',
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          CommonText.bodySmall(
            '1 Prize of \$100 | 5 Prizes of \$40 | 10 Prizes of \$20',
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          CommonText.bodySmall(
            'Your Entries: No Entries Yet',
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          CommonText.bodySmall(
            'Your Rank: No Rank Yet',
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
