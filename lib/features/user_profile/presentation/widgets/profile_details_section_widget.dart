import 'package:flutter/material.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user_profile.dart';

/// Profile detail row widget
class ProfileDetailRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailRowWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText.bodyMedium(
            label,
            color: context.onSurface.withOpacity(0.7),
          ),
          CommonText.bodyMedium(
            value,
            color: context.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

/// 2FA recommendation banner widget
class TwoFactorRecommendationWidget extends StatelessWidget {
  const TwoFactorRecommendationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.tertiary, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: context.tertiary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: CommonText.labelMedium(
              'We Recommend Your Rotate 2FA',
              color: context.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile details section widget
class ProfileDetailsSectionWidget extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEditProfile;

  const ProfileDetailsSectionWidget({
    super.key,
    required this.profile,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        _buildDetailsContainer(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText.titleMedium(
          'Profile Details',
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
        TextButton(
          onPressed: onEditProfile,
          child: CommonText.bodyMedium(
            'Edit Profile',
            color: context.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.outline, width: 1),
      ),
      child: Column(
        children: [
          _buildProfileDetails(),
          const SizedBox(height: 16),
          const TwoFactorRecommendationWidget(),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      children: [
        ProfileDetailRowWidget(
          label: 'First Name',
          value: profile.displayName?.split(' ').first ?? 'Not',
        ),
        ProfileDetailRowWidget(
          label: 'Last Name',
          value: (profile.displayName?.split(' ').length ?? 0) > 1 
              ? profile.displayName!.split(' ').last 
              : 'Set',
        ),
        ProfileDetailRowWidget(
          label: 'Birthday',
          value: profile.dateOfBirth?.toString().split(' ').first ?? 'Not set',
        ),
        ProfileDetailRowWidget(
          label: 'Bio',
          value: profile.bio ?? 'test123456@gmail.com',
        ),
        ProfileDetailRowWidget(
          label: 'Referrals',
          value: '${profile.stats?.referralsCount ?? 0}',
        ),
      ],
    );
  }
}