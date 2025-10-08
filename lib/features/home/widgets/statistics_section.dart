import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/common/common_text.dart';
import '../../../core/widgets/responsive_container.dart';
import '../providers/home_providers.dart';

/// Section displaying platform statistics
class StatisticsSection extends ConsumerWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(platformStatsProvider);

    return ResponsiveSection(
      backgroundColor: context.surfaceContainer,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // Level up section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primary.withAlpha(26), // 0.1 * 255
                  context.secondary.withAlpha(26), // 0.1 * 255
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.primary.withAlpha(51), // 0.2 * 255
              ),
            ),
            child: Column(
              children: [
                CommonText.headlineMedium(
                  context.translate('level_up_heading'),
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                CommonText.bodyLarge(
                  context.translate('level_up_desc'),
                  textAlign: TextAlign.center,
                  color: context.onSurfaceVariant,
                ),
                const SizedBox(height: 20),
                // Level progression visualization
                _buildLevelProgression(context),
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          // Statistics grid
          if (context.isMobile)
            // Mobile: Vertical layout
            Column(
              children: [
                _StatCard(
                  title: context.translate('fastest_payout_today'),
                  value: stats.fastestPayoutTime,
                  icon: Icons.flash_on,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  title: context.translate('avg_cashout_month'),
                  value: '\$${stats.averageEarnings.toStringAsFixed(0)} USD',
                  icon: Icons.account_balance_wallet,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  title: context
                      .translate('users_in_countries')
                      .replaceAll('{0}', stats.countriesCount.toString()),
                  value: '${stats.countriesCount} Countries',
                  icon: Icons.public,
                ),
              ],
            )
          else
            // Desktop/Tablet: Horizontal layout
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: context.translate('fastest_payout_today'),
                    value: stats.fastestPayoutTime,
                    icon: Icons.flash_on,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _StatCard(
                    title: context.translate('avg_cashout_month'),
                    value: '\$${stats.averageEarnings.toStringAsFixed(0)} USD',
                    icon: Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _StatCard(
                    title: context
                        .translate('users_in_countries')
                        .replaceAll('{0}', stats.countriesCount.toString()),
                    value: '${stats.countriesCount} Countries',
                    icon: Icons.public,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLevelProgression(BuildContext context) {
    final levels = [
      context.translate('level_hodler'),
      context.translate('level_trader'),
      context.translate('level_investor'),
      context.translate('level_cryptolord')
    ];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: levels.asMap().entries.map((entry) {
        final index = entry.key;
        final level = entry.value;
        final isActive = index == 1; // Simulate current level
        
        return Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? context.primary : context.surfaceContainer,
                border: Border.all(
                  color: isActive ? context.primary : context.outline,
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  _getLevelIcon(index),
                  color: isActive ? context.onPrimary : context.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CommonText.bodySmall(
              level,
              color: isActive ? context.primary : context.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ],
        );
      }).toList(),
    );
  }

  IconData _getLevelIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.trending_up;
      case 2:
        return Icons.business_center;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.person;
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: context.primary,
            ),
            const SizedBox(height: 12),
            CommonText.headlineSmall(
              value,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
            const SizedBox(height: 8),
            CommonText.bodyMedium(
              title,
              textAlign: TextAlign.center,
              color: context.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}