import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/referrals/presentation/providers/referral_users_provider.dart';
import 'package:cointiply_app/features/referrals/presentation/providers/reffertal_banner_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/refferals/manage_referrals_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/refferals/referral_get_started_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/refferals/referred_users_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileReferralsSection extends ConsumerStatefulWidget {
  const ProfileReferralsSection({super.key});

  @override
  ConsumerState<ProfileReferralsSection> createState() =>
      _ProfileReferralsSectionState();
}

class _ProfileReferralsSectionState
    extends ConsumerState<ProfileReferralsSection> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(referralBannerNotifierProvider.notifier).fetchReferralBanners();
      ref.read(referralUsersNotifierProvider.notifier).fetchReferralUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ManageReferralsSection(),
        SizedBox(height: isMobile ? 16 : 24),
        ReferredUsersSection(),
        SizedBox(height: isMobile ? 16 : 24),
        ReferralGetStartedSection(),
        SizedBox(height: isMobile ? 16 : 24),
      ],
    );
  }
}
