import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_flavor.dart';
import 'app_config.dart';

/// Flavor manager that holds the current flavor and configuration
class FlavorManager {
  static AppFlavor _currentFlavor = AppFlavor.dev;
  static AppConfig _currentConfig = AppConfig.dev;

  /// Get the current flavor
  static AppFlavor get currentFlavor => _currentFlavor;

  /// Get the current configuration
  static AppConfig get currentConfig => _currentConfig;

  /// Set the current flavor and update configuration
  static void setFlavor(AppFlavor flavor) {
    _currentFlavor = flavor;
    _currentConfig = AppConfig.getConfig(flavor);
  }

  /// Initialize the flavor manager with a specific flavor
  static void initialize(AppFlavor flavor) {
    setFlavor(flavor);
  }

  /// Check if a specific flavor is currently active
  static bool isFlavor(AppFlavor flavor) => _currentFlavor == flavor;

  /// Check if development flavor is active
  static bool get isDev => _currentFlavor == AppFlavor.dev;

  /// Check if staging flavor is active
  static bool get isStaging => _currentFlavor == AppFlavor.staging;

  /// Check if production flavor is active
  static bool get isProd => _currentFlavor == AppFlavor.prod;

  /// Get flavor display name
  static String get flavorDisplayName => _currentFlavor.displayName;

  /// Get flavor name
  static String get flavorName => _currentFlavor.name;

  /// Get app name for current flavor
  static String get appName => _currentConfig.appName;

  /// Get API base URL for current flavor
  static String get apiBaseUrl => _currentConfig.apiBaseUrl;

  /// Get full API URL for current flavor
  static String get fullApiUrl => _currentConfig.fullApiUrl;

  /// Check if logging is enabled
  static bool get isLoggingEnabled => _currentConfig.enableLogging;

  /// Check if debug features are enabled
  static bool get areDebugFeaturesEnabled => _currentConfig.enableDebugFeatures;

  /// Check if crash reporting is enabled
  static bool get isCrashReportingEnabled => _currentConfig.enableCrashReporting;

  /// Check if analytics is enabled
  static bool get isAnalyticsEnabled => _currentConfig.enableAnalytics;

  /// Get a configuration value
  static T? getConfigValue<T>(String key) => _currentConfig.getConfigValue<T>(key);

  /// Check if a feature is enabled
  static bool isFeatureEnabled(String featureName) => 
      _currentConfig.isFeatureEnabled(featureName);

  /// Get timeout durations
  static Duration get connectTimeout => _currentConfig.connectTimeout;
  static Duration get receiveTimeout => _currentConfig.receiveTimeout;
  static Duration get sendTimeout => _currentConfig.sendTimeout;

  /// Get reCAPTCHA site key for current flavor
  static String? get recaptchaSiteKey => _currentConfig.recaptchaSiteKey;
}

/// Provider for the current flavor
final flavorProvider = Provider<AppFlavor>((ref) {
  return FlavorManager.currentFlavor;
});

/// Provider for the current configuration
final configProvider = Provider<AppConfig>((ref) {
  return FlavorManager.currentConfig;
});

/// Provider for checking if development flavor is active
final isDevFlavorProvider = Provider<bool>((ref) {
  return FlavorManager.isDev;
});

/// Provider for checking if staging flavor is active
final isStagingFlavorProvider = Provider<bool>((ref) {
  return FlavorManager.isStaging;
});

/// Provider for checking if production flavor is active
final isProdFlavorProvider = Provider<bool>((ref) {
  return FlavorManager.isProd;
});

/// Provider for getting the app name
final appNameProvider = Provider<String>((ref) {
  return FlavorManager.appName;
});

/// Provider for getting the API base URL
final apiBaseUrlProvider = Provider<String>((ref) {
  return FlavorManager.apiBaseUrl;
});

/// Provider for checking if logging is enabled
final loggingEnabledProvider = Provider<bool>((ref) {
  return FlavorManager.isLoggingEnabled;
});

/// Provider for checking if debug features are enabled
final debugFeaturesEnabledProvider = Provider<bool>((ref) {
  return FlavorManager.areDebugFeaturesEnabled;
});