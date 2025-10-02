# Theme System Documentation

This document explains how to use the comprehensive theme system with dark/light mode support and convenient context extensions.

## Features

✅ **Complete Dark/Light Theme Support**
✅ **Material 3 Design System**
✅ **Context Extensions for Easy Access**
✅ **Theme Provider with Persistence**
✅ **Custom Text Themes**
✅ **Responsive Helpers**
✅ **Navigation Extensions**
✅ **Dialog & SnackBar Extensions**

## File Structure

```
lib/core/
├── theme/
│   ├── app_colors.dart       # Color schemes for light/dark themes
│   ├── app_theme.dart        # Main theme configuration
│   ├── text_theme.dart       # Custom text styles
│   └── theme.dart            # Export file
├── providers/
│   └── theme_provider.dart   # Theme state management
├── widgets/
│   └── theme_switch_widget.dart # Theme switching widgets
├── extensions/
│   ├── context_extensions.dart  # Context extensions
│   └── extensions.dart          # Export file
└── examples/
    └── text_theme_example.dart # Usage examples
```

## Quick Setup

### 1. Update main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme.dart';
import 'core/providers/theme_provider.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.getEffectiveThemeMode(
        MediaQuery.platformBrightnessOf(context),
      ),
      // ... rest of your app configuration
    );
  }
}
```

### 2. Import Extensions

```dart
import 'package:your_app/core/extensions/extensions.dart';
```

## Usage Examples

### Text Styles (Before vs After)

**Before:**
```dart
Text(
  'Hello World',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: Theme.of(context).colorScheme.primary,
  ),
)
```

**After:**
```dart
Text(
  'Hello World',
  style: context.bodyLarge?.copyWith(
    color: context.primary,
  ),
)
```

### Available Text Style Extensions

```dart
context.displayLarge       // For hero text
context.displayMedium      // For large headers
context.displaySmall       // For medium headers

context.headlineLarge      // For page titles
context.headlineMedium     // For section titles
context.headlineSmall      // For subsection titles

context.titleLarge         // For card titles
context.titleMedium        // For list item titles
context.titleSmall         // For small titles

context.bodyLarge          // For main content (most used)
context.bodyMedium         // For secondary content
context.bodySmall          // For captions

context.labelLarge         // For button text
context.labelMedium        // For small buttons
context.labelSmall         // For tags/chips
```

### Color Extensions

```dart
// Primary colors
Container(color: context.primary)
Text('Text', style: TextStyle(color: context.onPrimary))

// Surface colors
Container(color: context.surface)
Container(color: context.surfaceContainer)
Container(color: context.surfaceContainerHigh)

// Semantic colors
Container(color: context.error)
Container(color: context.secondary)
Container(color: context.tertiary)
```

### Responsive Extensions

```dart
// Screen size checks
if (context.isMobile) {
  // Mobile layout
} else if (context.isTablet) {
  // Tablet layout
} else if (context.isDesktop) {
  // Desktop layout
}

// Screen dimensions
double width = context.screenWidth;
double height = context.screenHeight;

// Percentage-based sizing
double halfWidth = context.widthPercent(50);
double quarterHeight = context.heightPercent(25);

// Responsive font sizing
double fontSize = context.responsiveFontSize(16);
```

### Theme Detection

```dart
// Check current theme
if (context.isDark) {
  // Dark theme specific code
} else {
  // Light theme specific code
}

// Get theme brightness
Brightness current = context.theme.brightness;
Brightness opposite = context.oppositeBrightness;
```

### Navigation Extensions

```dart
// Instead of Navigator.of(context).pop()
context.pop();

// Instead of Navigator.of(context).push()
context.push(MaterialPageRoute(
  builder: (context) => MyPage(),
));

// Check if can pop
if (context.canPop) {
  context.pop();
}
```

### Dialog & SnackBar Extensions

```dart
// Show alert dialog
context.showAlertDialog(
  title: 'Alert',
  content: 'This is an alert message',
);

// Show confirmation dialog
bool? confirmed = await context.showConfirmDialog(
  title: 'Confirm',
  content: 'Are you sure?',
);

