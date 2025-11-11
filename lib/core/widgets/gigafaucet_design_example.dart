import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Example widget demonstrating the Gigafaucet design system usage
/// This widget shows how to properly implement the website-inspired design
class GigafaucetDesignExample extends StatelessWidget {
  const GigafaucetDesignExample({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.websiteBackground,
      appBar: AppBar(
        title: Text(
          'Gigafaucet Design',
          style: AppTypography.titleLarge.copyWith(color: colorScheme.onError),
        ),
        backgroundColor: AppColors.websiteCard,
        iconTheme: IconThemeData(color: colorScheme.onError),
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
              // Hero Section
              _buildHeroSection(colorScheme),
              const SizedBox(height: 24),

              // Stats Cards
              _buildStatsSection(),
              const SizedBox(height: 24),

              // Crypto Rewards Section
              _buildCryptoSection(colorScheme),
              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(colorScheme),
              const SizedBox(height: 24),

              // Website-style Form
              _buildFormExample(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.websiteCard,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.websiteBorder.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.scrim.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Welcome to Gigafaucet',
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.primaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Earn cryptocurrency rewards daily',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.websiteText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Level 19 • Pro User',
              style: AppTypography.labelMedium.copyWith(
                color: colorScheme.onError,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
            child: _buildStatCard('Total Earned', '14,212,568',
                AppColors.websiteGold, Icons.monetization_on)),
        const SizedBox(width: 12),
        Expanded(
            child: _buildStatCard('Daily Bonus', '1,000',
                AppColors.primaryLight, Icons.card_giftcard)),
        const SizedBox(width: 12),
        Expanded(
            child: _buildStatCard(
                'Referrals', '47', AppColors.websiteAccent, Icons.people)),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.websiteCard,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.websiteBorder.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoSection(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.websiteCard,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.websiteBorder.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crypto Rewards',
            style: AppTypography.headlineSmall
                .copyWith(color: colorScheme.onError),
          ),
          const SizedBox(height: 16),
          _buildCryptoRow(
              'Bitcoin', 'BTC', '0.00234', AppColors.bitcoin, colorScheme),
          const SizedBox(height: 12),
          _buildCryptoRow(
              'Ethereum', 'ETH', '0.1456', AppColors.ethereum, colorScheme),
          const SizedBox(height: 12),
          _buildCryptoRow('Gigafaucet Token', 'GFT', '1,250',
              AppColors.websiteGold, colorScheme),
        ],
      ),
    );
  }

  Widget _buildCryptoRow(String name, String symbol, String amount, Color color,
      ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              symbol[0],
              style: AppTypography.titleMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.bodyMedium
                    .copyWith(color: colorScheme.onError),
              ),
              Text(
                symbol,
                style: AppTypography.captionText,
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: AppTypography.cryptoAmount.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: colorScheme.onError,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Claim Reward',
              style: AppTypography.buttonText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryLight,
              side: BorderSide(color: AppColors.primaryLight, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'View History',
              style: AppTypography.buttonText.copyWith(
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormExample(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.websiteCard,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.websiteBorder.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Withdraw Funds',
            style:
                AppTypography.titleLarge.copyWith(color: colorScheme.onError),
          ),
          const SizedBox(height: 16),
          TextFormField(
            style:
                AppTypography.bodyMedium.copyWith(color: colorScheme.onError),
            decoration: InputDecoration(
              labelText: 'Wallet Address',
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.websiteText,
              ),
              hintText: 'Enter your wallet address',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.websiteText.withValues(alpha: 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.websiteBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.websiteBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
              ),
              filled: true,
              fillColor: AppColors.websiteBackground,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            style:
                AppTypography.bodyMedium.copyWith(color: colorScheme.onError),
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.websiteText,
              ),
              hintText: '0.00',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.websiteText.withValues(alpha: 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.websiteBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.websiteBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
              ),
              filled: true,
              fillColor: AppColors.websiteBackground,
              suffixText: 'BTC',
              suffixStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.bitcoin,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.websiteGold,
                foregroundColor: colorScheme.scrim,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Withdraw',
                style:
                    AppTypography.buttonText.copyWith(color: colorScheme.scrim),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
