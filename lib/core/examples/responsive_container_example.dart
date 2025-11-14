import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/responsive_container.dart';

/// Example page demonstrating responsive container usage
class ResponsiveContainerExample extends StatelessWidget {
  const ResponsiveContainerExample({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Container Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Full width background with constrained content
            ResponsiveSection(
              backgroundColor: isDark
                  ? AppColors.darkInfo.withValues(alpha: 0.1)
                  : AppColors.lightInfo.withValues(alpha: 0.1),
              child: Column(
                children: [
                  Text(
                    'Section 1 - Bootstrap-like Container',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: isDark ? AppColors.darkInfo : AppColors.lightInfo,
                    child: const Center(
                      child: Text('Content is constrained by container width'),
                    ),
                  ),
                ],
              ),
            ),

            // Another section with different background
            ResponsiveSection(
              backgroundColor: isDark
                  ? AppColors.darkSuccess.withValues(alpha: 0.1)
                  : AppColors.lightSuccess.withValues(alpha: 0.1),
              child: Column(
                children: [
                  Text(
                    'Section 2 - Different Background',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: isDark
                        ? AppColors.darkSuccess.withValues(alpha: 0.1)
                        : AppColors.lightSuccess.withValues(alpha: 0.1),
                    child: const Center(
                      child: Text('Each section has its own background'),
                    ),
                  ),
                ],
              ),
            ),

            // Section with custom max width
            ResponsiveSection(
              backgroundColor: isDark
                  ? AppColors.darkInfo.withValues(alpha: 0.1)
                  : AppColors.lightInfo.withValues(alpha: 0.1),
              maxWidth: 600, // Custom max width
              child: Column(
                children: [
                  Text(
                    'Section 3 - Custom Max Width (600px)',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: colorScheme.secondary.withValues(alpha: 0.3),
                    child: const Center(
                      child: Text('This section has a custom max width'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
