import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/presentation/providers/app_settings_theme_provider.dart';
import '../widgets/dynamic_banners_widget.dart';

/// Example page demonstrating dynamic theme features
class DynamicThemeExamplePage extends ConsumerWidget {
  const DynamicThemeExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appSettingsThemeProvider);
    final colors = ref.watch(currentAppThemeColorsProvider);
    final typography = ref.watch(appTypographyConfigProvider);
    final fonts = ref.watch(appFontsConfigProvider);
    final texts = ref.watch(appTextsConfigProvider);
    final banners = ref.watch(appBannersConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Theme Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(appSettingsThemeProvider.notifier).refreshThemeConfig();
            },
            tooltip: 'Refresh Theme',
          ),
        ],
      ),
      body: themeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : themeState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${themeState.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(appSettingsThemeProvider.notifier).refreshThemeConfig();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Config Info Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Theme Configuration',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Version: ${themeState.config?.configVersion ?? 'N/A'}'),
                              Text('Color Scheme: ${themeState.config?.colorScheme ?? 'N/A'}'),
                              Text('Heading Font: ${fonts?.heading ?? 'N/A'}'),
                              Text('Body Font: ${fonts?.body ?? 'N/A'}'),
                              Text('Banners: ${banners.length}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dynamic Banners
                      if (banners.isNotEmpty) ...[
                        const Text(
                          'Dynamic Banners',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const DynamicBannersCarousel(height: 150),
                        const SizedBox(height: 24),
                      ],

                      // Typography Examples
                      const Text(
                        'Typography Examples',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // H1
                      if (typography != null)
                        Text(
                          'H1: ${texts?.homeTitle ?? 'Main Heading'}',
                          style: TextStyle(
                            fontSize: typography.h1.fontSizeValue,
                            fontWeight: typography.h1.fontWeightValue,
                            color: colors?.heading.firstColor,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // H2
                      if (typography != null)
                        Text(
                          'H2: Sub Heading',
                          style: TextStyle(
                            fontSize: typography.h2.fontSizeValue,
                            fontWeight: typography.h2.fontWeightValue,
                            color: colors?.heading.secondColor,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // H3
                      if (typography != null)
                        Text(
                          'H3: Section Title',
                          style: TextStyle(
                            fontSize: typography.h3.fontSizeValue,
                            fontWeight: typography.h3.fontWeightValue,
                            color: colors?.heading.thirdColor,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Body
                      if (typography != null)
                        Text(
                          'Body: This is a paragraph text example demonstrating the body typography style from the server configuration.',
                          style: TextStyle(
                            fontSize: typography.body.fontSizeValue,
                            fontWeight: typography.body.fontWeightValue,
                            color: colors?.paragraph.firstColor,
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Color Examples
                      const Text(
                        'Color Palette',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (colors != null) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _ColorBox(
                              label: 'Primary',
                              color: colors.primaryColor,
                            ),
                            _ColorBox(
                              label: 'Secondary',
                              color: colors.secondaryColor,
                            ),
                            _ColorBox(
                              label: 'Border',
                              color: colors.borderColor,
                            ),
                            _ColorBox(
                              label: 'Button',
                              color: colors.buttonColor,
                            ),
                            _ColorBox(
                              label: 'Info',
                              color: colors.status.infoColor,
                            ),
                            _ColorBox(
                              label: 'Success',
                              color: colors.status.successColor,
                            ),
                            _ColorBox(
                              label: 'Warning',
                              color: colors.status.warningColor,
                            ),
                            _ColorBox(
                              label: 'Destructive',
                              color: colors.status.destructiveColor,
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Button Examples
                      const Text(
                        'Button Examples',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(texts?.ctaButton ?? 'Primary Button'),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Outlined Button'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Text Button'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Status Messages
                      const Text(
                        'Status Messages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (colors != null) ...[
                        _StatusMessage(
                          icon: Icons.info_outline,
                          message: 'Info message with dynamic color',
                          color: colors.status.infoColor,
                        ),
                        const SizedBox(height: 8),
                        _StatusMessage(
                          icon: Icons.check_circle_outline,
                          message: 'Success message with dynamic color',
                          color: colors.status.successColor,
                        ),
                        const SizedBox(height: 8),
                        _StatusMessage(
                          icon: Icons.warning_amber_outlined,
                          message: 'Warning message with dynamic color',
                          color: colors.status.warningColor,
                        ),
                        const SizedBox(height: 8),
                        _StatusMessage(
                          icon: Icons.error_outline,
                          message: 'Error message with dynamic color',
                          color: colors.status.destructiveColor,
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

/// Color box widget
class _ColorBox extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorBox({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

/// Status message widget
class _StatusMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _StatusMessage({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
