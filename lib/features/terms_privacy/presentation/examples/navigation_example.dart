import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/terms_privacy_navigation_service.dart';

/// Example widget showing how to use the Terms & Privacy navigation service
/// 
/// This service automatically handles platform differences:
/// - Web: Opens URLs in new tabs
/// - Mobile: Shows WebView screens
class TermsPrivacyNavigationExample extends ConsumerWidget {
  const TermsPrivacyNavigationExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Privacy Navigation Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Platform info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Platform Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Current Platform: ${kIsWeb ? 'Web' : 'Mobile'}'),
                    const SizedBox(height: 4),
                    Text(
                      kIsWeb 
                        ? 'URLs will open in new browser tabs'
                        : 'URLs will open in WebView screens',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Example buttons
            const Text(
              'Navigation Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 16),
            
            // Method 1: Using the extension methods
            ElevatedButton.icon(
              onPressed: () => context.showTerms(ref),
              icon: const Icon(Icons.article),
              label: const Text('Show Terms of Service'),
            ),
            
            const SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: () => context.showPrivacy(ref),
              icon: const Icon(Icons.privacy_tip),
              label: const Text('Show Privacy Policy'),
            ),
            
            const SizedBox(height: 24),
            
            // Method 2: Using the service directly
            const Text(
              'Alternative Usage (Direct Service Call):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: () => TermsPrivacyNavigationService.showTerms(context, ref),
              icon: const Icon(Icons.article_outlined),
              label: const Text('Terms (Direct Service)'),
            ),
            
            const SizedBox(height: 8),
            
            OutlinedButton.icon(
              onPressed: () => TermsPrivacyNavigationService.showPrivacy(context, ref),
              icon: const Icon(Icons.privacy_tip_outlined),
              label: const Text('Privacy (Direct Service)'),
            ),
            
            const SizedBox(height: 24),
            
            // Usage instructions
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usage Instructions:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '1. Import the navigation service:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "import '../services/terms_privacy_navigation_service.dart';",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '2. Use extension methods (recommended):',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "onPressed: () => context.showTerms(ref)\n"
                          "onPressed: () => context.showPrivacy(ref)",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '3. Or use service directly:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "TermsPrivacyNavigationService.showTerms(context, ref)",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}