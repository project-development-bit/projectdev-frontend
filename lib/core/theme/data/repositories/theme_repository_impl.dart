import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/theme_config.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_database_source.dart';
import '../datasources/theme_remote_data_source.dart';
import '../datasources/theme_asset_data_source.dart';
import '../models/theme_config_model.dart';
import '../../app_colors.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeRemoteDataSource remoteDataSource;
  final ThemeDatabaseSource databaseSource;
  final ThemeAssetDataSource assetDataSource;

  ThemeRepositoryImpl({
    required this.remoteDataSource,
    required this.databaseSource,
    required this.assetDataSource,
  });

  @override
  Future<Either<Failure, ThemeConfig>> getThemeConfig() async {
    try {
      // Check stored theme version
      final storedVersion = await databaseSource.getStoredThemeVersion();

      // Fetch theme from API
      final remoteConfig = await remoteDataSource.getThemeConfig();

      // Check if we need to update (version changed or no stored theme)
      if (storedVersion == null || storedVersion != remoteConfig.version) {
        debugPrint(
            '🔄 Theme version changed: $storedVersion → ${remoteConfig.version}');
        // Save new theme to database
        await databaseSource.saveThemeConfig(remoteConfig);
        debugPrint('✅ New theme saved to database');
      } else {
        debugPrint('✓ Theme is up to date (version: $storedVersion)');
      }

      return Right(remoteConfig);
    } on DioException catch (e) {
      debugPrint('⚠️ API fetch failed, using cached theme');
      return Left(_handleDioException(e));
    } catch (e) {
      debugPrint('⚠️ Error fetching theme: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheThemeConfig(ThemeConfig config) async {
    try {
      await databaseSource.saveThemeConfig(config as ThemeConfigModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ThemeConfig>> getCachedThemeConfig() async {
    try {
      // Step 1: Try to get from database first
      final cachedConfig = await databaseSource.getThemeConfig();
      if (cachedConfig != null) {
        debugPrint('✅ Theme loaded from database');
        return Right(cachedConfig);
      }

      // Step 2: No database theme found - try to fetch from API
      debugPrint('⚠️ No theme in database, fetching from API...');
      try {
        final remoteConfig = await remoteDataSource.getThemeConfig();

        // Save API theme to database
        await databaseSource.saveThemeConfig(remoteConfig);
        debugPrint('✅ Theme fetched from API and saved to database');

        return Right(remoteConfig);
      } on DioException catch (apiError) {
        // Step 3: API failed - try to load from default JSON file
        debugPrint('⚠️ API fetch failed: ${apiError.message}');
        debugPrint('📦 Loading from assets/theme/default_theme.json...');

        try {
          final defaultTheme = await assetDataSource.loadDefaultTheme();

          // Save the default theme to database for future use
          await databaseSource.saveThemeConfig(defaultTheme);
          debugPrint('✅ Default theme loaded from JSON and saved to database');

          return Right(defaultTheme);
        } catch (assetError) {
          // Step 4: JSON file also fails - use hardcoded default theme
          debugPrint('⚠️ Failed to load default_theme.json: $assetError');
          debugPrint('📦 Using hardcoded default theme as final fallback');
          final hardcodedDefault = _getDefaultThemeConfig();

          // Try to save hardcoded default to database
          try {
            await databaseSource
                .saveThemeConfig(hardcodedDefault as ThemeConfigModel);
          } catch (_) {
            // Ignore save errors for hardcoded default
          }

          return Right(hardcodedDefault);
        }
      } catch (e) {
        // Unexpected error - try JSON file
        debugPrint('⚠️ Unexpected error fetching from API: $e');
        debugPrint('📦 Loading from assets/theme/default_theme.json...');

        try {
          final defaultTheme = await assetDataSource.loadDefaultTheme();
          await databaseSource.saveThemeConfig(defaultTheme);
          debugPrint('✅ Default theme loaded from JSON and saved to database');
          return Right(defaultTheme);
        } catch (assetError) {
          debugPrint('⚠️ Failed to load default_theme.json: $assetError');
          final hardcodedDefault = _getDefaultThemeConfig();
          return Right(hardcodedDefault);
        }
      }
    } catch (e) {
      debugPrint('❌ Critical error in getCachedThemeConfig: $e');
      return Right(_getDefaultThemeConfig());
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await databaseSource.clearTheme();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        return ServerFailure(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return const ServerFailure(message: 'No internet connection');
      default:
        return ServerFailure(message: 'Network error: ${e.message}');
    }
  }

  /// Get default theme configuration (fallback)
  ThemeConfig _getDefaultThemeConfig() {
    return ThemeConfigModel(
      version: '1.0.0',
      lastUpdated: DateTime.now(),
      fonts: const FontConfigModel(
        primary: 'Inter',
        title: 'Orbitron',
        fallback: [
          'Orbitron',
          'Inter',
          '-apple-system',
          'BlinkMacSystemFont',
          'Segoe UI',
          'system-ui',
          'sans-serif'
        ],
      ),
      customColors: const CustomColorsConfigModel(
        websiteGold: AppColors.websiteGold,
        websiteGreen: Color(0xFF00FF00), // Green color
        linkBlue: Color(0xFF3B82F6), // Blue color
      ),
      lightTheme: _buildLightThemeVariant(),
      darkTheme: _buildDarkThemeVariant(),
    );
  }

  ThemeVariantConfigModel _buildLightThemeVariant() {
    final colorScheme = AppColors.lightColorScheme;
    return ThemeVariantConfigModel(
      colorScheme: ColorSchemeConfigModel(
        brightness: colorScheme.brightness,
        primary: colorScheme.primary,
        onPrimary: colorScheme.onPrimary,
        primaryContainer: colorScheme.primaryContainer,
        onPrimaryContainer: colorScheme.onPrimaryContainer,
        secondary: colorScheme.secondary,
        onSecondary: colorScheme.onSecondary,
        secondaryContainer: colorScheme.secondaryContainer,
        onSecondaryContainer: colorScheme.onSecondaryContainer,
        tertiary: colorScheme.tertiary,
        onTertiary: colorScheme.onTertiary,
        tertiaryContainer: colorScheme.tertiaryContainer,
        onTertiaryContainer: colorScheme.onTertiaryContainer,
        error: colorScheme.error,
        onError: colorScheme.onError,
        errorContainer: colorScheme.errorContainer,
        onErrorContainer: colorScheme.onErrorContainer,
        surface: colorScheme.surface,
        onSurface: colorScheme.onSurface,
        surfaceContainerLowest: colorScheme.surfaceContainerLowest,
        surfaceContainerLow: colorScheme.surfaceContainerLow,
        surfaceContainer: colorScheme.surfaceContainer,
        surfaceContainerHigh: colorScheme.surfaceContainerHigh,
        surfaceContainerHighest: colorScheme.surfaceContainerHighest,
        onSurfaceVariant: colorScheme.onSurfaceVariant,
        outline: colorScheme.outline,
        outlineVariant: colorScheme.outlineVariant,
        shadow: colorScheme.shadow,
        scrim: colorScheme.scrim,
        inverseSurface: colorScheme.inverseSurface,
        onInverseSurface: colorScheme.onInverseSurface,
        inversePrimary: colorScheme.inversePrimary,
      ),
      components: _buildDefaultComponents(),
      typography: _buildDefaultTypography(),
    );
  }

  ThemeVariantConfigModel _buildDarkThemeVariant() {
    final colorScheme = AppColors.darkColorScheme;
    return ThemeVariantConfigModel(
      colorScheme: ColorSchemeConfigModel(
        brightness: colorScheme.brightness,
        primary: colorScheme.primary,
        onPrimary: colorScheme.onPrimary,
        primaryContainer: colorScheme.primaryContainer,
        onPrimaryContainer: colorScheme.onPrimaryContainer,
        secondary: colorScheme.secondary,
        onSecondary: colorScheme.onSecondary,
        secondaryContainer: colorScheme.secondaryContainer,
        onSecondaryContainer: colorScheme.onSecondaryContainer,
        tertiary: colorScheme.tertiary,
        onTertiary: colorScheme.onTertiary,
        tertiaryContainer: colorScheme.tertiaryContainer,
        onTertiaryContainer: colorScheme.onTertiaryContainer,
        error: colorScheme.error,
        onError: colorScheme.onError,
        errorContainer: colorScheme.errorContainer,
        onErrorContainer: colorScheme.onErrorContainer,
        surface: colorScheme.surface,
        onSurface: colorScheme.onSurface,
        surfaceContainerLowest: colorScheme.surfaceContainerLowest,
        surfaceContainerLow: colorScheme.surfaceContainerLow,
        surfaceContainer: colorScheme.surfaceContainer,
        surfaceContainerHigh: colorScheme.surfaceContainerHigh,
        surfaceContainerHighest: colorScheme.surfaceContainerHighest,
        onSurfaceVariant: colorScheme.onSurfaceVariant,
        outline: colorScheme.outline,
        outlineVariant: colorScheme.outlineVariant,
        shadow: colorScheme.shadow,
        scrim: colorScheme.scrim,
        inverseSurface: colorScheme.inverseSurface,
        onInverseSurface: colorScheme.onInverseSurface,
        inversePrimary: colorScheme.inversePrimary,
      ),
      components: _buildDefaultComponents(),
      typography: _buildDefaultTypography(),
    );
  }

  ComponentsConfigModel _buildDefaultComponents() {
    return const ComponentsConfigModel(
      appBar: AppBarConfigModel(
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      button: ButtonConfigModel(
        borderRadius: 12.0,
        elevation: 2.0,
        padding: EdgeInsetsConfigModel(horizontal: 24.0, vertical: 12.0),
      ),
      textButton: ButtonConfigModel(
        borderRadius: 8.0,
        elevation: 0.0,
        padding: EdgeInsetsConfigModel(horizontal: 16.0, vertical: 8.0),
      ),
      inputField: InputFieldConfigModel(
        borderRadius: 12.0,
        fillOpacity: 0.3,
        contentPadding: EdgeInsetsConfigModel(horizontal: 16.0, vertical: 16.0),
        focusedBorderWidth: 2.0,
      ),
      card: CardConfigModel(
        borderRadius: 16.0,
        elevation: 1.0,
        margin: 8.0,
      ),
      dialog: DialogConfigModel(
        borderRadius: 20.0,
        elevation: 8.0,
      ),
      bottomNavigation: NavigationConfigModel(
        elevation: 8.0,
        type: 'fixed',
      ),
      floatingActionButton: FABConfigModel(
        borderRadius: 16.0,
        elevation: 6.0,
      ),
      checkbox: CheckboxConfigModel(
        borderRadius: 4.0,
        borderWidth: 2.0,
      ),
    );
  }

  TypographyConfigModel _buildDefaultTypography() {
    return const TypographyConfigModel(
      displayLarge: TextStyleConfigModel(
        fontSize: 57.0,
        fontWeight: 400,
        lineHeight: 1.12,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyleConfigModel(
        fontSize: 45.0,
        fontWeight: 400,
        lineHeight: 1.16,
      ),
      displaySmall: TextStyleConfigModel(
        fontSize: 36.0,
        fontWeight: 400,
        lineHeight: 1.22,
      ),
      headlineLarge: TextStyleConfigModel(
        fontSize: 32.0,
        fontWeight: 400,
        lineHeight: 1.25,
      ),
      headlineMedium: TextStyleConfigModel(
        fontSize: 28.0,
        fontWeight: 600,
        lineHeight: 1.29,
      ),
      headlineSmall: TextStyleConfigModel(
        fontSize: 24.0,
        fontWeight: 600,
        lineHeight: 1.33,
      ),
      titleLarge: TextStyleConfigModel(
        fontSize: 22.0,
        fontWeight: 600,
        lineHeight: 1.27,
      ),
      titleMedium: TextStyleConfigModel(
        fontSize: 16.0,
        fontWeight: 600,
        lineHeight: 1.5,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyleConfigModel(
        fontSize: 14.0,
        fontWeight: 600,
        lineHeight: 1.43,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyleConfigModel(
        fontSize: 16.0,
        fontWeight: 400,
        lineHeight: 1.5,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyleConfigModel(
        fontSize: 14.0,
        fontWeight: 400,
        lineHeight: 1.43,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyleConfigModel(
        fontSize: 12.0,
        fontWeight: 400,
        lineHeight: 1.33,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyleConfigModel(
        fontSize: 14.0,
        fontWeight: 600,
        lineHeight: 1.43,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyleConfigModel(
        fontSize: 12.0,
        fontWeight: 600,
        lineHeight: 1.33,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyleConfigModel(
        fontSize: 11.0,
        fontWeight: 600,
        lineHeight: 1.45,
        letterSpacing: 0.5,
      ),
    );
  }
}
