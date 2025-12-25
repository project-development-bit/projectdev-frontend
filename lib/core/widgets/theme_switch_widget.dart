import 'package:gigafaucet/core/common/widgets/custom_pointer_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../extensions/context_extensions.dart';

/// A widget for switching between light, dark, and system themes
class ThemeSwitchWidget extends ConsumerWidget {
  const ThemeSwitchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return PopupMenuButton<AppThemeMode>(
      onSelected: (AppThemeMode themeMode) async {
        debugPrint('Theme selected: ${themeMode.name}');
        await themeNotifier.setThemeMode(themeMode);
      },
      tooltip: 'Change Theme',
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.outline.withAlpha(77), // 0.3 * 255
          ),
        ),
        child: Icon(
          themeNotifier.getThemeModeIcon(currentThemeMode),
          color: context.onSurface,
          size: 20,
        ),
      ),
      itemBuilder: (BuildContext context) {
        return AppThemeMode.values.map((AppThemeMode themeMode) {
          final isSelected = themeMode == currentThemeMode;

          return PopupMenuItem<AppThemeMode>(
            value: themeMode,
            child: CustomPointerInterceptor(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: isSelected
                    ? BoxDecoration(
                        color: context.primary.withAlpha(26), // 0.1 * 255
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                child: Row(
                  children: [
                    Icon(
                      themeNotifier.getThemeModeIcon(themeMode),
                      size: 20,
                      color: isSelected ? context.primary : context.onSurface,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        themeNotifier.getThemeModeDisplayName(themeMode),
                        style: context.bodyMedium?.copyWith(
                          color:
                              isSelected ? context.primary : context.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        size: 16,
                        color: context.primary,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList();
      },
    );
  }
}

/// A simple toggle button for switching between light and dark themes
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = context.isDark;

    return IconButton(
      onPressed: () => themeNotifier.toggleTheme(),
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: child,
          );
        },
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDark),
          color: context.onSurface,
        ),
      ),
    );
  }
}

/// A compact theme switcher for app bars
class CompactThemeSwitcher extends ConsumerWidget {
  const CompactThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return GestureDetector(
      onTap: () => themeNotifier.toggleTheme(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: context.surfaceContainerHighest.withAlpha(128), // 0.5 * 255
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.outline.withAlpha(77), // 0.3 * 255
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              themeNotifier.getThemeModeIcon(currentThemeMode),
              size: 14,
              color: context.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              themeNotifier.getThemeModeDisplayName(currentThemeMode),
              style: context.labelSmall?.copyWith(
                color: context.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A switch-style theme toggle
class ThemeSwitchTile extends ConsumerWidget {
  final String? title;
  final String? subtitle;

  const ThemeSwitchTile({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = currentThemeMode == AppThemeMode.dark;

    return SwitchListTile(
      title: Text(
        title ?? 'Dark Mode',
        style: context.titleMedium,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.bodySmall?.copyWith(
                color: context.onSurfaceVariant,
              ),
            )
          : null,
      value: isDark,
      onChanged: (value) {
        final newTheme = value ? AppThemeMode.dark : AppThemeMode.light;
        themeNotifier.setThemeMode(newTheme);
      },
      secondary: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: context.onSurfaceVariant,
      ),
    );
  }
}

/// A detailed theme selector card
class ThemeSelectorCard extends ConsumerWidget {
  const ThemeSelectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Settings',
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your preferred theme',
              style: context.bodySmall?.copyWith(
                color: context.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...AppThemeMode.values.map((themeMode) {
              final isSelected = themeMode == currentThemeMode;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => themeNotifier.setThemeMode(themeMode),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? context.primary
                            : context.outline.withAlpha(77), // 0.3 * 255
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? context.primaryContainer.withAlpha(77) // 0.3 * 255
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          themeNotifier.getThemeModeIcon(themeMode),
                          color: isSelected
                              ? context.primary
                              : context.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                themeNotifier
                                    .getThemeModeDisplayName(themeMode),
                                style: context.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? context.primary
                                      : context.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              Text(
                                _getThemeDescription(themeMode),
                                style: context.bodySmall?.copyWith(
                                  color: context.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: context.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getThemeDescription(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system settings';
    }
  }
}
