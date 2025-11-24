import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/get_profile_notifier.dart';

/// Example page demonstrating how to use the Get Profile API
///
/// This page shows how to:
/// 1. Fetch user profile on page load
/// 2. Display loading, error, and success states
/// 3. Refresh profile data
/// 4. Access profile information (account, security, settings)
class GetProfileExamplePage extends ConsumerStatefulWidget {
  const GetProfileExamplePage({super.key});

  @override
  ConsumerState<GetProfileExamplePage> createState() => _GetProfileExamplePageState();
}

class _GetProfileExamplePageState extends ConsumerState<GetProfileExamplePage> {
  @override
  void initState() {
    super.initState();
    // Fetch profile when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getProfileNotifierProvider.notifier).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(getProfileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(getProfileNotifierProvider.notifier).refreshProfile();
            },
          ),
        ],
      ),
      body: _buildBody(profileState),
    );
  }

  Widget _buildBody(GetProfileState state) {
    // Loading state
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Failed to load profile',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(getProfileNotifierProvider.notifier).fetchProfile();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Success state with data
    if (state.hasData && state.profile != null) {
      final profile = state.profile!;
      
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Information Section
            _buildSection(
              title: 'Account Information',
              icon: Icons.person,
              children: [
                _buildInfoRow('Username', profile.account.username),
                _buildInfoRow('Email', profile.account.email),
                _buildInfoRow('Country', profile.account.country ?? 'Not set'),
                _buildInfoRow('Offer Token', profile.account.offerToken ?? 'Not set'),
                _buildInfoRow(
                  'Created At',
                  profile.account.createdAt.toString().split('.')[0],
                ),
                const SizedBox(height: 8),
                // Avatar
                if (profile.account.avatarUrl.isNotEmpty)
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profile.account.avatarUrl),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Security Settings Section
            _buildSection(
              title: 'Security Settings',
              icon: Icons.security,
              children: [
                _buildInfoRow(
                  '2FA Enabled',
                  profile.security.twofaEnabled ? 'Yes' : 'No',
                  valueColor: profile.security.twofaEnabled ? Colors.green : Colors.red,
                ),
                _buildInfoRow(
                  'Security PIN Enabled',
                  profile.security.securityPinEnabled ? 'Yes' : 'No',
                  valueColor: profile.security.securityPinEnabled ? Colors.green : Colors.red,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // User Settings Section
            _buildSection(
              title: 'Preferences',
              icon: Icons.settings,
              children: [
                _buildInfoRow('Language', profile.settings.language.toUpperCase()),
                _buildInfoRow(
                  'Notifications',
                  profile.settings.notificationsEnabled ? 'Enabled' : 'Disabled',
                ),
                _buildInfoRow(
                  'Show Stats',
                  profile.settings.showStatsEnabled ? 'Enabled' : 'Disabled',
                ),
                _buildInfoRow(
                  'Anonymous in Contests',
                  profile.settings.anonymousInContests ? 'Yes' : 'No',
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Initial state
    return const Center(
      child: Text('Press refresh to load profile'),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
