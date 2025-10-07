import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/common_button.dart';
import '../providers/home_providers.dart';

/// Hero section widget displaying the main value proposition
class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastPayout = ref.watch(lastPayoutProvider);
    final totalUsers = ref.watch(platformStatsProvider).totalUsers;
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primary,
            context.primary.withOpacity(0.8),
            context.secondary,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.isMobile ? 16 : 32,
          vertical: context.isMobile ? 40 : 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main heading
            CommonText.headlineLarge(
              'Turn your free time into free Bitcoin',
              textAlign: TextAlign.center,
              color: context.onPrimary,
            ),
            const SizedBox(height: 24),
            
            // Subheading with earning potential
            CommonText.headlineSmall(
              'Earn up to \$596 USD per offer',
              textAlign: TextAlign.center,
              color: context.onPrimary.withOpacity(0.9),
            ),
            const SizedBox(height: 32),
            
            // Call to action button
            CommonButton(
              text: isLoggedIn ? 'Continue Earning' : 'Start Earning Now',
              onPressed: () {
                // TODO: Navigate to offers or login
              },
              backgroundColor: context.onPrimary,
              textColor: context.primary,
              fontSize: 18,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            const SizedBox(height: 24),
            
            // Last payout info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.onPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.onPrimary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: context.onPrimary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  CommonText.bodySmall(
                    'Last payout: \$${lastPayout['amount']} — ${lastPayout['timeAgo']}',
                    color: context.onPrimary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Trust indicators
            Column(
              children: [
                CommonText.bodyMedium(
                  'Trusted by over ${_formatNumber(totalUsers)} users worldwide.',
                  textAlign: TextAlign.center,
                  color: context.onPrimary.withOpacity(0.9),
                ),
                const SizedBox(height: 8),
                CommonText.bodyMedium(
                  'Paying out free crypto since 2018.',
                  textAlign: TextAlign.center,
                  color: context.onPrimary.withOpacity(0.9),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // App store badges (placeholder)
            if (context.isMobile) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AppStoreBadge(
                    text: 'Get it on\nGoogle Play',
                    onTap: () {
                      // TODO: Open Google Play Store
                    },
                  ),
                  const SizedBox(width: 16),
                  _AppStoreBadge(
                    text: 'Download on\nApp Store',
                    onTap: () {
                      // TODO: Open App Store
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Rating info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: List.generate(5, (index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    )),
                  ),
                  const SizedBox(width: 8),
                  CommonText.bodySmall(
                    'Rated 4.6 out of 5',
                    color: context.onPrimary.withOpacity(0.9),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CommonText.bodySmall(
                'Over 35,000 reviews.',
                color: context.onPrimary.withOpacity(0.9),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _AppStoreBadge extends StatelessWidget {
  const _AppStoreBadge({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: CommonText.bodySmall(
          text,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}