import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

import 'referral_link_box.dart';
import 'referral_stat_card.dart';
import 'referral_leaderboard_card.dart';
import 'referral_details_card.dart';

class ManageReferralsSection extends StatelessWidget {
  const ManageReferralsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final isMobile = context.isMobile;

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText.titleLarge(
                  localizations?.translate('referrals_manage_title') ??
                      'Manage Referrals',
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: CommonText.bodyMedium(
                    localizations?.translate('view_details') ?? 'View Details',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ─── Description ────────────────────────────
            CommonText.bodyMedium(
              localizations?.translate('referrals_manage_desc') ??
                  'Share Cointiply with your friends & family to earn up to 25% on each referral.',
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            CommonText.bodySmall(
              localizations?.translate('referrals_manage_help') ??
                  'If you have any questions, please visit our Help Page.',
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 24),

            // ─── Referral Link Box ───────────────────────
            const ReferralLinkBox(),
            const SizedBox(height: 24),

            // ─── Stats Cards ─────────────────────────────
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: const [
                ReferralStatCard(label: 'Referred Users', value: '0'),
                ReferralStatCard(label: 'Active This Week', value: '0'),
                ReferralStatCard(label: 'Referral Earnings', value: '0 Coins'),
                ReferralStatCard(label: 'Pending Earnings', value: '0 Coins'),
              ],
            ),

            const SizedBox(height: 16),
            CommonText.bodySmall(
              'Pending referral earnings are automatically credited to your account at the end of each day (UTC time).',
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            CommonText.bodySmall(
              '* The referral earnings total is only for the past 6 months.',
              color: colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 32),

            // ─── Contest Section ─────────────────────────
            isMobile
                ? const Column(
                    children: [
                      ReferralLeaderboardCard(),
                      SizedBox(height: 16),
                      ReferralDetailsCard(),
                    ],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ReferralLeaderboardCard()),
                      SizedBox(width: 16),
                      Expanded(child: ReferralDetailsCard()),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
