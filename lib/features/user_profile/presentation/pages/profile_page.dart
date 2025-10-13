import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/common/common_text.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_state_notifier.dart';

/// Profile page exactly matching Cointiply.com design
/// 
/// Features a dark theme with gradient backgrounds, balance cards,
/// level progress, achievement badges, and detailed profile information.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
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
      backgroundColor: const Color(0xFF0F1419), // Dark background like Cointiply
      body: _buildBody(context, profileState, localizations),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProfileState profileState,
    AppLocalizations? localizations,
  ) {
    if (profileState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE91E63), // Pink accent
        ),
      );
    }

    if (profileState.error != null) {
      return _buildErrorState(context, profileState.error!, localizations);
    }

    if (profileState.profile == null) {
      return _buildEmptyState(context, localizations);
    }

    return _buildCointiplyProfileContent(context, profileState.profile!, localizations);
  }

  Widget _buildErrorState(
    BuildContext context,
    String error,
    AppLocalizations? localizations,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFE91E63),
          ),
          const SizedBox(height: 16),
          CommonText.bodyMedium(
            error,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(profileNotifierProvider.notifier).loadProfile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
            ),
            child: CommonText.bodyMedium(localizations?.translate('retry') ?? 'Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations? localizations,
  ) {
    return Center(
      child: CommonText.bodyMedium(
        'Profile not found',
        color: Colors.white,
      ),
    );
  }

  Widget _buildCointiplyProfileContent(
    BuildContext context,
    UserProfile profile,
    AppLocalizations? localizations,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with gradient background
          _buildProfileHeader(context, profile),
          
          // Navigation tabs
          _buildNavigationTabs(context),
          
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Balances section
                _buildBalancesSection(context, profile),
                const SizedBox(height: 24),
                
                // Level rewards section
                _buildLevelRewardsSection(context, profile),
                const SizedBox(height: 24),
                
                // Achievement badges
                _buildAchievementBadges(context, profile),
                const SizedBox(height: 24),
                
                // Profile details
                _buildProfileDetails(context, profile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1), // Purple
            Color(0xFFEC4899), // Pink
            Color(0xFF3B82F6), // Blue
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
        child: Column(
          children: [
            // Avatar and basic info
            Row(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: profile.profilePictureUrl != null
                        ? DecorationImage(
                            image: NetworkImage(profile.profilePictureUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: profile.profilePictureUrl == null
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.headlineSmall(
                        profile.displayName ?? profile.username,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CommonText.labelMedium(
                          'Level ${profile.stats?.currentLevel ?? 1}',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CommonText.bodySmall(
                        'XP: ${profile.stats?.experiencePoints ?? 0} / ${((profile.stats?.currentLevel ?? 1) + 1) * 1000}',
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTabs(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A2332),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildNavTab('Overview', true),
            _buildNavTab('Statistics', false),
            _buildNavTab('Data Lab', false),
            _buildNavTab('Rewards', false),
            _buildNavTab('Referrals', false),
            _buildNavTab('Evolution', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? const Color(0xFFE91E63) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: CommonText.bodyMedium(
        title,
        color: isSelected ? const Color(0xFFE91E63) : Colors.white70,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildBalancesSection(BuildContext context, UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.titleMedium(
          'Balances',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Coins balance
            Expanded(
              child: _buildBalanceCard(
                '1,000',
                'Coins',
                const Color(0xFFE91E63),
                Icons.monetization_on,
              ),
            ),
            const SizedBox(width: 12),
            // Bitcoin balance
            Expanded(
              child: _buildBalanceCard(
                '\$${(profile.stats?.totalEarnings ?? 0.0).toStringAsFixed(1)}',
                'Earnings',
                const Color(0xFFF59E0B),
                Icons.currency_bitcoin,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Additional balances
            Expanded(
              child: _buildBalanceCard(
                '0.00000001',
                'BTC',
                const Color(0xFF10B981),
                Icons.currency_bitcoin,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBalanceCard(
                'N/A',
                'Ethereum',
                const Color(0xFF6366F1),
                Icons.diamond,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBalanceCard(
                'N/A',
                'Litecoin',
                const Color(0xFF8B5CF6),
                Icons.monetization_on,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Withdraw earnings button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement withdraw
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: CommonText.titleMedium(
              'Withdraw Earnings',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(String amount, String currency, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF374151), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          CommonText.titleMedium(
            amount,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          CommonText.bodySmall(
            currency,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRewardsSection(BuildContext context, UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.titleMedium(
          'Level Rewards',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        CommonText.bodyMedium(
          'Level up and unlock new rewards',
          color: Colors.white70,
        ),
        const SizedBox(height: 16),
        // Level progress
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF374151), width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.titleSmall(
                    'Level ${profile.stats?.currentLevel ?? 1}',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  CommonText.bodyMedium(
                    '${profile.stats?.experiencePoints ?? 0} / ${((profile.stats?.currentLevel ?? 1) + 1) * 1000}',
                    color: Colors.white70,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              LinearProgressIndicator(
                value: (profile.stats?.experiencePoints ?? 0) / (((profile.stats?.currentLevel ?? 1) + 1) * 1000),
                backgroundColor: const Color(0xFF374151),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Reward icons row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRewardIcon(Icons.card_giftcard, 'Level 2'),
            _buildRewardIcon(Icons.local_fire_department, 'Level 3'),
            _buildRewardIcon(Icons.military_tech, 'Level 4'),
            _buildRewardIcon(Icons.diamond, 'Level 5'),
            _buildRewardIcon(Icons.stars, 'Level 6'),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardIcon(IconData icon, String level) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF374151), width: 1),
          ),
          child: Icon(icon, color: Colors.white70, size: 24),
        ),
        const SizedBox(height: 8),
        CommonText.labelSmall(
          level,
          color: Colors.white70,
        ),
      ],
    );
  }

  Widget _buildAchievementBadges(BuildContext context, UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText.titleMedium(
              'Achievements',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            CommonText.bodyMedium(
              '${profile.stats?.achievementsCount ?? 0}',
              color: Colors.white70,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAchievementBadge(Icons.track_changes, 'Daily Spin', 'It links daily spin free play'),
            _buildAchievementBadge(Icons.help, 'Mystery Box', 'Get Mystery box from offers'),
            _buildAchievementBadge(Icons.shield, 'Offer Guard', 'No issues with the offerwall'),
            _buildAchievementBadge(Icons.discount, 'PTC Ad Discount', 'No discount on PTC ads'),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(IconData icon, String title, String description) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE91E63), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFE91E63), size: 32),
            const SizedBox(height: 8),
            CommonText.labelMedium(
              title,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            CommonText.labelSmall(
              description,
              color: Colors.white70,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText.titleMedium(
              'Profile Details',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            TextButton(
              onPressed: () {
                // TODO: Edit profile
              },
              child: CommonText.bodyMedium(
                'Edit Profile',
                color: const Color(0xFFE91E63),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF374151), width: 1),
          ),
          child: Column(
            children: [
              _buildDetailRow('First Name', profile.displayName?.split(' ').first ?? 'Not'),
              _buildDetailRow('Last Name', (profile.displayName?.split(' ').length ?? 0) > 1 ? profile.displayName!.split(' ').last : 'Set'),
              _buildDetailRow('Birthday', profile.dateOfBirth?.toString().split(' ').first ?? 'Not set'),
              _buildDetailRow('Bio', profile.bio ?? 'test123456@gmail.com'),
              _buildDetailRow('Referrals', '${profile.stats?.referralsCount ?? 0}'),
              // Recommendation banner
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F4C3A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF10B981), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonText.labelMedium(
                        'We Recommend Your Rotate 2FA',
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText.bodyMedium(
            label,
            color: Colors.white70,
          ),
          CommonText.bodyMedium(
            value,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}