import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Development widget to showcase Gigafaucet website colors and typography
/// Use this widget to visualize and test the color scheme
class ColorPaletteShowcase extends StatelessWidget {
  const ColorPaletteShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.websiteBackground,
      appBar: AppBar(
        title: Text(
          'Gigafaucet Design System',
          style:
              AppTypography.headlineSmall.copyWith(color: colorScheme.onError),
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
              _buildTypographySection(context),
              const SizedBox(height: 24),
              _buildSection('Primary Website Colors', [
                _ColorItem('Primary Orange', AppColors.primary),
                _ColorItem('Primary Dark', AppColors.primaryDark),
                _ColorItem('Primary Light', AppColors.primaryLight),
                _ColorItem('Website Gold', AppColors.websiteGold),
              ]),
              _buildSection('Website Backgrounds', [
                _ColorItem('Background Dark', AppColors.websiteBackground),
                _ColorItem(
                    'Background Start', AppColors.websiteBackgroundStart),
                _ColorItem('Background End', AppColors.websiteBackgroundEnd),
                _ColorItem('Card Background', AppColors.websiteCard),
              ]),
              _buildSection('Website Text & Accents', [
                _ColorItem('Website Text', AppColors.websiteText),
                _ColorItem('Website Accent', AppColors.websiteAccent),
                _ColorItem('Website Border', AppColors.websiteBorder),
              ]),
              _buildSection('Cryptocurrency Colors', [
                _ColorItem('Bitcoin', AppColors.bitcoin),
                _ColorItem('Ethereum', AppColors.ethereum),
                _ColorItem('Gold Reward', AppColors.websiteGold),
                _ColorItem('Silver Reward', AppColors.silver),
              ]),
              _buildSection('Status Colors', [
                _ColorItem('Success', AppColors.success),
                _ColorItem('Warning', AppColors.warning),
                _ColorItem('Error', AppColors.error),
              ]),
              _buildSection('Gradient Examples', [
                _GradientItem('Website Background', [
                  AppColors.websiteBackgroundStart,
                  AppColors.websiteBackgroundEnd,
                ]),
                _GradientItem('Primary Gradient', [
                  AppColors.primaryLight,
                  AppColors.primary,
                ]),
                _GradientItem('Gold Gradient', [
                  AppColors.websiteGold,
                  AppColors.primaryLight,
                ]),
              ]),
              const SizedBox(height: 24),
              _buildWebsiteStyleCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypographySection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            'Typography System',
            style: AppTypography.headlineMedium
                .copyWith(color: colorScheme.onError),
          ),
          const SizedBox(height: 16),
          Text(
            'Orbitron Title Font',
            style: AppTypography.displaySmall
                .copyWith(color: AppColors.primaryLight),
          ),
          const SizedBox(height: 8),
          Text(
            'This is the main title font used for headers, buttons, and crypto displays.',
            style:
                AppTypography.bodyLarge.copyWith(color: AppColors.websiteText),
          ),
          const SizedBox(height: 16),
          Text(
            'Barlow Body Font',
            style:
                AppTypography.titleLarge.copyWith(color: colorScheme.onError),
          ),
          const SizedBox(height: 8),
          Text(
            'This is the body font used for normal text, descriptions, and content.',
            style:
                AppTypography.bodyMedium.copyWith(color: AppColors.websiteText),
          ),
          const SizedBox(height: 16),
          Text(
            'Special Effects',
            style: AppTypography.cryptoDisplay,
          ),
          const SizedBox(height: 8),
          Text(
            '+1,000',
            style: AppTypography.cryptoAmount,
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteStyleCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.websiteGold, width: 3),
                ),
                child: Icon(Icons.monetization_on,
                    color: colorScheme.onError, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gigafaucet Style Card',
                      style: AppTypography.titleLarge
                          .copyWith(color: colorScheme.onError),
                    ),
                    Text(
                      'Website-inspired design',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.websiteText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: AppColors.websiteBorder,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Rewards', '14,212,568', AppColors.websiteGold),
              _buildStatItem('Level', '19', AppColors.primaryLight),
              _buildStatItem('Rank', 'Pro', AppColors.websiteAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.captionText,
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.primaryLight,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ColorItem extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorItem(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = color.computeLuminance() > 0.5
        ? colorScheme.scrim
        : colorScheme.onError;
    final hexColor =
        '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.websiteBorder.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.scrim.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppTypography.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              hexColor,
              style: AppTypography.monospace.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientItem extends StatelessWidget {
  final String name;
  final List<Color> colors;

  const _GradientItem(this.name, this.colors);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.websiteBorder.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.scrim.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name,
          style: AppTypography.titleMedium.copyWith(
            color: colorScheme.onError,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: colorScheme.scrim.withValues(alpha: 0.26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
