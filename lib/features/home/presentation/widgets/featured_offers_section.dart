import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../providers/home_providers.dart';
import 'offer_card.dart';

/// Section displaying featured offers
class FeaturedOffersSection extends ConsumerWidget {
  const FeaturedOffersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(featuredOffersProvider);
    final totalOffers = ref.watch(totalOffersProvider);
    final highestPayout = ref.watch(highestPayoutProvider);

    return ResponsiveSection(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: context.isMobile
                      ? CrossAxisAlignment.stretch
                      : CrossAxisAlignment.center,
                  children: [
                    CommonText.headlineMedium(
                      context.translate('featured_offers'),
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    CommonText.bodyMedium(
                      context.translate('handpicked_tasks'),
                      overflow: TextOverflow.ellipsis,
                      color: context.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              if (!context.isMobile) const Spacer(),
              if (!context.isMobile)
                CommonButton(
                  text: context.translate('view_all_offers'),
                  onPressed: () {
                    // TODO: Navigate to all offers
                  },
                  isOutlined: true,
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.primaryContainer.withAlpha(77), // 0.3 * 255
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.primary.withAlpha(51), // 0.2 * 255
              ),
            ),
            child: Row(
              children: [
                _StatItem(
                  title: context.translate('available_offers'),
                  value: _formatNumber(totalOffers),
                  icon: Icons.local_offer,
                ),
                if (!context.isMobile) ...[
                  const SizedBox(width: 32),
                  _StatItem(
                    title: context.translate('highest_payout'),
                    value: '\$${highestPayout.toStringAsFixed(0)}',
                    icon: Icons.trending_up,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Offers grid/list
          if (context.isMobile)
            // Mobile: Vertical list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: offers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final offer = offers[index];
                return OfferCard(
                  offer: offer,
                  onTap: () {
                    // TODO: Navigate to offer details
                  },
                );
              },
            )
          else
            // Desktop/Tablet: Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.isTablet ? 2 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 16 / 12,
              ),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return OfferCard(
                  offer: offer,
                  onTap: () {
                    // TODO: Navigate to offer details
                  },
                );
              },
            ),

          const SizedBox(height: 32),

          // Mobile "View All" button
          if (context.isMobile)
            Center(
              child: CommonButton(
                text: 'View All Offers',
                onPressed: () {
                  // TODO: Navigate to all offers
                },
                isOutlined: true,
                width: 200,
              ),
            ),
        ],
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

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: context.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText.titleMedium(
              value,
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
            CommonText.bodySmall(
              title,
              color: context.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }
}
