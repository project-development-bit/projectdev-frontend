import 'package:flutter/material.dart';
import '../core.dart';

/// A showcase widget demonstrating all themed common widgets
class ThemeShowcaseWidget extends StatefulWidget {
  const ThemeShowcaseWidget({super.key});

  @override
  State<ThemeShowcaseWidget> createState() => _ThemeShowcaseWidgetState();
}

class _ThemeShowcaseWidgetState extends State<ThemeShowcaseWidget> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const CommonText.titleLarge('Theme Showcase'),
        backgroundColor:
            isDarkMode ? AppColors.websiteBackground : colorScheme.primary,
        foregroundColor: colorScheme.onError,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography Section
            const CommonText.displayLarge('Typography Examples'),
            const SizedBox(height: 16),
            const CommonText.displayMedium('Display Medium Text'),
            const CommonText.titleLarge('Title Large Text'),
            const CommonText.titleMedium('Title Medium Text'),
            const CommonText.bodyLarge(
                'Body Large - Regular paragraph text using Inter font'),
            const CommonText.bodyMedium('Body Medium - Standard text content'),
            const CommonText.bodySmall('Body Small - Fine print and captions'),
            const CommonText.cryptoDisplay('₿ 0.00123456'),
            const CommonText.cryptoAmount('1,234.56 USDT'),
            const SizedBox(height: 32),

            // Button Section
            const CommonText.titleLarge('Button Examples'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CommonButton(
                  text: 'Primary Button',
                  onPressed: () =>
                      _showSnackBar('Primary button pressed', colorScheme),
                ),
                CommonButton(
                  text: 'Secondary Button',
                  backgroundColor: isDarkMode
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                  onPressed: () =>
                      _showSnackBar('Secondary button pressed', colorScheme),
                ),
                CommonButton(
                  text: 'Outlined Button',
                  isOutlined: true,
                  onPressed: () =>
                      _showSnackBar('Outlined button pressed', colorScheme),
                ),
                CommonButton(
                  text: 'With Icon',
                  icon: Icon(Icons.star, size: 20, color: colorScheme.onError),
                  onPressed: () =>
                      _showSnackBar('Icon button pressed', colorScheme),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // TextField Section
            const CommonText.titleLarge('TextField Examples'),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonTextField(
                    controller: _textController,
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CommonTextField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CommonTextField(
                    labelText: 'Amount',
                    hintText: '0.00',
                    prefixIcon: const Icon(Icons.account_balance_wallet),
                    keyboardType: TextInputType.number,
                    suffixText: 'BTC',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Card Section
            const CommonText.titleLarge('Card Examples'),
            const SizedBox(height: 16),
            CommonCard(
              title: 'Basic Card',
              subtitle: 'This is a basic card with title and subtitle',
              onTap: () => _showSnackBar('Basic card tapped', colorScheme),
              child: const CommonText.bodyMedium(
                'Card content goes here. This card demonstrates the basic styling with website colors and typography.',
              ),
            ),
            const SizedBox(height: 16),
            CryptoCard(
              title: 'Bitcoin Wallet',
              subtitle: 'Main wallet balance',
              amount: '0.00123456',
              currency: 'BTC',
              icon: Icon(Icons.currency_bitcoin, color: colorScheme.secondary),
              onTap: () => _showSnackBar('Crypto card tapped', colorScheme),
            ),
            const SizedBox(height: 16),
            const GradientCard(
              title: 'Gradient Card',
              child: CommonText.bodyMedium(
                'This card uses the website gradient colors for a premium look.',
              ),
            ),
            const SizedBox(height: 32),

            // Container Section
            const CommonText.titleLarge('Container Examples'),
            const SizedBox(height: 16),
            CommonContainer(
              padding: const EdgeInsets.all(20),
              showBorder: true,
              showShadow: true,
              child: const CommonText.bodyMedium(
                'This is a common container with border and shadow.',
              ),
            ),
            const SizedBox(height: 16),
            CryptoContainer(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.trending_up,
                      color: isDarkMode
                          ? AppColors.darkSuccess
                          : AppColors.lightSuccess),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: CommonText.bodyMedium('Crypto-themed container'),
                  ),
                  const CommonText.cryptoAmount('+12.5%'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientContainer(
              padding: EdgeInsets.all(20),
              child: CommonText.bodyMedium(
                'Gradient container with website colors',
                color: colorScheme.onError,
              ),
            ),
            const SizedBox(height: 32),

            // Loading and Error States
            const CommonText.titleLarge('Loading & Error States'),
            const SizedBox(height: 16),
            if (_isLoading) ...[
              const LoadingContainer(
                message: 'Processing transaction...',
                height: 150,
              ),
            ] else ...[
              CommonButton(
                text: 'Show Loading',
                onPressed: () {
                  setState(() => _isLoading = true);
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) setState(() => _isLoading = false);
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            ErrorContainer(
              message:
                  'Failed to load data. Please check your internet connection.',
              onRetry: () => _showSnackBar('Retry button pressed', colorScheme),
            ),
            const SizedBox(height: 32),

            // Image Widget Section
            const CommonText.titleLarge('Image Widget Examples'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CommonImage(
                    imageUrl: 'https://via.placeholder.com/150',
                    width: 150,
                    height: 150,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CommonImage(
                    imageUrl: 'https://invalid-url.com/image.jpg',
                    width: 150,
                    height: 150,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, ColorScheme colorScheme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonText.bodyMedium(message, color: colorScheme.onError),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.primaryLight
            : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
