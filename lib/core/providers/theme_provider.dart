import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum for theme modes
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Notifier for managing theme mode
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(AppThemeMode.system) {
    _loadThemeMode();
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);

      if (themeIndex != null && themeIndex < AppThemeMode.values.length) {
        state = AppThemeMode.values[themeIndex];
        debugPrint('Loaded theme mode: ${state.name}');
      } else {
        // Default to system theme
        state = AppThemeMode.system;
        debugPrint('Using default theme mode: system');
      }
    } catch (e) {
      // If there's an error, keep the default system theme
      state = AppThemeMode.system;
      debugPrint('Error loading theme mode: $e');
    }
  }

  /// Set theme mode and save to storage
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    try {
      debugPrint('Setting theme mode to: ${themeMode.name}');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
      state = themeMode;
      debugPrint('Theme mode set successfully to: ${state.name}');
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Toggle between light and dark mode (ignores system)
  Future<void> toggleTheme() async {
    final newTheme =
        state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await setThemeMode(newTheme);
  }

  /// Get the actual theme mode based on system settings
  ThemeMode getEffectiveThemeMode(Brightness? systemBrightness) {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Check if current theme is dark
  bool isDark(Brightness? systemBrightness) {
    switch (state) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return systemBrightness == Brightness.dark;
    }
  }

  /// Check if current theme is light
  bool isLight(Brightness? systemBrightness) {
    return !isDark(systemBrightness);
  }

  /// Get theme mode display name
  String getThemeModeDisplayName(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  /// Get current theme mode display name
  String get currentThemeModeDisplayName => getThemeModeDisplayName(state);

  /// Get theme mode icon
  IconData getThemeModeIcon(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Get current theme mode icon
  IconData get currentThemeModeIcon => getThemeModeIcon(state);
}

/// Provider for theme management
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

/// Provider for getting the effective theme mode
final effectiveThemeModeProvider = Provider<ThemeMode>((ref) {
  final notifier = ref.read(themeProvider.notifier);

  // You might need to get system brightness from MediaQuery in a widget
  // For now, we'll default to light when system is selected
  return notifier.getEffectiveThemeMode(null);
});

/// Provider for checking if current theme is dark
final isDarkThemeProvider = Provider<bool>((ref) {
  final notifier = ref.read(themeProvider.notifier);

  // You might need to get system brightness from MediaQuery in a widget
  // For now, we'll default to light when system is selected
  return notifier.isDark(null);
});

/// Provider for getting theme mode display name
final themeModeDisplayNameProvider = Provider<String>((ref) {
  final themeMode = ref.watch(themeProvider);
  final notifier = ref.read(themeProvider.notifier);
  return notifier.getThemeModeDisplayName(themeMode);
});

/// Provider for getting theme mode icon
final themeModeIconProvider = Provider<IconData>((ref) {
  final themeMode = ref.watch(themeProvider);
  final notifier = ref.read(themeProvider.notifier);
  return notifier.getThemeModeIcon(themeMode);
});
