import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/theme_config.dart';
import '../../domain/usecases/get_theme_config.dart';
import '../../../usecases/usecase.dart';
import '../../app_theme.dart';

/// State for dynamic theme management
class DynamicThemeState {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;
  final ThemeConfig? themeConfig;

  DynamicThemeState({
    required this.lightTheme,
    required this.darkTheme,
    this.isLoading = false,
    this.error,
    this.lastUpdated,
    this.themeConfig,
  });

  DynamicThemeState copyWith({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
    ThemeConfig? themeConfig,
  }) {
    return DynamicThemeState(
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      themeConfig: themeConfig ?? this.themeConfig,
    );
  }
}

/// Notifier for dynamic theme management
class DynamicThemeNotifier extends StateNotifier<DynamicThemeState> {
  final GetThemeConfig getThemeConfig;

  DynamicThemeNotifier({
    required this.getThemeConfig,
  }) : super(DynamicThemeState(
          lightTheme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
        ));

  /// Load theme from server
  /// Falls back to cached theme or default theme on error
  Future<void> loadTheme() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getThemeConfig(NoParams());

    result.fold(
      (failure) {
        // Keep current theme on failure
        state = state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to load theme',
        );
      },
      (config) {
        try {
          final lightTheme = _buildThemeData(
            config: config,
            isDark: false,
          );

          final darkTheme = _buildThemeData(
            config: config,
            isDark: true,
          );

          state = state.copyWith(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            isLoading: false,
            lastUpdated: DateTime.now(),
            themeConfig: config,
          );
        } catch (e) {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to apply theme: $e',
          );
        }
      },
    );
  }

  /// Build ThemeData from ThemeConfig
  ThemeData _buildThemeData({
    required ThemeConfig config,
    required bool isDark,
  }) {
    final variant = isDark ? config.darkTheme : config.lightTheme;
    final colorScheme = variant.colorScheme.toColorScheme();
    final textTheme = _buildTextTheme(variant.typography, config.fonts.primary);
    final components = variant.components;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: config.fonts.primary,
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: components.appBar.elevation,
        scrolledUnderElevation: components.appBar.scrolledUnderElevation,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: components.button.elevation,
          shadowColor: colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(components.button.borderRadius),
          ),
          padding: components.button.padding.toEdgeInsets(),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(components.button.borderRadius),
          ),
          padding: components.button.padding.toEdgeInsets(),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(components.textButton.borderRadius),
          ),
          padding: components.textButton.padding.toEdgeInsets(),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest
            .withAlpha((components.inputField.fillOpacity * 255).toInt()),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(components.inputField.borderRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(components.inputField.borderRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(components.inputField.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: components.inputField.focusedBorderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(components.inputField.borderRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(components.inputField.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: components.inputField.focusedBorderWidth,
          ),
        ),
        contentPadding: components.inputField.contentPadding.toEdgeInsets(),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: components.card.elevation,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(components.card.borderRadius),
        ),
        margin: EdgeInsets.all(components.card.margin),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        elevation: components.dialog.elevation,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(components.dialog.borderRadius),
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: components.bottomNavigation.elevation,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(color: colorScheme.onSurface);
          }
          return textTheme.labelSmall
              ?.copyWith(color: colorScheme.onSurfaceVariant);
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(
          color: colorScheme.outline,
          width: components.checkbox.borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(components.checkbox.borderRadius),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: components.floatingActionButton.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            components.floatingActionButton.borderRadius,
          ),
        ),
      ),
    );
  }

  TextTheme _buildTextTheme(TypographyConfig typography, String fontFamily) {
    return TextTheme(
      displayLarge: typography.displayLarge.toTextStyle(fontFamily),
      displayMedium: typography.displayMedium.toTextStyle(fontFamily),
      displaySmall: typography.displaySmall.toTextStyle(fontFamily),
      headlineLarge: typography.headlineLarge.toTextStyle(fontFamily),
      headlineMedium: typography.headlineMedium.toTextStyle(fontFamily),
      headlineSmall: typography.headlineSmall.toTextStyle(fontFamily),
      titleLarge: typography.titleLarge.toTextStyle(fontFamily),
      titleMedium: typography.titleMedium.toTextStyle(fontFamily),
      titleSmall: typography.titleSmall.toTextStyle(fontFamily),
      bodyLarge: typography.bodyLarge.toTextStyle(fontFamily),
      bodyMedium: typography.bodyMedium.toTextStyle(fontFamily),
      bodySmall: typography.bodySmall.toTextStyle(fontFamily),
      labelLarge: typography.labelLarge.toTextStyle(fontFamily),
      labelMedium: typography.labelMedium.toTextStyle(fontFamily),
      labelSmall: typography.labelSmall.toTextStyle(fontFamily),
    );
  }

  /// Reset to default theme
  void resetToDefault() {
    state = DynamicThemeState(
      lightTheme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      lastUpdated: DateTime.now(),
    );
  }
}
