import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextTheme {
  static const String _fontFamily = 'Roboto';

  // Base text styles
  static const double _baseLineHeight = 1.5;

  // Light Theme Text Theme
  static TextTheme get lightTextTheme {
    return const TextTheme(
      // Display styles (largest)
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.25,
        color: AppColors.lightTextPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
        letterSpacing: 0,
        color: AppColors.lightTextPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
        letterSpacing: 0,
        color: AppColors.lightTextPrimary,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0,
        color: AppColors.lightTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: 0,
        color: AppColors.lightTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0,
        color: AppColors.lightTextPrimary,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
        letterSpacing: 0,
        color: AppColors.lightTextPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: _baseLineHeight,
        letterSpacing: 0.15,
        color: AppColors.lightTextPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.lightTextPrimary,
      ),

      // Body styles (most common)
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: _baseLineHeight,
        letterSpacing: 0.5,
        color: AppColors.lightTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: AppColors.lightTextSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: AppColors.lightTextSecondary,
      ),

      // Label styles (buttons, form labels)
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.lightTextPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.5,
        color: AppColors.lightTextPrimary,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.5,
        color: AppColors.lightTextSecondary,
      ),
    );
  }

  // Dark Theme Text Theme
  static TextTheme get darkTextTheme {
    return const TextTheme(
      // Display styles (largest)
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.25,
        color: AppColors.darkTextPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
        letterSpacing: 0,
        color: AppColors.darkTextPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
        letterSpacing: 0,
        color: AppColors.darkTextPrimary,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0,
        color: AppColors.darkTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: 0,
        color: AppColors.darkTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0,
        color: AppColors.darkTextPrimary,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
        letterSpacing: 0,
        color: AppColors.darkTextPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: _baseLineHeight,
        letterSpacing: 0.15,
        color: AppColors.darkTextPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.darkTextPrimary,
      ),

      // Body styles (most common)
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: _baseLineHeight,
        letterSpacing: 0.5,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: AppColors.darkTextSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: AppColors.darkTextSecondary,
      ),

      // Label styles (buttons, form labels)
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.darkTextPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.5,
        color: AppColors.darkTextPrimary,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.5,
        color: AppColors.darkTextSecondary,
      ),
    );
  }

  // Custom text styles for specific use cases
  static const TextStyle buttonText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
  );

  static const TextStyle captionText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static const TextStyle overlineText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  // Helper methods for custom text styles
  static TextStyle displayExtraLarge({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 64,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle displayExtraSmall({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0,
        color: color,
      );

  // Brand-specific text styles
  static TextStyle brandText({Color? color, double? fontSize}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: fontSize ?? 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle cardTitle({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      );

  static TextStyle cardSubtitle({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      );

  static TextStyle formLabel({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      );

  static TextStyle formHint({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color:
            isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      );

  static TextStyle errorText({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: isDark
            ? AppColors.darkColorScheme.error
            : AppColors.lightColorScheme.error,
      );

  static TextStyle successText({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
      );

  static TextStyle warningText({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: isDark ? AppColors.darkWarning : AppColors.lightWarning,
      );

  static TextStyle infoText({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: isDark ? AppColors.darkInfo : AppColors.lightInfo,
      );
}
