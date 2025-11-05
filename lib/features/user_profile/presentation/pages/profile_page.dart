import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/common/widgets/build_app_bar_title.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/balance_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/level_rewards_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_details_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_footer.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_header.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_state_notifier.dart';
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
      ref.read(profileNotifierProvider.notifier).loadProfile();
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

    return Scaffold(
      backgroundColor: AppColors.websiteBackground,
      body: Expanded(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 80.0,
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: context.surface.withAlpha(242), // 0.95 * 255
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 1,
              automaticallyImplyLeading:
                  MediaQuery.of(context).size.width < 768,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.surface.withAlpha(250), // 0.98 * 255
                        context.surface.withAlpha(235), // 0.92 * 255
                      ],
                    ),
                  ),
                ),
              ),
              title: CommonAppBar(),
              titleSpacing: 16,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ProfileHeader(),
                SizedBox(height: isMobile ? 16 : 24),
                ProfileTabBar(),
                SizedBox(height: isMobile ? 16 : 24),
                BalanceSection(),
                SizedBox(height: isMobile ? 16 : 24),
                LevelRewardsSection(),
                SizedBox(height: isMobile ? 16 : 24),
                ProfileDetailsSection(),
                SizedBox(height: isMobile ? 16 : 24),
                ProfileFooter(),
                SizedBox(height: 24),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
