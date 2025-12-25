import 'package:gigafaucet/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/common/common_text.dart';
import '../../core/theme/app_colors.dart';
import 'presentation/providers/terms_privacy_provider.dart';

/// Example usage of Terms & Privacy feature
/// You can integrate this into your existing settings page or footer
class TermsPrivacyExample extends ConsumerWidget {
  const TermsPrivacyExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          'Legal Documents',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CommonText(
              'Legal Information',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CommonText(
              'Please review our terms and privacy policy.',
              fontSize: 14,
              color: AppColors.darkTextTertiary,
            ),
            const SizedBox(height: 32),

            // Terms of Service Button
            ElevatedButton.icon(
              onPressed: () {
                context.goNamed(AppRoutes.terms);
              },
              icon: const Icon(Icons.article_outlined),
              label: const Text('Terms of Service'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Privacy Policy Button
            ElevatedButton.icon(
              onPressed: () {
                context.goNamed(AppRoutes.privacy);
              },
              icon: const Icon(Icons.privacy_tip_outlined),
              label: const Text('Privacy Policy'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 32),

            // Status indicator
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(termsPrivacyNotifierProvider);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          'Status',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        _buildStatusIndicator(
                            state, Theme.of(context).colorScheme),
                        if (state is TermsPrivacySuccess) ...[
                          const SizedBox(height: 12),
                          _buildVersionInfo(state.data),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
      TermsPrivacyState state, ColorScheme colorScheme) {
    return switch (state) {
      TermsPrivacyInitial() => const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.info),
            SizedBox(width: 8),
            CommonText('Not loaded', color: AppColors.info),
          ],
        ),
      TermsPrivacyLoading() => Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            CommonText('Loading...', color: colorScheme.primary),
          ],
        ),
      TermsPrivacySuccess() => Row(
          children: [
            Icon(Icons.check_circle_outline, color: AppColors.success),
            SizedBox(width: 8),
            CommonText('Ready', color: AppColors.success),
          ],
        ),
      TermsPrivacyError(message: final message) => Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: CommonText(
                'Error: $message',
                color: colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
        ),
    };
  }

  Widget _buildVersionInfo(dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          'Terms Version: ${data.termsVersion}',
          fontSize: 12,
          color: AppColors.darkTextTertiary,
        ),
        const SizedBox(height: 4),
        CommonText(
          'Privacy Version: ${data.privacyVersion}',
          fontSize: 12,
          color: AppColors.darkTextTertiary,
        ),
      ],
    );
  }
}

/// Quick access buttons for footer or settings
class TermsPrivacyQuickAccess extends StatelessWidget {
  const TermsPrivacyQuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            context.goNamed(AppRoutes.terms);
          },
          child: const Text('Terms'),
        ),
        const Text('•'),
        TextButton(
          onPressed: () {
            context.goNamed(AppRoutes.privacy);
          },
          child: const Text('Privacy'),
        ),
      ],
    );
  }
}