// Show snackbars
context.showSnackBar(message: 'General message');
context.showSuccessSnackBar(message: 'Success!');
context.showErrorSnackBar(message: 'Error occurred');
context.showWarningSnackBar(message: 'Warning!');

// Show bottom sheet
context.showBottomSheet(
  child: Container(
    height: 200,
    child: Text('Bottom sheet content'),
  ),
);
```

### Media Query Extensions

```dart
// Padding and safe areas
EdgeInsets padding = context.padding;
double topSafeArea = context.safeAreaTop;
bool keyboardOpen = context.isKeyboardOpen;

// Device info
bool isPortrait = context.isPortrait;
bool isLandscape = context.isLandscape;
double pixelRatio = context.devicePixelRatio;
```

## Theme Switching Widgets

### Basic Theme Toggle

```dart
ThemeToggleButton() // Simple icon button to toggle theme
```

### Theme Dropdown

```dart
ThemeSwitchWidget() // Dropdown with Light/Dark/System options
```

### Theme Settings Card

```dart
ThemeSelectorCard() // Complete theme selection interface
```

### Switch Tile

```dart
ThemeSwitchTile(
  title: 'Dark Mode',
  subtitle: 'Enable dark theme',
)
```

## Theme Provider Usage

```dart
// Watch theme changes
final currentTheme = ref.watch(themeProvider);

// Change theme
final themeNotifier = ref.read(themeProvider.notifier);
await themeNotifier.setThemeMode(AppThemeMode.dark);

// Toggle between light/dark
await themeNotifier.toggleTheme();

// Check if dark theme
bool isDark = ref.read(isDarkThemeProvider);
```

## Advanced Usage

### Custom Text Styles

```dart
// Use custom text styles from AppTextTheme
Text(
  'Brand Text',
  style: AppTextTheme.brandText(
    color: context.primary,
    fontSize: 32,
  ),
)

// Form-specific styles
Text(
  'Form Label',
  style: AppTextTheme.formLabel(isDark: context.isDark),
)

// Status-specific styles
Text(
  'Error Message',
  style: AppTextTheme.errorText(isDark: context.isDark),
)
```

### Custom Colors

```dart
// Access additional brand colors
Container(color: AppColors.success)
Container(color: AppColors.warning)
Container(color: AppColors.info)

// Use gradients
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)
```

### Responsive Design

```dart
Widget build(BuildContext context) {
  return Container(
    width: context.isMobile ? context.screenWidth : 600,
    padding: EdgeInsets.all(context.isMobile ? 16 : 24),
    child: Text(
      'Responsive Text',
      style: context.bodyLarge?.copyWith(
        fontSize: context.responsiveFontSize(16),
      ),
    ),
  );
}
```

## Best Practices

1. **Always use context extensions** instead of `Theme.of(context)` or `MediaQuery.of(context)`
2. **Use semantic colors** (primary, secondary, surface) instead of hardcoded colors
3. **Test both light and dark themes** during development
4. **Use responsive helpers** for different screen sizes
5. **Prefer bodyLarge for main content** and titleMedium for titles
6. **Use the theme provider** for persistent theme settings

## Migration Guide

To migrate existing code:

1. Replace `Theme.of(context).textTheme.bodyLarge` with `context.bodyLarge`
2. Replace `Theme.of(context).colorScheme.primary` with `context.primary`
3. Replace `MediaQuery.of(context).size.width` with `context.screenWidth`
4. Replace `Navigator.of(context).pop()` with `context.pop()`
5. Replace manual dialog/snackbar code with context extensions

## Troubleshooting

**Issue:** Extensions not available
**Solution:** Import `'package:your_app/core/extensions/extensions.dart'`

**Issue:** Theme not persisting
**Solution:** Ensure SharedPreferences is properly initialized in main()

**Issue:** Colors not updating
**Solution:** Make sure to watch the theme provider in consumer widgets

**Issue:** Responsive breakpoints not working
**Solution:** Check that MediaQuery is available in the widget tree