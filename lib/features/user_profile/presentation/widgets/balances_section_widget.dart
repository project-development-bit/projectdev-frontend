import 'package:flutter/material.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user_profile.dart';

/// Balance card widget for displaying currency balances
class BalanceCardWidget extends StatelessWidget {
  final String amount;
  final String currency;
  final Color iconColor;
  final IconData icon;

  const BalanceCardWidget({
    super.key,
    required this.amount,
    required this.currency,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          CommonText.titleMedium(
            amount,
            color: context.onSurface,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          CommonText.bodySmall(
            currency,
            color: context.onSurface.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}

/// Balances section widget containing all balance cards and withdraw button
class BalancesSectionWidget extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onWithdraw;

  const BalancesSectionWidget({
    super.key,
    required this.profile,
    this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context),
        const SizedBox(height: 16),
        _buildFirstRow(context),
        const SizedBox(height: 12),
        _buildSecondRow(context),
        const SizedBox(height: 16),
        _buildWithdrawButton(context),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return CommonText.titleMedium(
      'Balances',
      color: context.onSurface,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildFirstRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BalanceCardWidget(
            amount: '1,000',
            currency: 'Coins',
            iconColor: context.primary,
            icon: Icons.monetization_on,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BalanceCardWidget(
            amount: '\$${(profile.stats?.totalEarnings ?? 0.0).toStringAsFixed(1)}',
            currency: 'Earnings',
            iconColor: context.secondary,
            icon: Icons.currency_bitcoin,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BalanceCardWidget(
            amount: '0.00000001',
            currency: 'BTC',
            iconColor: context.tertiary,
            icon: Icons.currency_bitcoin,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BalanceCardWidget(
            amount: 'N/A',
            currency: 'Ethereum',
            iconColor: context.onSurface.withOpacity(0.6),
            icon: Icons.diamond,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BalanceCardWidget(
            amount: 'N/A',
            currency: 'Litecoin',
            iconColor: context.onSurface.withOpacity(0.8),
            icon: Icons.monetization_on,
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onWithdraw,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: CommonText.titleMedium(
          'Withdraw Earnings',
          color: context.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}