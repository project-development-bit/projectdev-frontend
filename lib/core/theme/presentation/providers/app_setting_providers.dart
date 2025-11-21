import '../../../providers/theme_provider.dart' as theme_provider;

import 'package:cointiply_app/core/theme/data/models/app_settings_model.dart';
import 'package:cointiply_app/core/theme/domain/usecases/app_settings_usecase.dart';
import 'package:cointiply_app/core/theme/presentation/providers/app_settings_norifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences
final sharedPreferencesProviderForAppSettings =
    Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// Provider for fonts config
final appFontsConfigProvider = Provider<FontsConfig?>((ref) {
  final appSettingsTheme = ref.watch(appSettingsThemeProvider);
  return appSettingsTheme.config?.fonts;
});

/// Provider for typography config
final appTypographyConfigProvider = Provider<TypographyConfig?>((ref) {
  final appSettingsTheme = ref.watch(appSettingsThemeProvider);
  return appSettingsTheme.config?.typography;
});

/// Provider for banners config
final appBannersConfigProvider = Provider<List<BannerConfig>>((ref) {
  final appSettingsTheme = ref.watch(appSettingsThemeProvider);
  return appSettingsTheme.config?.banners ?? [];
});

/// Provider for texts config
final appTextsConfigProvider = Provider<TextsConfig?>((ref) {
  final appSettingsTheme = ref.watch(appSettingsThemeProvider);
  return appSettingsTheme.config?.texts;
});

final bannersConfigProvider = Provider<List<BannerConfig>>((ref) {
  final appSettingsTheme = ref.watch(appSettingsThemeProvider);
  return !appSettingsTheme.isLoading ? appSettingsTheme.banners : [];
});

/// Provider for app settings theme notifier
final appSettingsThemeProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettingsState>((ref) {
  return AppSettingsNotifier(
    getAppSettingsUseCase: ref.watch(getAppSettingsUseCaseProvider),
  );
});

/// Provider to get current theme colors based on theme mode
final currentAppThemeColorsProvider = Provider<ThemeColorsConfig?>((ref) {
  final appSettingsTheme = ref.watch(appSettingsThemeProvider);

  if (appSettingsTheme.config == null) return null;

  // Watch the existing theme provider to determine if dark mode is active
  final themeMode = ref.watch(theme_provider.themeProvider);
  final isDark = themeMode == theme_provider.AppThemeMode.dark;

  return isDark
      ? appSettingsTheme.config!.colors.dark
      : appSettingsTheme.config!.colors.light;
});
