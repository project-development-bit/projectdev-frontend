import 'package:flutter/material.dart';
import '../common/common_text.dart';
import '../theme/app_colors.dart';

/// Example widget showing proper usage of CommonText with Gigafaucet fonts
/// Demonstrates Orbitron for titles/headers and Barlow for body text
class FontExampleWidget extends StatelessWidget {
  const FontExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.websiteBackground,
      appBar: AppBar(
        title: const CommonText.titleLarge(
          'Font Example',
          color: Colors.white,
        ),
        backgroundColor: AppColors.websiteCard,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.websiteBackgroundStart,
              AppColors.websiteBackgroundEnd,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Examples (Orbitron)
              _buildSection(
                'Display Text (Orbitron)',
                [
                  const CommonText.displayLarge('Display Large'),
                  const CommonText.displayMedium('Display Medium'),
                  const CommonText.displaySmall('Display Small'),
                ],
              ),

              // Headline Examples (Orbitron)
              _buildSection(
                'Headlines (Orbitron)',
                [
                  const CommonText.headlineLarge('Headline Large'),
                  const CommonText.headlineMedium('Headline Medium'),
                  const CommonText.headlineSmall('Headline Small'),
                ],
              ),

              // Title Examples (Orbitron)
              _buildSection(
                'Titles (Orbitron)',
                [
                  const CommonText.titleLarge('Title Large'),
                  const CommonText.titleMedium('Title Medium'),
                  const CommonText.titleSmall('Title Small'),
                ],
              ),

              // Body Text Examples (Barlow)
              _buildSection(
                'Body Text (Barlow)',
                [
                  const CommonText.bodyLarge(
                    'This is body large text using Barlow font. It\'s used for main content and descriptions.',
                  ),
                  const CommonText.bodyMedium(
                    'This is body medium text using Barlow font. It\'s the most common text style.',
                  ),
                  const CommonText.bodySmall(
                    'This is body small text using Barlow font. Used for secondary information.',
                  ),
                ],
              ),

              // Label Examples (Orbitron)
              _buildSection(
                'Labels (Orbitron)',
                [
                  const CommonText.labelLarge('Label Large'),
                  const CommonText.labelMedium('Label Medium'),
                  const CommonText.labelSmall('Label Small'),
                ],
              ),

              // Special Crypto Examples
              _buildSection(
                'Crypto Styles (Orbitron)',
                [
                  const CommonText.cryptoDisplay('GIGAFAUCET'),
                  const CommonText.cryptoAmount('1,234,567'),
                  const CommonText.button('CLAIM REWARD'),
                ],
              ),

              const SizedBox(height: 24),

              // Usage Example Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.websiteCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.websiteBorder.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText.titleLarge(
                      'Real Usage Example',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const CommonText.cryptoDisplay('BITCOIN REWARDS'),
                    const SizedBox(height: 8),
                    const CommonText.cryptoAmount('0.00234 BTC'),
                    const SizedBox(height: 16),
                    const CommonText.bodyMedium(
                      'You have successfully earned Bitcoin rewards through daily tasks and activities. Continue participating to earn more.',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const CommonText.button('WITHDRAW'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryLight,
                              side: BorderSide(color: AppColors.primaryLight),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const CommonText.button(
                              'HISTORY',
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.websiteCard,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.websiteBorder.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.titleMedium(
            title,
            color: AppColors.primaryLight,
          ),
          const SizedBox(height: 12),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: child,
              )),
        ],
      ),
    );
  }
}
