import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// Example widget demonstrating how to use text theme extensions
class TextThemeExampleWidget extends StatelessWidget {
  const TextThemeExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Text Theme Examples',
          style: context.titleLarge, // Using extension instead of Theme.of(context).textTheme.titleLarge
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display styles
            _buildSection(
              context,
              'Display Styles',
              [
                _buildTextExample(context, 'Display Large', context.displayLarge),
                _buildTextExample(context, 'Display Medium', context.displayMedium),
                _buildTextExample(context, 'Display Small', context.displaySmall),
              ],
            ),

            // Headline styles
            _buildSection(
              context,
              'Headline Styles',
              [
                _buildTextExample(context, 'Headline Large', context.headlineLarge),
                _buildTextExample(context, 'Headline Medium', context.headlineMedium),
                _buildTextExample(context, 'Headline Small', context.headlineSmall),
              ],
            ),

            // Title styles
            _buildSection(
              context,
              'Title Styles',
              [
                _buildTextExample(context, 'Title Large', context.titleLarge),
                _buildTextExample(context, 'Title Medium', context.titleMedium),
                _buildTextExample(context, 'Title Small', context.titleSmall),
              ],
            ),

            // Body styles
            _buildSection(
              context,
              'Body Styles',
              [
                _buildTextExample(context, 'Body Large', context.bodyLarge),
                _buildTextExample(context, 'Body Medium', context.bodyMedium),
                _buildTextExample(context, 'Body Small', context.bodySmall),
              ],
            ),

            // Label styles
            _buildSection(
              context,
              'Label Styles',
              [
                _buildTextExample(context, 'Label Large', context.labelLarge),
                _buildTextExample(context, 'Label Medium', context.labelMedium),
                _buildTextExample(context, 'Label Small', context.labelSmall),
              ],
            ),

            // Color examples
            _buildSection(
              context,
              'Color Examples',
              [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.primaryContainer, // Using extension
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Primary Container with OnPrimaryContainer text',
                    style: context.bodyMedium?.copyWith(
                      color: context.onPrimaryContainer, // Using extension
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.secondaryContainer, // Using extension
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Secondary Container with OnSecondaryContainer text',
                    style: context.bodyMedium?.copyWith(
                      color: context.onSecondaryContainer, // Using extension
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.surface, // Using extension
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.outline), // Using extension
                  ),
                  child: Text(
                    'Surface with OnSurface text',
                    style: context.bodyMedium?.copyWith(
                      color: context.onSurface, // Using extension
                    ),
                  ),
                ),
              ],
            ),

            // Responsive examples
            _buildSection(
              context,
              'Responsive Examples',
              [
                Text(
                  'Is Mobile: ${context.isMobile}', // Using extension
                  style: context.bodyMedium,
                ),
                Text(
                  'Is Tablet: ${context.isTablet}', // Using extension
                  style: context.bodyMedium,
                ),
                Text(
                  'Is Desktop: ${context.isDesktop}', // Using extension
                  style: context.bodyMedium,
                ),
                Text(
                  'Screen Width: ${context.screenWidth.toStringAsFixed(1)}', // Using extension
                  style: context.bodyMedium,
                ),
                Text(
                  'Screen Height: ${context.screenHeight.toStringAsFixed(1)}', // Using extension
                  style: context.bodyMedium,
                ),
                Text(
                  'Is Dark Theme: ${context.isDark}', // Using extension
                  style: context.bodyMedium,
                ),
              ],
            ),

            // Button examples
            _buildSection(
              context,
              'Button Examples',
              [
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.showSuccessSnackBar(
                      message: 'Success message using extension!',
                    );
                  },
                  child: const Text('Show Success SnackBar'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    context.showErrorSnackBar(
                      message: 'Error message using extension!',
                    );
                  },
                  child: const Text('Show Error SnackBar'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.showWarningSnackBar(
                      message: 'Warning message using extension!',
                    );
                  },
                  child: const Text('Show Warning SnackBar'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    context.showConfirmDialog(
                      title: 'Confirm Action',
                      content: 'Are you sure you want to continue?',
                    );
                  },
                  child: const Text('Show Confirm Dialog'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: context.headlineSmall?.copyWith(
            color: context.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextExample(BuildContext context, String label, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.labelSmall?.copyWith(
              color: context.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: style,
          ),
        ],
      ),
    );
  }
}

/// Usage examples in code comments:
/// 
/// Instead of writing:
/// ```dart
/// Text(
///   'Hello World',
///   style: Theme.of(context).textTheme.bodyLarge,
/// )
/// ```
/// 
/// You can now write:
/// ```dart
/// Text(
///   'Hello World',
///   style: context.bodyLarge,
/// )
/// ```
/// 
/// Color examples:
/// ```dart
/// Container(
///   color: context.primary,           // Instead of Theme.of(context).colorScheme.primary
///   child: Text(
///     'Primary text',
///     style: context.bodyMedium?.copyWith(
///       color: context.onPrimary,     // Instead of Theme.of(context).colorScheme.onPrimary
///     ),
///   ),
/// )
/// ```
/// 
/// Media query examples:
/// ```dart
/// if (context.isMobile) {           // Instead of MediaQuery.of(context).size.width < 768
///   // Mobile layout
/// } else if (context.isTablet) {   // Instead of checking width ranges
///   // Tablet layout
/// } else {
///   // Desktop layout
/// }
/// ```
/// 
/// Navigation examples:
/// ```dart
/// context.pop();                    // Instead of Navigator.of(context).pop()
/// context.push(MaterialPageRoute(  // Instead of Navigator.of(context).push()
///   builder: (context) => MyPage(),
/// ));
/// ```
/// 
/// Dialog and SnackBar examples:
/// ```dart
/// context.showAlertDialog(          // Instead of showDialog()
///   title: 'Alert',
///   content: 'This is an alert',
/// );
/// 
/// context.showSnackBar(             // Instead of ScaffoldMessenger.of(context).showSnackBar()
///   message: 'Hello SnackBar',
/// );
/// ```