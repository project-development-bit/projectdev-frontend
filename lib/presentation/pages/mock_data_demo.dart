import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Demo page to showcase all available mock data for the profile module
///
/// This page displays all the mock user profiles that are available
/// for development and testing purposes, formatted in a readable way.
class MockDataDemo extends StatelessWidget {
  const MockDataDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Mock Data Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Mock User Profiles',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Regular User Profile
            _buildProfileCard(
              'Regular User Profile (ID: 1)',
              'This is the default mock profile loaded when getUserProfile() is called',
              [
                'Username: johndoe2024',
                'Email: john.doe@example.com',
                'Display Name: John Doe',
                'Status: Active & Verified',
                'Total Earnings: \$1,247.85',
                'Completed Offers: 156',
                'Level: 5 (Gold equivalent)',
                'Experience Points: 12,450',
                'Referrals: 12',
                'Current Streak: 7 days',
                'Member Since: March 10, 2022',
              ],
            ),

            const SizedBox(height: 20),

            // New User Profile
            _buildProfileCard(
              'New User Profile (ID: 2)',
              'Perfect for testing onboarding flows and empty states',
              [
                'Username: newuser2024',
                'Email: newuser@example.com',
                'Display Name: New User',
                'Status: Active but Unverified',
                'Total Earnings: \$0.00',
                'Completed Offers: 0',
                'Level: 1 (Bronze equivalent)',
                'Experience Points: 0',
                'Referrals: 0',
                'Current Streak: 0 days',
                'Member Since: Yesterday',
              ],
            ),

            const SizedBox(height: 20),

            // Premium User Profile
            _buildProfileCard(
              'Premium User Profile (ID: 3)',
              'High-value user for testing advanced features and UI with large numbers',
              [
                'Username: cryptomaster',
                'Email: premium.user@example.com',
                'Display Name: Crypto Master',
                'Status: Active & Verified',
                'Total Earnings: \$15,847.92',
                'Completed Offers: 2,847',
                'Level: 15 (Diamond equivalent)',
                'Experience Points: 58,920',
                'Referrals: 45',
                'Current Streak: 45 days',
                'Member Since: June 15, 2018',
              ],
            ),

            const SizedBox(height: 20),

            // Problematic User Profile
            _buildProfileCard(
              'Problematic User Profile (ID: 4)',
              'User with account issues for testing error states and support flows',
              [
                'Username: problemuser',
                'Email: problem.user@example.com',
                'Display Name: Problem User',
                'Status: Suspended & Pending Verification',
                'Total Earnings: \$89.45',
                'Completed Offers: 23',
                'Level: 2 (Bronze equivalent)',
                'Experience Points: 245',
                'Referrals: 2',
                'Current Streak: 0 days (broken)',
                'Member Since: January 20, 2023',
                'Last Login: 3 days ago',
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Mock Data Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _buildFeatureList([
              '🔄 Simulated network delays (800ms) for realistic testing',
              '🖼️ Random profile picture URLs from pravatar.cc',
              '✅ Proper enum usage for AccountStatus and VerificationStatus',
              '📊 Comprehensive statistics for each user type',
              '🚫 Error simulation for authentication and validation',
              '📱 Responsive data that works with the UI components',
              '🌍 Realistic user data from different regions',
              '⏱️ Dynamic timestamps based on current time',
            ]),

            const SizedBox(height: 20),

            const Text(
              'How to Use Mock Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _buildFeatureList([
              '1. Import ProfileMockDataSource in your provider configuration',
              '2. Replace ProfileRemoteDataSourceImpl with ProfileMockDataSource',
              '3. Use ProfileMockDataProvider static methods for specific scenarios',
              '4. Mock data automatically loads when navigating to profile page',
              '5. Test different user states by switching mock data sources',
              '6. Simulate API errors by modifying mock delays and responses',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      String title, String description, List<String> details) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.info,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.darkTextTertiary,
              ),
            ),
            const SizedBox(height: 12),
            ...details.map((detail) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(child: Text(detail)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: features
              .map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
