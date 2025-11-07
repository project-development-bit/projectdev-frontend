import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/balance_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/level_rewards_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_details_section.dart';
import 'package:flutter/material.dart';

class ProfileOverviewSection extends StatelessWidget {
  const ProfileOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      children: [
        const BalanceSection(),
        SizedBox(height: isMobile ? 16 : 24),
        const LevelRewardsSection(),
        SizedBox(height: isMobile ? 16 : 24),
        const ProfileDetailsSection(),
      ],
    );
  }
}
