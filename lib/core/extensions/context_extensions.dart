import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/theme/app_colors.dart';
import 'package:gigafaucet/core/common/widgets/custom_pointer_interceptor.dart';
import 'package:gigafaucet/features/user_profile/presentation/widgets/dialogs/dialog_scaffold_widget.dart';
import 'package:gigafaucet/main_common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/localization/data/helpers/app_localizations.dart';
import '../../routing/app_router.dart';
import '../../features/auth/presentation/widgets/two_factor_auth_dialog.dart';

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
  // double get textScaleFactor => mediaQuery.textScaleFactor;

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

  /// Pop the current route (using Navigator)
  void popRoute<T>([T? result]) => navigator.pop(result);

  /// Push a new route
  Future<T?> push<T>(Route<T> route) => navigator.push(route);

  /// Push and replace current route
  Future<T?> pushReplacement<T, TO>(Route<T> newRoute, {TO? result}) =>
      navigator.pushReplacement(newRoute, result: result);

  /// Push and remove all previous routes
  Future<T?> pushAndRemoveUntil<T>(
          Route<T> newRoute, bool Function(Route<dynamic>) predicate) =>
      navigator.pushAndRemoveUntil(newRoute, predicate);

  /// Pop until a specific route
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      navigator.popUntil(predicate);

  /// Check if can pop
  bool get canPop => navigator.canPop();

  // GoRouter navigation extensions - Go (replace current route)
  void goToHome() => GoRouter.of(this).go(AppRoutes.home);
  void goToLogin() => GoRouter.of(this).go(AppRoutes.login);
  void goToSignUp() => GoRouter.of(this).go(AppRoutes.signUp);
  void goToOffers() => GoRouter.of(this).go(AppRoutes.offers);
  void goToDashboard() => GoRouter.of(this).go(AppRoutes.dashboard);
  void goToForgotPassword() => GoRouter.of(this).go(AppRoutes.forgotPassword);

  // GoRouter navigation extensions - Push (add to navigation stack)
  Future<T?> pushToHome<T extends Object?>() =>
      GoRouter.of(this).push<T>(AppRoutes.home);
  Future<T?> pushToLogin<T extends Object?>() =>
      GoRouter.of(this).push<T>(AppRoutes.login);
  Future<T?> pushToSignUp<T extends Object?>() =>
      GoRouter.of(this).push<T>(AppRoutes.signUp);
  Future<T?> pushToOffers<T extends Object?>() =>
      GoRouter.of(this).push<T>(AppRoutes.offers);
  Future<T?> pushToDashboard<T extends Object?>() =>
      GoRouter.of(this).push<T>(AppRoutes.dashboard);
  Future<T?> pushToForgotPassword<T extends Object?>() =>
      GoRouter.of(this).push<T>(AppRoutes.forgotPassword);

  // GoRouter navigation extensions - PushNamed (using named routes)
  Future<T?> pushNamedHome<T extends Object?>({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).pushNamed<T>(
        'home',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  Future<T?> pushNamedLogin<T extends Object?>({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).pushNamed<T>(
        'login',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  Future<T?> pushNamedSignUp<T extends Object?>({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).pushNamed<T>(
        'signup',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  Future<T?> pushNamedProfile<T extends Object?>({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).pushNamed<T>(
        'profile',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  Future<T?> pushNamedChat<T extends Object?>({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).pushNamed<T>(
        'chat',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  Future<T?> pushNamedForgotPassword<T extends Object?>({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).pushNamed<T>(
        'forgot-password',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  // GoNamed navigation extensions (using named routes with go)
  void goNamedHome({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).goNamed(
        'home',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  void goNamedLogin({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).goNamed(
        'login',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  void goNamedSignUp({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).goNamed(
        'signup',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  void goNamedProfile({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).goNamed(
        'profile',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  void goNamedForgotPassword({
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(this).goNamed(
        'forgot-password',
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
}

/// Extension on BuildContext for showing dialogs and snackbars
extension DialogExtension on BuildContext {
  /// showManagePopup

  Future<T> showManagePopup<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    final barrierColor = colorScheme.scrim.withValues(alpha: 0.6);
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => CustomPointerInterceptor(
        child: DialogScaffoldWidget(
          child: child,
        ),
      ),
    ).then((value) => value as T);
  }

  Future<T> showAffiliateProgramPopup<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    final barrierColor = colorScheme.scrim.withValues(alpha: 0.6);
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => CustomPointerInterceptor(
        child: DialogScaffoldWidget(
          child: child,
        ),
      ),
    ).then((value) => value as T);
  }

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
      child: CustomPointerInterceptor(
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () => GoRouter.of(this).pop(false),
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: () => GoRouter.of(this).pop(true),
              child: Text(confirmText),
            ),
          ],
        ),
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
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    try {
      // Use Overlay to show snackbar above dialogs
      final overlay = Overlay.of(this, rootOverlay: true);

      late OverlayEntry overlayEntry;
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: backgroundColor ??
                    Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CommonText(
                      message,
                      color: textColor ??
                          Theme.of(context).colorScheme.onInverseSurface,
                    ),
                  ),
                  if (action != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        action.onPressed();
                        overlayEntry.remove();
                      },
                      child: Text(action.label),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      // Auto remove after duration
      Future.delayed(duration, () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      });
    } catch (e) {
      debugPrint('Error showing snackbar: $e');
      // Fallback to scaffold messenger
      try {
        final messenger = rootScaffoldMessengerKey.currentState;
        if (messenger != null) {
          messenger.clearSnackBars();
          messenger.showSnackBar(
            SnackBar(
              content: CommonText(
                message,
                color: textColor,
              ),
              duration: duration,
              action: action,
              backgroundColor: backgroundColor,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ),
            ),
          );
        }
      } catch (fallbackError) {
        debugPrint('Fallback snackbar also failed: $fallbackError');
      }
    }
  }

  /// Show an error snackbar
  void showErrorSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 2),
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
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    showSnackBar(
      message: message,
      duration: duration,
      action: action,
      backgroundColor: AppColors.success,
      textColor: AppColors.darkTextPrimary,
    );
  }

  /// Show a warning snackbar
  void showWarningSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    showSnackBar(
      message: message,
      duration: duration,
      action: action,
      backgroundColor: AppColors.primary,
      textColor: AppColors.primaryContainer,
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

  /// Show 2FA verification dialog
  Future<bool?> show2FAVerificationDialog({
    String email = "",
    String? sessionToken,
    VoidCallback? onSuccess,
  }) {
    return show2FADialog(
      this,
      email: email,
      sessionToken: sessionToken,
      onSuccess: onSuccess,
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
