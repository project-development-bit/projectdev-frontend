import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

/// Extension on BuildContext to provide easy access to text styles
extension TextThemeExtension on BuildContext {
  /// Access to the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Display text styles
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;

  // Headline text styles
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  // Title text styles
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;

  // Body text styles (most commonly used)
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;

  // Label text styles
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
}

/// Extension on BuildContext to provide easy access to color scheme
extension ColorSchemeExtension on BuildContext {
  /// Access to the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Primary colors
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  // Secondary colors
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  // Tertiary colors
  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  // Error colors
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;

  // Surface colors
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get surfaceContainer => colorScheme.surfaceContainer;
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;
  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  // Outline colors
  Color get outline => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;

  // Other colors
  Color get shadow => colorScheme.shadow;
  Color get scrim => colorScheme.scrim;
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onInverseSurface => colorScheme.onInverseSurface;
  Color get inversePrimary => colorScheme.inversePrimary;
}

/// Extension on BuildContext to provide easy access to theme properties
extension ThemeExtension on BuildContext {
  /// Access to the current theme
  ThemeData get theme => Theme.of(this);

  /// Check if the current theme is dark
  bool get isDark => theme.brightness == Brightness.dark;

  /// Check if the current theme is light
  bool get isLight => theme.brightness == Brightness.light;

  /// Get the opposite brightness
  Brightness get oppositeBrightness => 
      isDark ? Brightness.light : Brightness.dark;
}

/// Extension on BuildContext to provide easy access to media query
extension MediaQueryExtension on BuildContext {
  /// Access to the current media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen size
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// Screen padding
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Text scale factor
  double get textScaleFactor => mediaQuery.textScaleFactor;

  /// Platform brightness
  Brightness get platformBrightness => mediaQuery.platformBrightness;

  /// Check if keyboard is open
  bool get isKeyboardOpen => viewInsets.bottom > 0;

  /// Safe area dimensions
  double get safeAreaTop => padding.top;
  double get safeAreaBottom => padding.bottom;
  double get safeAreaLeft => padding.left;
  double get safeAreaRight => padding.right;

  /// Responsive breakpoints
  bool get isMobile => screenWidth < 768;
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Device orientation
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Responsive width helpers
  double widthPercent(double percent) => screenWidth * (percent / 100);
  double heightPercent(double percent) => screenHeight * (percent / 100);

  /// Responsive font size based on screen width
  double responsiveFontSize(double baseFontSize) {
    if (isMobile) return baseFontSize;
    if (isTablet) return baseFontSize * 1.1;
    return baseFontSize * 1.2;
  }
}

/// Extension on BuildContext for navigation
extension NavigationExtension on BuildContext {
  /// Navigator
  NavigatorState get navigator => Navigator.of(this);

  /// Pop the current route
  void pop<T>([T? result]) => navigator.pop(result);

  /// Push a new route
  Future<T?> push<T>(Route<T> route) => navigator.push(route);

  /// Push and replace current route
  Future<T?> pushReplacement<T, TO>(Route<T> newRoute, {TO? result}) =>
      navigator.pushReplacement(newRoute, result: result);

  /// Push and remove all previous routes
  Future<T?> pushAndRemoveUntil<T>(Route<T> newRoute, bool Function(Route<dynamic>) predicate) =>
      navigator.pushAndRemoveUntil(newRoute, predicate);

  /// Pop until a specific route
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      navigator.popUntil(predicate);

  /// Check if can pop
  bool get canPop => navigator.canPop();
}

/// Extension on BuildContext for showing dialogs and snackbars
extension DialogExtension on BuildContext {
  /// Show a material dialog
  Future<T?> showMaterialDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color? barrierColor,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }

  /// Show a simple alert dialog
  Future<bool?> showAlertDialog({
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
  }) {
    return showMaterialDialog<bool>(
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => pop(false),
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () => pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show a confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showAlertDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }

  /// Show a snackbar
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show an error snackbar
  void showErrorSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    showSnackBar(
      message: message,
      duration: duration,
      action: action,
      backgroundColor: error,
      textColor: onError,
    );
  }

  /// Show a success snackbar
  void showSuccessSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    showSnackBar(
      message: message,
      duration: duration,
      action: action,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show a warning snackbar
  void showWarningSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    showSnackBar(
      message: message,
      duration: duration,
      action: action,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Show bottom sheet
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (context) => child,
    );
  }
}

/// Extension on BuildContext to provide easy access to localized strings
extension LocalizationExtension on BuildContext {
  /// Get the current app localizations instance
  AppLocalizations? get l10n => AppLocalizations.of(this);

  /// Translate a key with optional arguments
  String translate(String key, {List<String>? args}) {
    return l10n?.translate(key, args: args) ?? key;
  }
}
