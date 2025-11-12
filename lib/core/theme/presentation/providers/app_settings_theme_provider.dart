import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/app_settings_local_data_source.dart';
import '../../data/datasources/app_settings_remote_data_source.dart';
import '../../data/models/app_settings_model.dart';
import '../../data/repositories/app_settings_repository_impl.dart';
import '../../../network/base_dio_client.dart';
import '../../dynamic_app_theme.dart';
import '../../../providers/theme_provider.dart' as theme_provider;

/// Provider for SharedPreferences
final sharedPreferencesProviderForAppSettings = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// Provider for AppSettingsRepository
final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  
  return AppSettingsRepositoryImpl(
    remoteDataSource: AppSettingsRemoteDataSourceImpl(
      dioClient: dioClient,
    ),
    localDataSource: AppSettingsLocalDataSourceImpl(
      sharedPreferences: ref.watch(sharedPreferencesProviderForAppSettings),
    ),
  );
});

/// State class for app settings theme
class AppSettingsThemeState {
  final AppConfigData? config;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final bool isLoading;
  final String? error;

  const AppSettingsThemeState({
    this.config,
    this.lightTheme,
    this.darkTheme,
    this.isLoading = false,
    this.error,
  });

  AppSettingsThemeState copyWith({
    AppConfigData? config,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? isLoading,
    String? error,
  }) {
    return AppSettingsThemeState(
      config: config ?? this.config,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing app settings theme from server
class AppSettingsThemeNotifier extends StateNotifier<AppSettingsThemeState> {
  final AppSettingsRepository repository;

  AppSettingsThemeNotifier({
    required this.repository,
  }) : super(const AppSettingsThemeState());

  /// Load theme configuration from server
  Future<void> loadThemeConfig({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getAppSettings(forceRefresh: forceRefresh);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to load theme configuration',
        );
        debugPrint('❌ Failed to load theme config: ${failure.message}');
      },
      (config) {
        try {
          // Build theme data from config
          final lightTheme = DynamicAppTheme.buildLightTheme(config);
          final darkTheme = DynamicAppTheme.buildDarkTheme(config);

          state = state.copyWith(
            config: config,
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            isLoading: false,
            error: null,
          );
          
          debugPrint('✅ Theme config loaded successfully');
          debugPrint('  - Version: ${config.configVersion}');
          debugPrint('  - Color Scheme: ${config.colorScheme}');
          debugPrint('  - Heading Font: ${config.fonts.heading}');
          debugPrint('  - Body Font: ${config.fonts.body}');
        } catch (e) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to build theme: $e',
          );
          debugPrint('❌ Failed to build theme: $e');
        }
      },
    );
  }

  /// Refresh theme configuration from server
  Future<void> refreshThemeConfig() async {
    await loadThemeConfig(forceRefresh: true);
  }

  /// Get colors for current theme mode (light/dark)
  ThemeColorsConfig? getColorsForMode(bool isDark) {
    if (state.config == null) return null;
    return isDark ? state.config!.colors.dark : state.config!.colors.light;
  }

  /// Check if theme config is loaded
  bool get isConfigLoaded => state.config != null;

  /// Get current config
  AppConfigData? get currentConfig => state.config;
}

/// Provider for app settings theme notifier
final appSettingsThemeProvider =
    StateNotifierProvider<AppSettingsThemeNotifier, AppSettingsThemeState>((ref) {
  return AppSettingsThemeNotifier(
    repository: ref.watch(appSettingsRepositoryProvider),
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
