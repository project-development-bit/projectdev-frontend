import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_state_notifier.dart';
import '../widgets/widgets.dart';

/// Profile page exactly matching Cointiply.com design
/// 
/// Features a theme-aware design with gradient backgrounds, balance cards,
/// level progress, achievement badges, and detailed profile information.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  static const List<String> _navigationTabs = [
    'Overview',
    'Statistics',
    'Data Lab',
    'Rewards',
    'Referrals',
    'Evolution',
  ];

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load profile data when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: context.surface,
      body: _buildBody(context, profileState, localizations),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProfileState profileState,
    AppLocalizations? localizations,
  ) {
    if (profileState.isLoading) {
      return const ProfileLoadingWidget();
    }

    if (profileState.error != null) {
      return ProfileErrorWidget(
        error: profileState.error!,
        onRetry: () => ref.read(profileNotifierProvider.notifier).loadProfile(),
      );
    }

    if (profileState.profile == null) {
      return const ProfileEmptyWidget();
    }

    return _buildProfileContent(context, profileState.profile!);
  }

  Widget _buildProfileContent(BuildContext context, UserProfile profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with gradient background
          ProfileHeaderWidget(profile: profile),

          // Navigation tabs
          ProfileNavigationWidget(
            tabs: _navigationTabs,
            selectedIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),
          
          // Main content based on selected tab
          _buildTabContent(context, profile),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Balances section
          BalancesSectionWidget(
            profile: profile,
            onWithdraw: _onWithdrawEarnings,
          ),
          const SizedBox(height: 24),

          // Level rewards section
          LevelRewardsSectionWidget(profile: profile),
          const SizedBox(height: 24),

          // Achievement badges
          AchievementBadgesSectionWidget(profile: profile),
          const SizedBox(height: 24),

          // Profile details
          ProfileDetailsSectionWidget(
            profile: profile,
            onEditProfile: _onEditProfile,
          ),
        ],
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _onWithdrawEarnings() {
    // TODO: Implement withdraw earnings functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Withdraw earnings feature coming soon!')),
    );
  }

  void _onEditProfile() {
    // TODO: Implement edit profile functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon!')),
    );
  }
}