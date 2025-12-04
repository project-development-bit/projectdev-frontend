import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/extensions/int_extensions.dart';
import 'package:cointiply_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String number;
  final String totalEarn;

  const StatCard({
    super.key,
    required this.title,
    required this.number,
    required this.totalEarn,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      margin: EdgeInsets.only(bottom: isMobile ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff333333)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = context.isMobile;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              CommonText.titleMedium(
                title,
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
              ),

              const SizedBox(height: 8),

              isMobile
                  ? _buildColumnLayout(
                      context,
                      colorScheme,
                    )
                  : _buildRowLayout(
                      context,
                      colorScheme,
                    ),
            ],
          );
        },
      ),
    );
  }

  // =====================
  // MOBILE VERSION
  // Stacked layout
  // =====================
  Widget _buildColumnLayout(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 85,
              child: CommonText.bodyMedium(
                context.translate('number'),
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
                color: colorScheme.onSecondary,
              ),
            ),
            const SizedBox(width: 24),
            _buildNumberBadge(colorScheme, number, true),
          ],
        ),
        const SizedBox(height: 8),
        // Total Earn
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 80,
              child: CommonText.bodyMedium(
                context.translate('total_earn'),
                fontWeight: FontWeight.w700,
                color: colorScheme.onSecondary,
              ),
            ),
            const SizedBox(width: 24),
            _buildEarnBadge(colorScheme, totalEarn, true),
          ],
        ),
      ],
    );
  }

  // =====================
  // 🖥️ DESKTOP / TABLET
  // Row layout
  // =====================
  Widget _buildRowLayout(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Row(
          children: [
            CommonText.bodyLarge(
              context.translate('number'),
              fontWeight: FontWeight.w700,
              color: colorScheme.onSecondary,
            ),
            const SizedBox(width: 24),
            _buildNumberBadge(colorScheme, number, false),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            CommonText.bodyLarge(
              context.translate('total_earn'),
              fontWeight: FontWeight.w700,
              color: colorScheme.onSecondary,
            ),
            const SizedBox(width: 24),
            _buildEarnBadge(colorScheme, totalEarn, false),
          ],
        ),
      ],
    );
  }

  // Small widgets reused in both versions
  Widget _buildNumberBadge(
      ColorScheme colorScheme, String value, bool isMobile) {
    return Container(
      alignment: Alignment.center,
      width: isMobile ? null : 120,
      height: 40,
      constraints: BoxConstraints(
        minWidth: isMobile ? 150 : 0,
      ),
      decoration: BoxDecoration(
        color: Color(0xff100E1C),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0x83333333), //TODO: Replace with theme color
          width: 1.2,
        ),
      ),
      child: CommonText.titleLarge(
        (int.tryParse(value) ?? 0).currencyFormat(),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildEarnBadge(ColorScheme colorScheme, String value, bool isMobile) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      constraints: BoxConstraints(
        minWidth: 150,
      ),
      decoration: BoxDecoration(
        color: Color(0xff100E1C),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0x83333333), //TODO: Replace with theme color
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonText.titleLarge(
            (int.tryParse(value) ?? 0).currencyFormat(),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
          const SizedBox(width: 5),
          Image(
            image: const AssetImage("assets/images/rewards/coin.png"),
            width: 20,
          ),
        ],
      ),
    );
  }
}
