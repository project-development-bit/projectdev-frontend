import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ReferralBulletList extends StatelessWidget {
  const ReferralBulletList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = [
      'You will earn 25% of every referral’s faucet claims for life.',
      'You will also earn 10% of any of your referral’s offer wall earnings.',
      'There is no limit to the number of referrals you can send.',
      'Referrals on the same device or in the same household are not allowed and will not be counted as referrals.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((text) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 6, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonText.bodySmall(
                        text,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
