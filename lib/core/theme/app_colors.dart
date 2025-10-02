import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6B46C1); // Purple
  static const Color secondaryColor = Color(0xFFEAB308); // Amber
  static const Color tertiaryColor = Color(0xFF06B6D4); // Cyan

  // Light Theme Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6B46C1), // Purple
    onPrimary: Color(0xFFFFFFFF), // White
    primaryContainer: Color(0xFFE9D5FF), // Light Purple
    onPrimaryContainer: Color(0xFF3F1A78), // Dark Purple
    
    secondary: Color(0xFFEAB308), // Amber
    onSecondary: Color(0xFF000000), // Black
    secondaryContainer: Color(0xFFFEF3C7), // Light Amber
    onSecondaryContainer: Color(0xFF92400E), // Dark Amber
    
    tertiary: Color(0xFF06B6D4), // Cyan
    onTertiary: Color(0xFFFFFFFF), // White
    tertiaryContainer: Color(0xFFCFFAFE), // Light Cyan
    onTertiaryContainer: Color(0xFF0E7490), // Dark Cyan
    
    error: Color(0xFFDC2626), // Red
    onError: Color(0xFFFFFFFF), // White
    errorContainer: Color(0xFFFEE2E2), // Light Red
    onErrorContainer: Color(0xFF991B1B), // Dark Red
    
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

  // Dark Theme Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9333EA), // Bright Purple
    onPrimary: Color(0xFF1E1B4B), // Very Dark Purple
    primaryContainer: Color(0xFF4C1D95), // Dark Purple
    onPrimaryContainer: Color(0xFFE9D5FF), // Light Purple
    
    secondary: Color(0xFFFBBF24), // Bright Amber
    onSecondary: Color(0xFF451A03), // Very Dark Amber
    secondaryContainer: Color(0xFF92400E), // Dark Amber
    onSecondaryContainer: Color(0xFFFEF3C7), // Light Amber
    
    tertiary: Color(0xFF22D3EE), // Bright Cyan
    onTertiary: Color(0xFF164E63), // Very Dark Cyan
    tertiaryContainer: Color(0xFF0E7490), // Dark Cyan
    onTertiaryContainer: Color(0xFFCFFAFE), // Light Cyan
    
    error: Color(0xFFF87171), // Bright Red
    onError: Color(0xFF450A0A), // Very Dark Red
    errorContainer: Color(0xFF991B1B), // Dark Red
    onErrorContainer: Color(0xFFFEE2E2), // Light Red
    
    surface: Color(0xFF111827), // Very Dark Gray
    onSurface: Color(0xFFF9FAFB), // Very Light Gray
    surfaceContainerHighest: Color(0xFF374151), // Medium Dark Gray
    onSurfaceVariant: Color(0xFF9CA3AF), // Light Gray
    
    surfaceContainer: Color(0xFF1F2937), // Dark Gray
    surfaceContainerHigh: Color(0xFF374151), // Medium Dark Gray
    surfaceContainerLow: Color(0xFF0F172A), // Very Dark Gray
    
    outline: Color(0xFF4B5563), // Border Dark Gray
    outlineVariant: Color(0xFF374151), // Dark Border Gray
    
    shadow: Color(0xFF000000), // Black
    scrim: Color(0xFF000000), // Black
    
    inverseSurface: Color(0xFFF9FAFB), // Very Light Gray
    onInverseSurface: Color(0xFF111827), // Very Dark Gray
    inversePrimary: Color(0xFF6B46C1), // Purple
  );

  // Additional Brand Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange
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