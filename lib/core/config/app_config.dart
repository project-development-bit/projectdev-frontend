import 'app_flavor.dart';

/// Configuration class that holds environment-specific settings
class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String apiBaseUrl;
  final String apiVersion;
  final bool enableLogging;
  final bool enableCrashReporting;
  final bool enableAnalytics;
  final bool enableDebugFeatures;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, dynamic> additionalConfig;

  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    this.apiVersion = 'v1',
    required this.enableLogging,
    required this.enableCrashReporting,
    required this.enableAnalytics,
    required this.enableDebugFeatures,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.additionalConfig = const {},
  });

  /// Development configuration
  static const AppConfig dev = AppConfig(
    flavor: AppFlavor.dev,
    appName: 'Burger Eats (Dev)',
    apiBaseUrl: 'https://api-dev.burgereats.com',
    apiVersion: 'v1',
    enableLogging: true,
    enableCrashReporting: false,
    enableAnalytics: false,
    enableDebugFeatures: true,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    sendTimeout: Duration(seconds: 10),
    additionalConfig: {
      'debugShowCheckedModeBanner': true,
      'debugShowMaterialGrid': false,
      'showPerformanceOverlay': false,
      'showSemanticsDebugger': false,
      'maxLogLevel': 'debug',
      'enableMockData': true,
      'enableFeatureFlags': true,
    },
  );

  /// Staging configuration
  static const AppConfig staging = AppConfig(
    flavor: AppFlavor.staging,
    appName: 'Burger Eats (Staging)',
    apiBaseUrl: 'https://api-staging.burgereats.com',
    apiVersion: 'v1',
    enableLogging: true,
    enableCrashReporting: true,
    enableAnalytics: false,
    enableDebugFeatures: true,
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
    sendTimeout: Duration(seconds: 20),
    additionalConfig: {
      'debugShowCheckedModeBanner': false,
      'debugShowMaterialGrid': false,
      'showPerformanceOverlay': false,
      'showSemanticsDebugger': false,
      'maxLogLevel': 'info',
      'enableMockData': false,
      'enableFeatureFlags': true,
    },
  );

  /// Production configuration
  static const AppConfig prod = AppConfig(
    flavor: AppFlavor.prod,
    appName: 'Burger Eats',
    apiBaseUrl: 'https://api.burgereats.com',
    apiVersion: 'v1',
    enableLogging: false,
    enableCrashReporting: true,
    enableAnalytics: true,
    enableDebugFeatures: false,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
    additionalConfig: {
      'debugShowCheckedModeBanner': false,
      'debugShowMaterialGrid': false,
      'showPerformanceOverlay': false,
      'showSemanticsDebugger': false,
      'maxLogLevel': 'error',
      'enableMockData': false,
      'enableFeatureFlags': false,
    },
  );

  /// Get configuration based on flavor
  static AppConfig getConfig(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return dev;
      case AppFlavor.staging:
        return staging;
      case AppFlavor.prod:
        return prod;
    }
  }

  /// Check if a feature is enabled
  bool isFeatureEnabled(String featureName) {
    return additionalConfig['enableFeatureFlags'] == true &&
        additionalConfig[featureName] == true;
  }

  /// Get a configuration value
  T? getConfigValue<T>(String key) {
    return additionalConfig[key] as T?;
  }

  /// Get the full API URL with version
  String get fullApiUrl => '$apiBaseUrl/$apiVersion';

  /// Get the app display name
  String get displayName => appName;

  /// Get bundle ID suffix
  String get bundleIdSuffix => flavor.appSuffix;

  /// Check if this is a debug build
  bool get isDebugBuild => enableDebugFeatures;

  /// Check if this is a release build
  bool get isReleaseBuild => !enableDebugFeatures;

  @override
  String toString() {
    return 'AppConfig(flavor: ${flavor.name}, appName: $appName, apiBaseUrl: $apiBaseUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppConfig &&
        other.flavor == flavor &&
        other.appName == appName &&
        other.apiBaseUrl == apiBaseUrl;
  }

  @override
  int get hashCode {
    return flavor.hashCode ^ appName.hashCode ^ apiBaseUrl.hashCode;
  }
}