import 'package:cointiply_app/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Individual reward icon widget
class RewardIconWidget extends StatelessWidget {
  final IconData icon;
  final String level;

  const RewardIconWidget({
    super.key,
    required this.icon,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: context.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.outline, width: 1),
          ),
          child: Icon(icon,
              color: context.onSurface.withValues(alpha: 0.7), size: 24),
        ),
        const SizedBox(height: 8),
        CommonText.labelSmall(
          level,
          color: context.onSurface.withValues(alpha: 0.7),
        ),
      ],
    );
  }
}

/// Level rewards section widget with progress and reward icons
class LevelRewardsSectionWidget extends StatelessWidget {
  final UserModel profile;

  const LevelRewardsSectionWidget({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        _buildLevelProgress(context),
        const SizedBox(height: 16),
        _buildRewardIcons(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.titleMedium(
          'Level Rewards',
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
        CommonText.bodyMedium(
          'Level up and unlock new rewards',
          color: context.onSurface.withValues(alpha: 0.7),
        ),
      ],
    );
  }

  Widget _buildLevelProgress(BuildContext context) {
    // final currentLevel = profile.stats?.currentLevel ?? 1;
    // final currentXP = profile.stats?.experiencePoints ?? 0;
    final currentLevel = 1;
    final currentXP = 0;
    final nextLevelXP = (currentLevel + 1) * 1000;
    final progress = currentXP / nextLevelXP;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.outline, width: 1),
      ),
      child: Column(
        children: [
          _buildProgressHeader(context, currentLevel, currentXP, nextLevelXP),
          const SizedBox(height: 12),
          _buildProgressBar(context, progress),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(
    BuildContext context,
    int currentLevel,
    int currentXP,
    int nextLevelXP,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText.titleSmall(
          'Level $currentLevel',
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
        CommonText.bodyMedium(
          '$currentXP / $nextLevelXP',
          color: context.onSurface.withValues(alpha: 0.7),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: context.outline,
      valueColor: AlwaysStoppedAnimation<Color>(context.primary),
    );
  }

  Widget _buildRewardIcons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RewardIconWidget(icon: Icons.card_giftcard, level: 'Level 2'),
        RewardIconWidget(icon: Icons.local_fire_department, level: 'Level 3'),
        RewardIconWidget(icon: Icons.military_tech, level: 'Level 4'),
        RewardIconWidget(icon: Icons.diamond, level: 'Level 5'),
        RewardIconWidget(icon: Icons.stars, level: 'Level 6'),
      ],
    );
  }
}
