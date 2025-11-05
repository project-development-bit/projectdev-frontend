import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/core/widgets/responsive_container.dart';
import 'package:flutter/material.dart';

class BalanceSection extends StatelessWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final isMobile = context.isMobile;

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            CommonText.titleLarge(
              'Balances',
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Divider(color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 20),

            // ─── Balances Layout ────────────────────────────────
            if (isDesktop)
              _buildDesktopLayout(context, colorScheme)
            else if (isTablet)
              _buildTabletLayout(context, colorScheme)
            else
              _buildMobileLayout(context, colorScheme),

            const SizedBox(height: 20),

            // Info text
            CommonText.labelSmall(
              'Balances updated every 10~ minutes. Only includes past 90 days.',
              color: colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 20),

            // Withdraw button
            Align(
              alignment: isMobile ? Alignment.center : Alignment.centerLeft,
              child: SizedBox(
                width: isMobile ? double.infinity : 220,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    debugPrint('Withdraw Earnings button pressed');
                  },
                  child: CommonText.labelSmall(
                    'Withdraw Earnings',
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Desktop Layout (2 rows of balance boxes)
  Widget _buildDesktopLayout(BuildContext context, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First row group
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildBalanceBox(
                  context, 'Coin Balance', '100', colorScheme.primary),
              _buildEqualSign(context),
              _buildBalanceBox(
                  context, 'USD Balance', '\$0.01', colorScheme.primary),
              _buildEqualSign(context),
              _buildBalanceBox(
                  context, 'BTC Balance', '0.00000010', colorScheme.primary),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Second row group
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.end,
            children: [
              _buildBalanceBox(
                  context, 'Interest Earned', 'N/A', colorScheme.primary),
              _buildBalanceBox(
                  context, 'Coins Today', 'N/A', colorScheme.primary),
              _buildBalanceBox(
                  context, 'Coins Last 7 Days', 'N/A', colorScheme.primary),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Tablet Layout (1 row, scrollable if overflow)
  Widget _buildTabletLayout(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildBalanceBox(context, 'Coin Balance', '100', colorScheme.primary),
          const SizedBox(width: 12),
          _buildEqualSign(context),
          const SizedBox(width: 12),
          _buildBalanceBox(
              context, 'USD Balance', '\$0.01', colorScheme.primary),
          const SizedBox(width: 12),
          _buildEqualSign(context),
          const SizedBox(width: 12),
          _buildBalanceBox(
              context, 'BTC Balance', '0.00000010', colorScheme.primary),
          const SizedBox(width: 12),
          _buildBalanceBox(
              context, 'Interest Earned', 'N/A', colorScheme.primary),
          const SizedBox(width: 12),
          _buildBalanceBox(context, 'Coins Today', 'N/A', colorScheme.primary),
          const SizedBox(width: 12),
          _buildBalanceBox(
              context, 'Coins Last 7 Days', 'N/A', colorScheme.primary),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Mobile Layout (stacked vertically)
  Widget _buildMobileLayout(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildBalanceBox(context, 'Coin Balance', '100', colorScheme.primary),
        const SizedBox(height: 8),
        _buildEqualSign(context),
        const SizedBox(height: 8),
        _buildBalanceBox(context, 'USD Balance', '\$0.01', colorScheme.primary),
        const SizedBox(height: 8),
        _buildEqualSign(context),
        const SizedBox(height: 8),
        _buildBalanceBox(
            context, 'BTC Balance', '0.00000010', colorScheme.primary),
        const SizedBox(height: 16),
        _buildBalanceBox(
            context, 'Interest Earned', 'N/A', colorScheme.primary),
        const SizedBox(height: 8),
        _buildBalanceBox(context, 'Coins Today', 'N/A', colorScheme.primary),
        const SizedBox(height: 8),
        _buildBalanceBox(
            context, 'Coins Last 7 Days', 'N/A', colorScheme.primary),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  Widget _buildBalanceBox(
      BuildContext context, String title, String value, Color color) {
    return Container(
      width: 150,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.25), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonText.titleMedium(
            value,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          CommonText.labelSmall(
            title,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildEqualSign(BuildContext context) {
    return CommonText.titleLarge(
      '=',
      color: Colors.grey[400],
      fontWeight: FontWeight.bold,
    );
  }
}
