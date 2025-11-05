import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_card.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
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
  static const List<String> _statisticsTabs = [
    'Statistics',
    'Coins Earned History',
  ];

  int _selectedTabIndex = 0;

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
    final profileState = ref.watch(profileNotifierProvider);
    final currentUserState = ref.watch(currentUserProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isMobile = screenWidth <= 768;

    return Scaffold(
      backgroundColor: AppColors.websiteBackground,
      drawer: isMobile ? _buildMobileDrawer() : null,
      appBar: isMobile ? _buildMobileAppBar() : null,
      body: Row(
        children: [
          // Sidebar Navigation (Desktop and Tablet only)
          if (isDesktop || isTablet) ...[
            _buildSidebar(context, isTablet: isTablet),
            Container(
              width: 1,
              color: AppColors.websiteBorder,
            ),
          ],

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Header Section
                  _buildUserProfileHeader(context, currentUserState,
                      isMobile: isMobile),
                  SizedBox(height: isMobile ? 16 : 24),

                  // Statistics Tab Section
                  _buildStatisticsTabSection(context, isMobile: isMobile),
                  SizedBox(height: isMobile ? 16 : 24),

                  // Activity Sections
                  _buildActivitySections(context, profileState,
                      isMobile: isMobile),
                  SizedBox(height: isMobile ? 16 : 24),

                  // Additional Information
                  if (profileState.profile != null) ...[
                    _buildAdditionalInfo(context, profileState.profile!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileHeader(BuildContext context, currentUserState,
      {bool isMobile = false}) {
    return CommonCard(
      backgroundColor: AppColors.websiteCard,
      borderRadius: 16,
      showShadow: true,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          children: [
            // Profile info section - responsive layout
            isMobile
                ? _buildMobileProfileLayout(context, currentUserState)
                : _buildDesktopProfileLayout(context, currentUserState),
            SizedBox(height: isMobile ? 16 : 24),

            // Stats Row - responsive
            _buildStatsRow(context, isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopProfileLayout(BuildContext context, currentUserState) {
    return Row(
      children: [
        // Profile Avatar with level badge
        _buildProfileAvatar(currentUserState),
        const SizedBox(width: 24),

        // User Info
        Expanded(
          child: _buildUserInfo(context, currentUserState),
        ),
      ],
    );
  }

  Widget _buildMobileProfileLayout(BuildContext context, currentUserState) {
    return Column(
      children: [
        // Profile Avatar with level badge
        _buildProfileAvatar(currentUserState),
        const SizedBox(height: 16),

        // User Info
        _buildUserInfo(context, currentUserState),
      ],
    );
  }

  Widget _buildProfileAvatar(currentUserState) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(37),
            child: currentUserState.user?.name.isNotEmpty == true
                ? CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: CommonText(
                      currentUserState.user!.name.substring(0, 1).toUpperCase(),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : const CircleAvatar(
                    backgroundColor: AppColors.websiteText,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
          ),
        ),
        // Level badge
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.websiteGold,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.websiteBackground, width: 2),
            ),
            child: const CommonText(
              '19',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, currentUserState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User name and badge row
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CommonText(
              currentUserState.user?.name ?? 'Loading...',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  CommonText(
                    'Bronze 1',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CommonText(
          'Created 5 Days ago',
          fontSize: 14,
          color: AppColors.websiteText,
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.websiteText),
        const SizedBox(height: 8),
        CommonText(
          value,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        CommonText(
          label,
          fontSize: 12,
          color: AppColors.websiteText,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatisticsTabSection(BuildContext context,
      {bool isMobile = false}) {
    return CommonCard(
      backgroundColor: AppColors.websiteCard,
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tab Header
            Row(
              children: [
                for (int i = 0; i < _statisticsTabs.length; i++) ...[
                  GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == i
                            ? AppColors.websiteGold
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CommonText(
                        _statisticsTabs[i],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedTabIndex == i
                            ? Colors.white
                            : AppColors.websiteText,
                      ),
                    ),
                  ),
                  if (i < _statisticsTabs.length - 1) const SizedBox(width: 16),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Tab Content
            if (_selectedTabIndex == 0)
              _buildStatisticsContent()
            else
              _buildCoinsEarnedHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsContent() {
    return const CommonText(
      'Statistics content will be shown here based on user activity.',
      color: AppColors.websiteText,
    );
  }

  Widget _buildCoinsEarnedHistory() {
    return const CommonText(
      'Coins earned history will be displayed here.',
      color: AppColors.websiteText,
    );
  }

  Widget _buildActivitySections(BuildContext context, ProfileState profileState,
      {bool isMobile = false}) {
    return Column(
      children: [
        // Surveys Section
        _buildActivitySection(
          'Surveys',
          Icons.poll,
          '14',
          '14',
          AppColors.primary,
        ),
        const SizedBox(height: 16),

        // Game Apps Section
        _buildActivitySection(
          'Game Apps',
          Icons.games,
          '154',
          '1,454',
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildActivitySection(
    String title,
    IconData icon,
    String number,
    String totalEarn,
    Color accentColor,
  ) {
    return CommonCard(
      backgroundColor: AppColors.websiteCard,
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 16),
                CommonText(
                  title,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActivityStat('Number', number),
                ),
                Expanded(
                  child: _buildActivityStat('Total Earn', '$totalEarn 🪙'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.websiteBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            label,
            fontSize: 14,
            color: AppColors.websiteText,
          ),
          const SizedBox(height: 8),
          CommonText(
            value,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context, UserProfile profile) {
    return CommonCard(
      backgroundColor: AppColors.websiteCard,
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              'Additional Information',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            CommonText(
              'Profile details and additional statistics will be displayed here.',
              color: AppColors.websiteText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, {bool isTablet = false}) {
    final sidebarItems = [
      {'title': 'General Informations', 'icon': Icons.info_outline},
      {'title': 'User Account', 'icon': Icons.person_outline},
      {'title': 'Faucet', 'icon': Icons.water_drop_outlined},
      {'title': 'User Rewards', 'icon': Icons.card_giftcard_outlined},
      {'title': 'Funny Tests!', 'icon': Icons.emoji_emotions_outlined},
      {'title': '2FA', 'icon': Icons.security},
    ];

    return Container(
      width: 250,
      color: AppColors.websiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  'Documentation',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                CommonText(
                  'Profile Information',
                  fontSize: 14,
                  color: AppColors.websiteText,
                ),
              ],
            ),
          ),

          // Sidebar Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: sidebarItems.length,
              itemBuilder: (context, index) {
                final item = sidebarItems[index];
                final isSelected = index == 1; // User Account is selected

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.websiteText,
                      size: 20,
                    ),
                    title: CommonText(
                      item['title'] as String,
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.websiteText,
                    ),
                    onTap: () {
                      item['title'] == '2FA'
                          ? context.show2FAVerificationDialog()
                          : null; // Handle navigation
                    },
                  ),
                );
              },
            ),
          ),

          // Sidebar Footer
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CommonText(
                  '©2025© GigaFaucet',
                  fontSize: 12,
                  color: AppColors.websiteText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, {bool isMobile = false}) {
    final stats = [
      {'icon': Icons.message, 'value': '1,542', 'label': 'Messages'},
      {'icon': Icons.flag, 'value': 'Thailand', 'label': 'Country'},
      {'icon': Icons.star, 'value': '1,468', 'label': 'Total Earn'},
    ];

    if (isMobile) {
      // Mobile: Stack stats vertically with more spacing
      return Column(
        children: [
          for (int i = 0; i < stats.length; i++) ...[
            _buildStatItem(stats[i]['icon'] as IconData,
                stats[i]['value'] as String, stats[i]['label'] as String),
            if (i < stats.length - 1) ...[
              const SizedBox(height: 16),
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.websiteText.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ],
      );
    } else {
      // Desktop/Tablet: Horizontal layout
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < stats.length; i++) ...[
            _buildStatItem(stats[i]['icon'] as IconData,
                stats[i]['value'] as String, stats[i]['label'] as String),
            if (i < stats.length - 1)
              Container(
                width: 1,
                height: 40,
                color: AppColors.websiteText.withValues(alpha: 0.3),
              ),
          ],
        ],
      );
    }
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: AppColors.websiteCard,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          'John Doe',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.websiteText,
                        ),
                        CommonText(
                          'Premium User',
                          fontSize: 14,
                          color: AppColors.websiteGold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.websiteText),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(Icons.dashboard, 'Dashboard', true),
                  _buildDrawerItem(Icons.person, 'Profile', false),
                  _buildDrawerItem(Icons.wallet, 'Wallet', false),
                  _buildDrawerItem(Icons.poll, 'Surveys', false),
                  _buildDrawerItem(Icons.games, 'Games', false),
                  _buildDrawerItem(Icons.leaderboard, 'Leaderboard', false),
                  _buildDrawerItem(Icons.settings, 'Settings', false),
                  _buildDrawerItem(Icons.help, 'Help', false),
                ],
              ),
            ),

            // Drawer Footer
            Container(
              padding: const EdgeInsets.all(24),
              child: const CommonText(
                '©2025© GigaFaucet',
                fontSize: 12,
                color: AppColors.websiteText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.websiteText,
      ),
      title: CommonText(
        title,
        fontSize: 16,
        color: isSelected ? AppColors.primary : AppColors.websiteText,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      onTap: () {
        Navigator.pop(context);
        // Handle navigation
      },
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: AppColors.websiteBackground,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.websiteText),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const CommonText(
        'Profile',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.websiteText,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: AppColors.websiteText),
          onPressed: () {
            // Handle notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.websiteText),
          onPressed: () {
            // Handle settings
          },
        ),
      ],
    );
  }
}
