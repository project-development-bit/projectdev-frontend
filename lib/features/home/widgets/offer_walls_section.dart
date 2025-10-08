import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/common_button.dart';
import '../providers/home_providers.dart';

/// Section displaying offer walls and partner networks
class OfferWallsSection extends ConsumerWidget {
  const OfferWallsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerWalls = ref.watch(offerWallsProvider);

    return Container(
      width: double.infinity,
      color: context.surfaceContainer.withAlpha(77), // 0.3 * 255
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? 16 : 32,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.headlineMedium(
                    context.translate('offer_walls'),
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  CommonText.bodyMedium(
                    context.translate('trusted_networks'),
                    color: context.onSurfaceVariant,
                  ),
                ],
              ),
              const Spacer(),
              if (!context.isMobile)
                CommonButton(
                  text: context.translate('explore_offer_walls'),
                  onPressed: () {
                    // TODO: Navigate to offer walls
                  },
                  isOutlined: true,
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Trust badges
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.outline.withAlpha(51), // 0.2 * 255
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TrustBadge(
                  icon: Icons.verified_user,
                  text: context.translate('verified_partners'),
                ),
                _TrustBadge(
                  icon: Icons.track_changes,
                  text: context.translate('instant_tracking'),
                ),
                _TrustBadge(
                  icon: Icons.trending_up,
                  text: context.translate('high_payouts'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Offer walls grid
          if (context.isMobile)
            // Mobile: Vertical list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: offerWalls.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final offerWall = offerWalls[index];
                return _OfferWallCard(offerWall: offerWall);
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
                childAspectRatio: 2.5,
              ),
              itemCount: offerWalls.length,
              itemBuilder: (context, index) {
                final offerWall = offerWalls[index];
                return _OfferWallCard(offerWall: offerWall);
              },
            ),

          const SizedBox(height: 32),

          // Mobile "Explore" button
          if (context.isMobile)
            Center(
              child: CommonButton(
                text: context.translate('explore_offer_walls'),
                onPressed: () {
                  // TODO: Navigate to offer walls
                },
                isOutlined: true,
                width: 200,
              ),
            ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: context.primary,
          size: 32,
        ),
        const SizedBox(height: 8),
        CommonText.bodySmall(
          text,
          textAlign: TextAlign.center,
          color: context.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class _OfferWallCard extends StatelessWidget {
  const _OfferWallCard({
    required this.offerWall,
  });

  final dynamic offerWall; // Using dynamic for now, should be OfferWallModel

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Logo/Code
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CommonText.titleSmall(
                  offerWall.code,
                  color: context.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText.titleSmall(
                    offerWall.name,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: CommonText.bodySmall(
                            '${offerWall.offerCount} offers',
                            color: context.onSurfaceVariant,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: CommonText.bodySmall(
                            '\$${offerWall.averagePayout.toStringAsFixed(2)}',
                            color: context.primary,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Rating
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
                const SizedBox(width: 2),
                CommonText.bodySmall(
                  '${offerWall.rating}/5',
                  color: context.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}