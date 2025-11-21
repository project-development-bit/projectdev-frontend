import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/data/enum/profile_tab_type.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_tab_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_footer.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_header.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_tab_bar.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sub_pages/profile_bonuses_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sub_pages/profile_cashout_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sub_pages/profile_deposit_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sub_pages/profile_overview_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sub_pages/profile_referrals_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/sub_pages/profile_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/current_user_provider.dart';

/// Profile page styled after GigaFaucet documentation design
///
/// Features a dark theme with user statistics, activity tracking,
/// and earnings breakdown similar to the GigaFaucet documentation.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile data and current user data when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentUserProvider.notifier).getCurrentUser();
      // Only initialize user if authenticated
      final isAuthenticated = ref.read(isAuthenticatedObservableProvider);
      if (isAuthenticated) {
        ref.read(currentUserProvider.notifier).initializeUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = screenWidth <= 768;
    final activeTab = ref.watch(profileTabProvider);

    Widget content;
    switch (activeTab) {
      case ProfileTabType.overview:
        content = const ProfileOverviewSection();
        break;
      case ProfileTabType.settings:
        content = const ProfileSettingsSection();
        break;
      case ProfileTabType.cashOut:
        content = const ProfileCashOutSection();
        break;
      case ProfileTabType.deposit:
        content = const ProfileDepositSection();
        break;
      case ProfileTabType.referrals:
        content = const ProfileReferralsSection();
        break;
      case ProfileTabType.bonuses:
        content = const ProfileBonusesSection();
        break;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              ProfileHeader(),
              SizedBox(height: isMobile ? 16 : 24),
              ProfileTabBar(),
              SizedBox(height: isMobile ? 16 : 24),
              content,
              ProfileFooter(),
              SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }
}
