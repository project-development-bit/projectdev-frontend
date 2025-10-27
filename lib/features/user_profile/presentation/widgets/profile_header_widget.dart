import 'package:flutter/material.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user_profile.dart';

/// Profile header widget with gradient background and user info
class ProfileHeaderWidget extends StatelessWidget {
  final UserProfile profile;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.isDark
              ? [
                  context.primary.withOpacity(0.8),
                  context.secondary.withOpacity(0.8),
                  context.tertiary.withOpacity(0.8),
                ]
              : [
                  context.primary,
                  context.secondary,
                  context.tertiary,
                ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
        child: Column(
          children: [
            _buildUserInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(context),
        const SizedBox(width: 16),
        _buildUserDetails(context),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: context.isDark ? Colors.white : context.onPrimary, width: 3),
        image: profile.profilePictureUrl != null
            ? DecorationImage(
                image: NetworkImage(profile.profilePictureUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: profile.profilePictureUrl == null
          ? Icon(Icons.person,
              size: 40,
              color: context.isDark ? Colors.white : context.onPrimary)
          : null,
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.headlineSmall(
            profile.displayName ?? profile.username,
            color: context.isDark ? Colors.white : context.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          _buildLevelBadge(context),
          const SizedBox(height: 8),
          _buildExperienceText(context),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: (context.isDark ? Colors.white : context.onPrimary)
            .withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CommonText.labelMedium(
        'Level ${profile.stats?.currentLevel ?? 1}',
        color: context.isDark ? Colors.white : context.onPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildExperienceText(BuildContext context) {
    return CommonText.bodySmall(
      'XP: ${profile.stats?.experiencePoints ?? 0} / ${((profile.stats?.currentLevel ?? 1) + 1) * 1000}',
      color:
          (context.isDark ? Colors.white : context.onPrimary).withOpacity(0.7),
    );
  }
}
