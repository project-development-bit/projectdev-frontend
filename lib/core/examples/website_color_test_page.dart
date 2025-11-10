import 'package:flutter/material.dart';
import '../core.dart';

/// Example page showing how the website colors are applied to common widgets
class WebsiteColorTestPage extends StatelessWidget {
  const WebsiteColorTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const CommonText.titleLarge('Website Colors Test'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme info
            CommonCard(
              title: 'Current Theme',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.bodyMedium(
                      'Theme Mode: ${isDark ? 'Dark' : 'Light'}'),
                  const SizedBox(height: 8),
                  CommonText.bodySmall(
                      'The buttons and fields below should show Gigafaucet website colors automatically.'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Color demonstration
            const CommonText.titleMedium('Theme Colors in Action'),
            const SizedBox(height: 16),

            // Buttons showing theme colors
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CommonButton(
                  text: 'Primary Button',
                  onPressed: () {},
                ),
                CommonButton(
                  text: 'Secondary',
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {},
                ),
                CommonButton(
                  text: 'Outlined',
                  isOutlined: true,
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Text fields showing theme colors
            const CommonText.titleMedium('Text Fields'),
            const SizedBox(height: 16),

            Column(
              children: [
                const CommonTextField(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                const CommonTextField(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Cards showing theme colors
            const CommonText.titleMedium('Cards and Containers'),
            const SizedBox(height: 16),

            // Regular card
            CommonCard(
              title: 'Regular Card',
              subtitle: 'Uses theme surface colors',
              child: const CommonText.bodyMedium(
                'This card automatically adapts to light/dark theme using website colors.',
              ),
            ),

            const SizedBox(height: 16),

            // Crypto card
            CryptoCard(
              title: 'Bitcoin Balance',
              amount: '0.00123456',
              currency: 'BTC',
              icon: const Icon(Icons.currency_bitcoin, color: Colors.orange),
              subtitle: 'Main wallet',
            ),

            const SizedBox(height: 16),

            // Gradient card
            const GradientCard(
              title: 'Gradient Card',
              child: CommonText.bodyMedium(
                'This uses the website gradient colors.',
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Color palette display
            const CommonText.titleMedium('Website Color Palette'),
            const SizedBox(height: 16),

            CommonCard(
              child: Column(
                children: [
                  _ColorSwatch(
                      'Primary', Theme.of(context).colorScheme.primary),
                  _ColorSwatch(
                      'Secondary', Theme.of(context).colorScheme.secondary),
                  _ColorSwatch(
                      'Surface', Theme.of(context).colorScheme.surface),
                  _ColorSwatch('Primary Container',
                      Theme.of(context).colorScheme.primaryContainer),
                  _ColorSwatch('Error', Theme.of(context).colorScheme.error),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorSwatch(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonText.bodyMedium(name),
          ),
          CommonText.bodySmall(
            color.value.toRadixString(16).toUpperCase().padLeft(8, '0'),
          ),
        ],
      ),
    );
  }
}
