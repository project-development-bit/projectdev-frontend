import 'package:gigafaucet/core/theme/domain/usecases/app_settings_usecase.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/app_settings_model.dart';
import '../../domain/usecases/asset_theme_usecase.dart';
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
  final GetRemoteAppSettingsUseCase getRemoteAppSettingsUseCase;
  final GetLocalAppSettingsUseCase getLocalAppSettingsUseCase;

  /// get the fallback theme from assets
  final GetAssetThemeUsecase getAssetThemeUsecase;

  AppSettingsNotifier({
    required this.getRemoteAppSettingsUseCase,
    required this.getLocalAppSettingsUseCase,
    required this.getAssetThemeUsecase,
  }) : super(const AppSettingsState());

  Future<void> loadConfig({bool forceRefresh = false}) async {
    debugPrint(
      '🌈 Loading app settings theme configuration (forceRefresh: $forceRefresh)...',
    );
    // --------------------------------------------------------
    // 1. Try local cache first (instant UI, no loading screen)
    // --------------------------------------------------------
    if (!forceRefresh) {
      final localResult = await getLocalAppSettingsUseCase.call(NoParams());

      localResult.fold(
        (_) {
          state = state.copyWith();
        }, // ignore local error
        (cached) {
          debugPrint(
            '🌈 Loaded app settings theme from cache, version: ${cached?.version}',
          );
          if (cached != null) {
            // Apply cached theme immediately
            state = state.copyWith(
              config: cached.configData,
              lightTheme: DynamicAppTheme.buildLightTheme(cached.configData),
              darkTheme: DynamicAppTheme.buildDarkTheme(cached.configData),
              configVersion: cached.version,
              banners: cached.configData.banners,
              isLoading: false,
              error: null,
            );

            // Fetch fresh config in background
            _refreshInBackground(cached.version);
          }
        },
      );
    }

    // --------------------------------------------------------
    // 2. If no cache was applied, show loading + fetch from BE
    // --------------------------------------------------------
    if (state.config == null || forceRefresh) {
      state = state.copyWith(isLoading: true, error: null);

      final remoteResult = await getRemoteAppSettingsUseCase.call(NoParams());

      remoteResult.fold(
        (failure) async {
          debugPrint(
            '🌈 Failed to load app settings theme from server: ${failure.message}',
          );
          final assetData = await getAssetThemeUsecase.call();

          assetData.fold((_) {}, (assetTheme) {
            debugPrint(
              '🌈 Loaded app settings theme from assets as fallback, version: ${assetTheme.configData}',
            );
            state = state.copyWith(
              isLoading: false,
              error: failure.message ?? 'Failed to load theme configuration',
              lightTheme:
                  DynamicAppTheme.buildLightTheme(assetTheme.configData),
              darkTheme: DynamicAppTheme.buildDarkTheme(assetTheme.configData),
            );
          });
        },
        (config) {
          debugPrint(
            '🌈 Loaded app settings theme from server, version: ${config.version}',
          );
          state = state.copyWith(
            config: config.configData,
            lightTheme: DynamicAppTheme.buildLightTheme(config.configData),
            darkTheme: DynamicAppTheme.buildDarkTheme(config.configData),
            configVersion: config.version,
            banners: config.configData.banners,
            isLoading: false,
            error: null,
          );
        },
      );
    }
  }

  Future<void> _refreshInBackground(String oldVersion) async {
    debugPrint('🌈 Refreshing app settings theme in background...');
    final result = await getRemoteAppSettingsUseCase.call(NoParams());

    result.fold(
      (_) {}, // ignore background errors
      (config) {
        debugPrint(
          '🌈 Background refresh got app settings theme version: ${config.version}',
        );
        if (config.version != oldVersion) {
          debugPrint(
            '🌈 App settings theme version changed from $oldVersion to ${config.version}. Updating theme...',
          );
          // Theme changed → update UI
          state = state.copyWith(
            config: config.configData,
            lightTheme: DynamicAppTheme.buildLightTheme(config.configData),
            darkTheme: DynamicAppTheme.buildDarkTheme(config.configData),
            configVersion: config.version,
            banners: config.configData.banners,
          );
        } else {
          debugPrint('🌈 App settings theme version unchanged.');
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
