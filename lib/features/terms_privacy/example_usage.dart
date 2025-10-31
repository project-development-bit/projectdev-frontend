import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/common/common_text.dart';
import 'presentation/screens/terms_screen.dart';
import 'presentation/screens/privacy_screen.dart';
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
            const CommonText(
              'Please review our terms and privacy policy.',
              fontSize: 14,
              color: Colors.grey,
            ),
            const SizedBox(height: 32),
            
            // Terms of Service Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TermsScreen(),
                  ),
                );
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyScreen(),
                  ),
                );
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
                        _buildStatusIndicator(state),
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

  Widget _buildStatusIndicator(TermsPrivacyState state) {
    return switch (state) {
      TermsPrivacyInitial() => const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            CommonText('Not loaded', color: Colors.blue),
          ],
        ),
      TermsPrivacyLoading() => const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            CommonText('Loading...', color: Colors.orange),
          ],
        ),
      TermsPrivacySuccess() => const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 8),
            CommonText('Ready', color: Colors.green),
          ],
        ),
      TermsPrivacyError(message: final message) => Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: CommonText(
                'Error: $message',
                color: Colors.red,
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
          color: Colors.grey,
        ),
        const SizedBox(height: 4),
        CommonText(
          'Privacy Version: ${data.privacyVersion}',
          fontSize: 12,
          color: Colors.grey,
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TermsScreen(),
              ),
            );
          },
          child: const Text('Terms'),
        ),
        const Text('•'),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PrivacyScreen(),
              ),
            );
          },
          child: const Text('Privacy'),
        ),
      ],
    );
  }
}