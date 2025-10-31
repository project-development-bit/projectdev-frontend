import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user_profile.dart';
import 'current_user_info_widget.dart';

/// Profile header widget with gradient background and user info
/// Now supports both UserProfile data and current user data from whoami API
class ProfileHeaderWidget extends ConsumerWidget {
  final UserProfile? profile;
  final bool showCurrentUser;

  const ProfileHeaderWidget({
    super.key,
    this.profile,
    this.showCurrentUser = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            if (showCurrentUser)
              _buildCurrentUserInfo(context, ref)
            else if (profile != null)
              _buildUserInfo(context)
            else
              _buildFallbackUserInfo(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentUserInfo(BuildContext context, WidgetRef ref) {
    return CurrentUserInfoWidget(
      autoRefresh: true,
      showLoading: true,
      decoration: null, // No decoration since we're in the gradient container
      padding: EdgeInsets.zero,
      isCompact: false,
    );
  }

  Widget _buildFallbackUserInfo(BuildContext context, WidgetRef ref) {
    // Show current user info if no profile is available
    return CurrentUserInfoWidget(
      autoRefresh: true,
      showLoading: true,
      decoration: null,
      padding: EdgeInsets.zero,
      isCompact: false,
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
        image: profile?.profilePictureUrl != null
            ? DecorationImage(
                image: NetworkImage(profile!.profilePictureUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: profile?.profilePictureUrl == null
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
            profile?.displayName ?? profile?.username ?? 'User',
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
        'Level ${profile?.stats?.currentLevel ?? 1}',
        color: context.isDark ? Colors.white : context.onPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildExperienceText(BuildContext context) {
    return CommonText.bodySmall(
      'XP: ${profile?.stats?.experiencePoints ?? 0} / ${((profile?.stats?.currentLevel ?? 1) + 1) * 1000}',
      color:
          (context.isDark ? Colors.white : context.onPrimary).withOpacity(0.7),
    );
  }
}
