import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/level_process_bar_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/level_tier_row_widget.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/reward_grid_widget.dart';
import 'package:flutter/material.dart';

class LevelRewardsSection extends StatelessWidget {
  const LevelRewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    final localizations = AppLocalizations.of(context);

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText.titleLarge(
              localizations?.translate('level_rewards_title') ?? '',
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CommonText.bodyMedium(
              localizations?.translate('level_rewards_subtitle') ?? '',
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            const LevelProcessBarWidget(),
            const SizedBox(height: 40),
            const LevelTierRowWidget(),
            const SizedBox(height: 32),
            const RewardGridWidget(),
          ],
        ),
      ),
    );
  }
}
