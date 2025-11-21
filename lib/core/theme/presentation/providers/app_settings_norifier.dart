import 'package:cointiply_app/core/theme/domain/usecases/app_settings_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/app_settings_model.dart';
import '../../dynamic_app_theme.dart';

/// State class for app settings theme
class AppSettingsState {
  final AppConfigData? config;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final bool isLoading;
  final String? error;
  final String configVersion;
  final List<BannerConfig> banners;

  const AppSettingsState({
    this.config,
    this.lightTheme,
    this.darkTheme,
    this.configVersion = '',
    this.banners = const [],
    this.isLoading = false,
    this.error,
  });

  AppSettingsState copyWith({
    AppConfigData? config,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? isLoading,
    String? error,
    String? configVersion,
    List<BannerConfig>? banners,
  }) {
    return AppSettingsState(
      config: config ?? this.config,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      configVersion: configVersion ?? this.configVersion,
      banners: banners ?? this.banners,
    );
  }
}

/// Notifier for managing app settings  from server
class AppSettingsNotifier extends StateNotifier<AppSettingsState> {
  final GetAppSettingsUseCase getAppSettingsUseCase;

  AppSettingsNotifier({
    required this.getAppSettingsUseCase,
  }) : super(const AppSettingsState());

  /// Load theme configuration from server
  Future<void> loadConfig({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getAppSettingsUseCase.call(forceRefresh);

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
            configVersion: config.configVersion,
            banners: config.banners,
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
    await loadConfig(forceRefresh: true);
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
