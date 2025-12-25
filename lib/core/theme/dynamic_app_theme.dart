import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/models/app_settings_model.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dynamic App theme builder from server configuration
class DynamicAppTheme {
  DynamicAppTheme._();

  /// Build light theme from configuration
  static ThemeData buildLightTheme(AppConfigData config) {
    return _buildTheme(config, false);
  }

  /// Build dark theme from configuration
  static ThemeData buildDarkTheme(AppConfigData config) {
    return _buildTheme(config, true);
  }

  /// Internal method to build theme
  static ThemeData _buildTheme(AppConfigData config, bool isDark) {
    final themeColors = isDark ? config.colors.dark : config.colors.light;
    final typography = config.typography;
    final fonts = config.fonts;

    // Create color scheme
    final colorScheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: themeColors.primaryColor,
      onPrimary: themeColors.heading.firstColor,
      secondary: themeColors.secondaryColor,
      onSecondary: themeColors.heading.firstColor,
      error: themeColors.status.destructiveColor,
      onError: Colors.white,
      surface: themeColors.bodyColor,
      onSurface: themeColors.paragraph.firstColor,
      surfaceContainerHighest: themeColors.box.firstColor,
      outline: themeColors.borderColor,
    );

    // Build text theme with dynamic fonts
    final textTheme = _buildTextTheme(typography, fonts, themeColors);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: themeColors.bodyColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: themeColors.bodyColor,
        foregroundColor: themeColors.paragraph.firstColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: themeColors.heading.firstColor,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColors.primaryColor,
          foregroundColor: themeColors.bodyColor,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: themeColors.primaryColor,
          side: BorderSide(color: themeColors.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: themeColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: themeColors.box.firstColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: themeColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: themeColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: themeColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: themeColors.status.destructiveColor),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: themeColors.paragraph.secondColor,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: themeColors.paragraph.thirdColor.withOpacity(0.6),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: themeColors.box.firstColor,
        elevation: 1,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: themeColors.borderColor, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: themeColors.bodyColor,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: themeColors.borderColor, width: 1),
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: themeColors.heading.firstColor,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: themeColors.paragraph.firstColor,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: themeColors.bodyColor,
        selectedItemColor: themeColors.primaryColor,
        unselectedItemColor: themeColors.paragraph.secondColor,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColors.primaryColor,
        foregroundColor: themeColors.bodyColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: themeColors.paragraph.firstColor,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: themeColors.borderColor,
        thickness: 1,
        space: 1,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: themeColors.buttonColor,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: themeColors.paragraph.firstColor,
        ),
        actionTextColor: themeColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Build text theme from typography config
  static TextTheme _buildTextTheme(
    TypographyConfig typography,
    FontsConfig fonts,
    ThemeColorsConfig colors,
  ) {
    // Get Google Fonts for heading and body
    final headingFont = _getGoogleFont(fonts.heading);
    final bodyFont = _getGoogleFont(fonts.body);

    return TextTheme(
      // Display styles (H1)
      displayLarge: headingFont?.copyWith(
            fontSize: typography.h1.fontSizeValue,
            fontWeight: typography.h1.fontWeightValue,
            color: colors.heading.firstColor,
            height: 1.2,
          ) ??
          TextStyle(
            fontFamily: fonts.heading,
            fontSize: typography.h1.fontSizeValue,
            fontWeight: typography.h1.fontWeightValue,
            color: colors.heading.firstColor,
            height: 1.2,
          ),

      // Headline styles (H2)
      headlineLarge: headingFont?.copyWith(
            fontSize: typography.h2.fontSizeValue,
            fontWeight: typography.h2.fontWeightValue,
            color: colors.heading.secondColor,
            height: 1.3,
          ) ??
          TextStyle(
            fontFamily: fonts.heading,
            fontSize: typography.h2.fontSizeValue,
            fontWeight: typography.h2.fontWeightValue,
            color: colors.heading.secondColor,
            height: 1.3,
          ),

      headlineMedium: headingFont?.copyWith(
            fontSize: typography.h2.fontSizeValue * 0.875,
            fontWeight: typography.h2.fontWeightValue,
            color: colors.heading.secondColor,
            height: 1.3,
          ) ??
          TextStyle(
            fontFamily: fonts.heading,
            fontSize: typography.h2.fontSizeValue * 0.875,
            fontWeight: typography.h2.fontWeightValue,
            color: colors.heading.secondColor,
            height: 1.3,
          ),

      // Title styles (H3)
      titleLarge: headingFont?.copyWith(
            fontSize: typography.h3.fontSizeValue,
            fontWeight: typography.h3.fontWeightValue,
            color: colors.heading.firstColor,
            height: 1.4,
          ) ??
          TextStyle(
            fontFamily: fonts.heading,
            fontSize: typography.h3.fontSizeValue,
            fontWeight: typography.h3.fontWeightValue,
            color: colors.heading.firstColor,
            height: 1.4,
          ),

      titleMedium: headingFont?.copyWith(
            fontSize: typography.h3.fontSizeValue * 0.875,
            fontWeight: typography.h3.fontWeightValue,
            color: colors.heading.thirdColor,
            height: 1.4,
          ) ??
          TextStyle(
            fontFamily: fonts.heading,
            fontSize: typography.h3.fontSizeValue * 0.875,
            fontWeight: typography.h3.fontWeightValue,
            color: colors.heading.thirdColor,
            height: 1.4,
          ),

      // Body styles
      bodyLarge: bodyFont?.copyWith(
            fontSize: typography.body.fontSizeValue * 1.125,
            fontWeight: typography.body.fontWeightValue,
            color: colors.paragraph.firstColor,
            height: 1.5,
          ) ??
          TextStyle(
            fontFamily: fonts.body,
            fontSize: typography.body.fontSizeValue * 1.125,
            fontWeight: typography.body.fontWeightValue,
            color: colors.paragraph.firstColor,
            height: 1.5,
          ),

      bodyMedium: bodyFont?.copyWith(
            fontSize: typography.body.fontSizeValue,
            fontWeight: typography.body.fontWeightValue,
            color: colors.paragraph.firstColor,
            height: 1.5,
          ) ??
          TextStyle(
            fontFamily: fonts.body,
            fontSize: typography.body.fontSizeValue,
            fontWeight: typography.body.fontWeightValue,
            color: colors.paragraph.firstColor,
            height: 1.5,
          ),

      bodySmall: bodyFont?.copyWith(
            fontSize: typography.body.fontSizeValue * 0.875,
            fontWeight: typography.body.fontWeightValue,
            color: colors.paragraph.secondColor,
            height: 1.5,
          ) ??
          TextStyle(
            fontFamily: fonts.body,
            fontSize: typography.body.fontSizeValue * 0.875,
            fontWeight: typography.body.fontWeightValue,
            color: colors.paragraph.secondColor,
            height: 1.5,
          ),

      // Label styles
      labelLarge: bodyFont?.copyWith(
            fontSize: typography.body.fontSizeValue,
            fontWeight: FontWeight.w600,
            color: colors.paragraph.firstColor,
          ) ??
          TextStyle(
            fontFamily: fonts.body,
            fontSize: typography.body.fontSizeValue,
            fontWeight: FontWeight.w600,
            color: colors.paragraph.firstColor,
          ),

      labelMedium: bodyFont?.copyWith(
            fontSize: typography.body.fontSizeValue * 0.875,
            fontWeight: FontWeight.w500,
            color: colors.paragraph.secondColor,
          ) ??
          TextStyle(
            fontFamily: fonts.body,
            fontSize: typography.body.fontSizeValue * 0.875,
            fontWeight: FontWeight.w500,
            color: colors.paragraph.secondColor,
          ),

      labelSmall: bodyFont?.copyWith(
            fontSize: typography.body.fontSizeValue * 0.75,
            fontWeight: FontWeight.w500,
            color: colors.paragraph.thirdColor,
          ) ??
          TextStyle(
            fontFamily: fonts.body,
            fontSize: typography.body.fontSizeValue * 0.75,
            fontWeight: FontWeight.w500,
            color: colors.paragraph.thirdColor,
          ),
    );
  }

  /// Get Google Font by name
  static TextStyle? _getGoogleFont(String fontName) {
    try {
      switch (fontName.toLowerCase()) {
        case 'orbitron':
          return GoogleFonts.orbitron();
        case 'inter':
          return GoogleFonts.inter();
        case 'roboto':
          return GoogleFonts.roboto();
        case 'poppins':
          return GoogleFonts.poppins();
        case 'montserrat':
          return GoogleFonts.montserrat();
        case 'lato':
          return GoogleFonts.lato();
        case 'opensans':
        case 'open sans':
          return GoogleFonts.openSans();
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error loading Google Font $fontName: $e');
      return null;
    }
  }
}
