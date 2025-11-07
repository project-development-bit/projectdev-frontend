import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/refferals/referral_banner_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/refferals/referral_bullet_list.dart';
import 'package:flutter/material.dart';

class ReferralGetStartedSection extends StatelessWidget {
  const ReferralGetStartedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText.titleMedium(
              localizations?.translate('referral_get_started_title') ??
                  'Get Started',
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 6),
            CommonText.bodySmall(
              localizations?.translate('referral_get_started_desc') ??
                  'Simply refer users to Cointiply using your custom referral link. '
                      'They will be automatically tracked and attributed to you if they sign up within 30 days.',
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            const ReferralBulletList(),
            const SizedBox(height: 12),
            CommonText.bodySmall(
              localizations?.translate('referral_get_started_warning') ??
                  'IMPORTANT: Invalid, fake or duplicate referrals will not be counted. '
                      'Your account may be terminated and all Coins forfeited if you are found to be sending invalid referrals. '
                      'We have automated measures to detect and prevent invalid referrals. You’ve been warned.',
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 24),
            ReferralBannerSection(),
          ],
        ),
      ),
    );
  }
}
