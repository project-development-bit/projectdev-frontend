import 'package:flutter/material.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user_profile.dart';

/// Individual achievement badge widget
class AchievementBadgeWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AchievementBadgeWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.primary, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: context.primary, size: 32),
            const SizedBox(height: 8),
            CommonText.labelMedium(
              title,
              color: context.onSurface,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            CommonText.labelSmall(
              description,
              color: context.onSurface.withOpacity(0.7),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Achievement badges section widget
class AchievementBadgesSectionWidget extends StatelessWidget {
  final UserProfile profile;

  const AchievementBadgesSectionWidget({
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
        _buildAchievementBadges(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText.titleMedium(
          'Achievements',
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
        CommonText.bodyMedium(
          '${profile.stats?.achievementsCount ?? 0}',
          color: context.onSurface.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _buildAchievementBadges() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AchievementBadgeWidget(
          icon: Icons.track_changes,
          title: 'Daily Spin',
          description: 'It links daily spin free play',
        ),
        AchievementBadgeWidget(
          icon: Icons.help,
          title: 'Mystery Box',
          description: 'Get Mystery box from offers',
        ),
        AchievementBadgeWidget(
          icon: Icons.shield,
          title: 'Offer Guard',
          description: 'No issues with the offerwall',
        ),
        AchievementBadgeWidget(
          icon: Icons.discount,
          title: 'PTC Ad Discount',
          description: 'No discount on PTC ads',
        ),
      ],
    );
  }
}
