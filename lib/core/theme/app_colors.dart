import 'package:flutter/material.dart';

/// Gigafaucet App color palette extracted from the website
/// https://doc.gigafaucet.com/doc/
class AppColors {
  AppColors._();

  // Primary Brand Colors - Based on Gigafaucet website
  static const Color primary = Color(0xFFE8631C); // Orange brand color
  static const Color primaryDark = Color(0xFFCF7A11);
  static const Color primaryLight = Color(0xFFE6A030);
  static const Color primaryContainer = Color(0xFFFFF3E0);

  // Legacy brand colors for compatibility
  static const Color primaryColor = Color(0xFFE8631C); // Orange
  static const Color secondaryColor = Color(0xFF313144); // Dark blue-grey
  static const Color tertiaryColor = Color(0xFFB0251A); // Red accent

  // Website Specific Colors
  static const Color websiteBackground = Color(0xFF050317); // Dark background
  static const Color websiteBackgroundStart = Color(0xFF191921);
  static const Color websiteBackgroundEnd = Color(0xFF050317);
  static const Color websiteCard = Color(0xFF313144); // Card background
  static const Color websiteBorder = Color(0xFF2C2C38); // Border color
  static const Color websiteText = Color(0xFF9692BC); // Light purple text
  static const Color websiteAccent = Color(0xFFB0251A); // Red accent
  static const Color websiteGold = Color(0xFFE6A030); // Gold color

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFE6A030);
  static const Color error = Color(0xFFB0251A);

  // Cryptocurrency Colors
  static const Color bitcoin = Color(0xFFF7931A);
  static const Color ethereum = Color(0xFF627EEA);
  static const Color gold = Color(0xFFE6A030);
  static const Color silver = Color(0xFF9692BC);

  //Transparent Color
  static const Color transparent = Colors.transparent;

  // Light Theme Color Scheme - Using Gigafaucet website colors
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary, // Orange brand color
    onPrimary: Color(0xFFFFFFFF), // White
    primaryContainer: primaryContainer, // Light orange
    onPrimaryContainer: primaryDark, // Dark orange

    secondary: websiteGold, // Gold accent
    onSecondary: Color(0xFF000000), // Black
    secondaryContainer: Color(0xFFFFF3E0), // Light gold
    onSecondaryContainer: Color(0xFF92400E), // Dark gold

    tertiary: silver, // Website silver color
    onTertiary: Color(0xFFFFFFFF), // White
    tertiaryContainer: Color(0xFFF3F4F6), // Light container
    onTertiaryContainer: silver, // Website silver color

    error: error, // Website error color
    onError: Color(0xFFFFFFFF), // White
    errorContainer: Color(0xFFFEE2E2), // Light Red
    onErrorContainer: error, // Website error color

    surface: Color(0xFFFAFAFA), // Very Light Gray
    onSurface: Color(0xFF1F2937), // Dark Gray
    surfaceContainerHighest: Color(0xFFE5E7EB), // Light Gray
    onSurfaceVariant: Color(0xFF6B7280), // Medium Gray

    surfaceContainer: Color(0xFFF3F4F6), // Very Light Gray
    surfaceContainerHigh: Color(0xFFE5E7EB), // Light Gray
    surfaceContainerLow: Color(0xFFF9FAFB), // Off White

    outline: Color(0xFFD1D5DB), // Border Gray
    outlineVariant: Color(0xFFE5E7EB), // Light Border Gray

    shadow: Color(0xFF000000), // Black
    scrim: Color(0xFF000000), // Black

    inverseSurface: Color(0xFF1F2937), // Dark Gray
    onInverseSurface: Color(0xFFFAFAFA), // Light Gray
    inversePrimary: Color(0xFFE9D5FF), // Light Purple
  );

  // Dark Theme Color Scheme - Using Gigafaucet website colors
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight, // Light orange for dark theme
    onPrimary: websiteBackground, // Dark background
    primaryContainer: websiteCard, // Card background
    onPrimaryContainer: websiteText, // Light text

    secondary: websiteGold, // Gold accent
    onSecondary: websiteBackground, // Dark background
    secondaryContainer: websiteCard, // Card background
    onSecondaryContainer: websiteText, // Light text

    tertiary: silver, // Website silver color
    onTertiary: websiteBackground, // Dark background
    tertiaryContainer: websiteCard, // Card background
    onTertiaryContainer: websiteText, // Light text

    error: websiteAccent, // Website red accent
    onError: Color(0xFFFFFFFF), // White
    errorContainer: websiteAccent, // Website red accent
    onErrorContainer: websiteText, // Website light text

    surface: websiteBackground, // Website dark background
    onSurface: websiteText, // Website light text
    surfaceContainerHighest: websiteCard, // Website card background
    onSurfaceVariant: websiteText, // Website light text

    surfaceContainer: websiteCard, // Website card background
    surfaceContainerHigh: websiteCard, // Website card background
    surfaceContainerLow: websiteBackground, // Website dark background

    outline: websiteBorder, // Website border color
    outlineVariant: websiteBorder, // Website border color

    shadow: Color(0xFF000000), // Black
    scrim: Color(0xFF000000), // Black

    inverseSurface: Color(0xFFF9FAFB), // Very Light Gray
    onInverseSurface: Color(0xFF111827), // Very Dark Gray
    inversePrimary: Color(0xFF6B46C1), // Purple
  );

  // Additional Brand Colors
  static const Color info = Color(0xFF3B82F6); // Blue

  // Success Colors for Light Theme
  static const Color lightSuccess = Color(0xFF10B981);
  static const Color lightOnSuccess = Color(0xFFFFFFFF);
  static const Color lightSuccessContainer = Color(0xFFD1FAE5);
  static const Color lightOnSuccessContainer = Color(0xFF065F46);

  // Success Colors for Dark Theme
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkOnSuccess = Color(0xFF064E3B);
  static const Color darkSuccessContainer = Color(0xFF065F46);
  static const Color darkOnSuccessContainer = Color(0xFFD1FAE5);

  // Warning Colors for Light Theme
  static const Color lightWarning = Color(0xFFF59E0B);
  static const Color lightOnWarning = Color(0xFFFFFFFF);
  static const Color lightWarningContainer = Color(0xFFFEF3C7);
  static const Color lightOnWarningContainer = Color(0xFF92400E);

  // Warning Colors for Dark Theme
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkOnWarning = Color(0xFF451A03);
  static const Color darkWarningContainer = Color(0xFF92400E);
  static const Color darkOnWarningContainer = Color(0xFFFEF3C7);

  // Info Colors for Light Theme
  static const Color lightInfo = Color(0xFF3B82F6);
  static const Color lightOnInfo = Color(0xFFFFFFFF);
  static const Color lightInfoContainer = Color(0xFFDBEAFE);
  static const Color lightOnInfoContainer = Color(0xFF1E3A8A);

  // Info Colors for Dark Theme
  static const Color darkInfo = Color(0xFF60A5FA);
  static const Color darkOnInfo = Color(0xFF1E3A8A);
  static const Color darkInfoContainer = Color(0xFF1E3A8A);
  static const Color darkOnInfoContainer = Color(0xFFDBEAFE);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFEAB308), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient welcomeGradient = LinearGradient(
    colors: [
      Color(0xFFFF007F),
      Color(0xFF7F00FF),
      Color(0xFF00FFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // Surface Variants
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);
  static const Color darkSurfaceVariant = Color(0xFF374151);

  // Text Colors
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);

  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);
  static const Color darkTextTertiary = Color(0xFF9CA3AF);

  // Divider Colors
  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color darkDivider = Color(0xFF374151);

  // Disabled Colors
  static const Color lightDisabled = Color(0xFFD1D5DB);
  static const Color darkDisabled = Color(0xFF4B5563);
}
