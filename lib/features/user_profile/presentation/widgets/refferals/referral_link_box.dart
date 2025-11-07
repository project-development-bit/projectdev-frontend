import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ← for Clipboard

class ReferralLinkBox extends StatelessWidget {
  const ReferralLinkBox({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    const referralLink = 'https://cointiply.com/r/wkxnY1';

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
            localizations?.translate('referrals_link_title') ??
                'Your Referral Link',
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          CommonText.bodySmall(
            localizations?.translate('referrals_link_desc') ??
                'Share your link on social media, blogs, or PTC websites etc. Any users that sign up through your link will earn you cash!',
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: CommonText.bodyMedium(
                    referralLink,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await Clipboard.setData(
                      const ClipboardData(text: referralLink));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CommonText.bodySmall(
                          localizations?.translate('copied_link_message') ??
                              'Referral link copied to clipboard!',
                          color: colorScheme.onPrimary,
                        ),
                        backgroundColor: colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: CommonText.bodyMedium(
                  localizations?.translate('btn_copy_link') ?? 'Copy Link',
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
