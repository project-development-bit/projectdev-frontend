import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system based on Gigafaucet website
/// Uses "Orbitron" for titles/headers and "Barlow" for normal text
class AppTypography {
  AppTypography._();

  // Font Families from Gigafaucet website
  static String get titleFontFamily =>
      'Orbitron'; // For titles, captions, headers
  static String get bodyFontFamily => 'Barlow'; // For normal text
  static String get monoFontFamily => 'Roboto Mono';

  // Base Text Styles for Light Theme
  static TextStyle get displayLarge => GoogleFonts.orbitron(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: AppColors.primary,
        height: 1.12,
      );

  static TextStyle get displayMedium => GoogleFonts.orbitron(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.primary,
        height: 1.16,
      );

  static TextStyle get displaySmall => GoogleFonts.orbitron(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.primary,
        height: 1.22,
      );

  static TextStyle get headlineLarge => GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.websiteAccent,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.websiteAccent,
        height: 1.29,
      );

  static TextStyle get headlineSmall => GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.websiteAccent,
        height: 1.33,
      );

  static TextStyle get titleLarge => GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.primaryColor,
        height: 1.27,
      );

  static TextStyle get titleMedium => GoogleFonts.orbitron(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: AppColors.primaryColor,
        height: 1.50,
      );

  static TextStyle get titleSmall => GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.primaryColor,
        height: 1.43,
      );

  static TextStyle get labelLarge => GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.websiteText,
        height: 1.43,
      );

  static TextStyle get labelMedium => GoogleFonts.orbitron(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.websiteText,
        height: 1.33,
      );

  static TextStyle get labelSmall => GoogleFonts.orbitron(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.websiteText,
        height: 1.45,
      );

  static TextStyle get bodyLarge => GoogleFonts.barlow(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.websiteText,
        height: 1.50,
      );

  static TextStyle get bodyMedium => GoogleFonts.barlow(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.websiteText,
        height: 1.43,
      );

  static TextStyle get bodySmall => GoogleFonts.barlow(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.websiteText,
        height: 1.33,
      );

  // Dark Theme Text Styles
  static TextStyle get displayLargeDark => displayLarge.copyWith(
        color: AppColors.primaryLight,
      );

  static TextStyle get displayMediumDark => displayMedium.copyWith(
        color: AppColors.primaryLight,
      );

  static TextStyle get displaySmallDark => displaySmall.copyWith(
        color: AppColors.primaryLight,
      );

  static TextStyle get headlineLargeDark => headlineLarge.copyWith(
        color: AppColors.websiteGold,
      );

  static TextStyle get headlineMediumDark => headlineMedium.copyWith(
        color: AppColors.websiteGold,
      );

  static TextStyle get headlineSmallDark => headlineSmall.copyWith(
        color: AppColors.websiteGold,
      );

  static TextStyle get titleLargeDark => titleLarge.copyWith(
        color: AppColors.darkTextPrimary,
      );

  static TextStyle get titleMediumDark => titleMedium.copyWith(
        color: AppColors.darkTextPrimary,
      );

  static TextStyle get titleSmallDark => titleSmall.copyWith(
        color: AppColors.darkTextPrimary,
      );

  static TextStyle get labelLargeDark => labelLarge.copyWith(
        color: AppColors.websiteText,
      );

  static TextStyle get labelMediumDark => labelMedium.copyWith(
        color: AppColors.websiteText,
      );

  static TextStyle get labelSmallDark => labelSmall.copyWith(
        color: AppColors.websiteText,
      );

  static TextStyle get bodyLargeDark => bodyLarge.copyWith(
        color: AppColors.websiteText,
      );

  static TextStyle get bodyMediumDark => bodyMedium.copyWith(
        color: AppColors.websiteText,
      );

  static TextStyle get bodySmallDark => bodySmall.copyWith(
        color: AppColors.websiteText,
      );

  // Special styles for cryptocurrency/gaming theme
  static TextStyle get cryptoDisplay => GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.websiteGold,
        letterSpacing: 1.0,
        shadows: [
          const Shadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            color: AppColors.lightTextPrimary,
          ),
        ],
      );

  static TextStyle get cryptoAmount => GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryLight,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonText => GoogleFonts.orbitron(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get captionText => GoogleFonts.barlow(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.websiteText,
        letterSpacing: 0.4,
      );

  // Monospace styles for addresses and technical info
  static TextStyle get monospace => GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.websiteText,
        letterSpacing: 0,
      );

  static TextStyle get monospaceBold => GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryLight,
        letterSpacing: 0,
      );

  // Text themes for Material Theme
  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
      );

  static TextTheme get darkTextTheme => TextTheme(
        displayLarge: displayLargeDark,
        displayMedium: displayMediumDark,
        displaySmall: displaySmallDark,
        headlineLarge: headlineLargeDark,
        headlineMedium: headlineMediumDark,
        headlineSmall: headlineSmallDark,
        titleLarge: titleLargeDark,
        titleMedium: titleMediumDark,
        titleSmall: titleSmallDark,
        labelLarge: labelLargeDark,
        labelMedium: labelMediumDark,
        labelSmall: labelSmallDark,
        bodyLarge: bodyLargeDark,
        bodyMedium: bodyMediumDark,
        bodySmall: bodySmallDark,
      );
}

/// Extension methods for typography
extension AppTypographyExtension on TextStyle {
  /// Apply website-style glow effect
  TextStyle withGlow({Color? glowColor, double blurRadius = 4.0}) {
    return copyWith(
      shadows: [
        Shadow(
          offset: const Offset(0, 0),
          blurRadius: blurRadius,
          color: glowColor ?? AppColors.primaryLight,
        ),
      ],
    );
  }

  /// Apply website-style shadow
  TextStyle withWebsiteShadow() {
    return copyWith(
      shadows: [
        const Shadow(
          offset: Offset(2, 2),
          blurRadius: 4,
          color: AppColors.lightTextPrimary,
        ),
      ],
    );
  }

  /// Apply gradient color (for display text)
  TextStyle withGradient() {
    return copyWith(
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: [
            AppColors.primaryLight,
            AppColors.primary,
          ],
        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
    );
  }
}
