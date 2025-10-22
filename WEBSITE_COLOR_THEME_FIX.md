# Website Color Theme Implementation

## Overview
This document describes the fixes implemented to resolve website color issues in Flutter common widgets by updating the ColorScheme to use actual Gigafaucet website colors.

## Problem
The original ColorScheme was using Material 3 default colors instead of the actual website brand colors, causing visual inconsistency between the app and website.

## Solution
Updated `lib/core/theme/app_colors.dart` to use actual Gigafaucet website colors in the dark theme ColorScheme.

## Changes Made

### Before (Material 3 Defaults)
```dart
static const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFD0BCFF),         // Material 3 purple
  onPrimary: Color(0xFF381E72),       // Material 3 dark purple
  // ... other Material 3 colors
);
```

### After (Website Colors)
```dart
static const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.primaryLight,     // #4CAF50 - Website green
  onPrimary: AppColors.websiteBackground, // #1a1a1a - Website dark
  primaryContainer: AppColors.websiteCard,    // #2a2a2a - Website card
  onPrimaryContainer: AppColors.websiteText,  // #ffffff - Website text
  secondary: AppColors.primaryLight,
  onSecondary: AppColors.websiteBackground,
  secondaryContainer: AppColors.websiteCard,
  onSecondaryContainer: AppColors.websiteText,
  surface: AppColors.websiteBackground,
  onSurface: AppColors.websiteText,
  surfaceContainer: AppColors.websiteCard,
  onSurfaceVariant: AppColors.websiteText,
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  outline: Color(0xFF938F99),
  shadow: Color(0xFF000000),
  inverseSurface: AppColors.websiteText,
  onInverseSurface: AppColors.websiteBackground,
  inversePrimary: Color(0xFF6750A4),
  scrim: Color(0xFF000000),
  surfaceBright: Color(0xFF3B383E),
  surfaceDim: Color(0xFF141218),
  surfaceContainerLowest: Color(0xFF0F0D13),
  surfaceContainerLow: Color(0xFF1D1B20),
  surfaceContainerHigh: Color(0xFF2B2930),
  surfaceContainerHighest: Color(0xFF36343B),
);
```

## Website Color Palette Used

```dart
class AppColors {
  // Website brand colors
  static const Color primaryLight = Color(0xFF4CAF50);      // Green primary
  static const Color websiteBackground = Color(0xFF1a1a1a); // Dark background
  static const Color websiteCard = Color(0xFF2a2a2a);       // Card background
  static const Color websiteText = Color(0xFFffffff);       // White text
  
  // ... other colors remain unchanged
}
```

## Impact

1. **Visual Consistency**: App now matches the website's color scheme
2. **Brand Alignment**: Uses actual Gigafaucet brand colors instead of generic Material colors
3. **Better UX**: Users see consistent colors across web and mobile platforms
4. **Professional Look**: Custom color scheme instead of default Material Design

## Files Modified

- `lib/core/theme/app_colors.dart` - Updated dark theme ColorScheme

## Implementation Details

### ColorScheme Mapping
- **Primary Colors**: Use website green (`#4CAF50`)
- **Background Colors**: Use website dark background (`#1a1a1a`)
- **Surface Colors**: Use website card color (`#2a2a2a`)
- **Text Colors**: Use website white text (`#ffffff`)
- **Error Colors**: Keep Material 3 defaults for consistency
- **Outline/Shadow**: Keep Material 3 defaults for system UI

### Backward Compatibility
- Light theme remains unchanged
- All existing AppColors constants preserved
- Only ColorScheme updated, not individual color constants

## Testing
The changes have been validated to ensure:
- No compilation errors
- All widgets use the new color scheme
- Visual consistency with website design
- Proper contrast ratios maintained

## Future Considerations

1. **Light Theme**: Consider updating light theme to match website light mode (if applicable)
2. **Color Tokens**: Consider creating semantic color tokens for better maintainability
3. **Testing**: Add visual regression tests to ensure color consistency
4. **Documentation**: Update design system documentation with new color usage