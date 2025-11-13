import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/widgets/recaptcha_widget.dart';
import '../core/providers/recaptcha_provider.dart';
import '../core/config/flavor_manager.dart';

/// Debug page to test reCAPTCHA widget visibility
class RecaptchaDebugPage extends ConsumerWidget {
  const RecaptchaDebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recaptchaState = ref.watch(recaptchaNotifierProvider);
    final isRequired = ref.watch(isRecaptchaRequiredProvider);
    final isVerified = ref.watch(isRecaptchaVerifiedProvider);
    final isLoading = ref.watch(isRecaptchaLoadingProvider);
    final errorMessage = ref.watch(recaptchaErrorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('reCAPTCHA Debug'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: colorScheme.onError,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuration Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Current Flavor: ${FlavorManager.currentConfig.flavor}'),
                    Text(
                        'Site Key: ${FlavorManager.currentConfig.recaptchaSiteKey ?? "Not configured"}'),
                    Text(
                        'Site Key Configured: ${FlavorManager.currentConfig.recaptchaSiteKey != null}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // State Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'reCAPTCHA State',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('State Type: ${recaptchaState.runtimeType}'),
                    Text('Is Required: $isRequired'),
                    Text('Is Verified: $isVerified'),
                    Text('Is Loading: $isLoading'),
                    Text('Error: ${errorMessage ?? "None"}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Widget Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'reCAPTCHA Widget',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const RecaptchaWidget(
                      enabled: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Manual Test Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final notifier =
                        ref.read(recaptchaNotifierProvider.notifier);
                    notifier.verify();
                  },
                  child: const Text('Test Verify'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final notifier =
                        ref.read(recaptchaNotifierProvider.notifier);
                    notifier.reset();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
